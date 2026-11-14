#!/usr/bin/env bash
set -euo pipefail
umask 077

ENV_FILE="${ENV_FILE:-./.env}"
APP_SERVICE="mixspace"
DB_SERVICE="mixspace-postgres"

read_env_value() {
  local key="$1"
  if [[ ! -f "$ENV_FILE" ]]; then
    return
  fi
  python3 - "$ENV_FILE" "$key" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
key = sys.argv[2]
matches = [line.rstrip("\r\n")[len(key) + 1:] for line in path.read_text(encoding="utf-8").splitlines() if line.startswith(f"{key}=")]
if not matches:
    raise SystemExit(0)
value = matches[-1]
if value.startswith("'") and value.endswith("'") and len(value) >= 2:
    body = value[1:-1]
    decoded = []
    index = 0
    while index < len(body):
        if body[index] == "\\" and index + 1 < len(body) and body[index + 1] == "'":
            index += 1
        decoded.append(body[index])
        index += 1
    value = "".join(decoded)
elif value.startswith('"') and value.endswith('"') and len(value) >= 2:
    body = value[1:-1]
    decoded = []
    index = 0
    escapes = {"\\": "\\", '"': '"', "n": "\n", "r": "\r", "t": "\t"}
    while index < len(body):
        if body[index] == "\\" and index + 1 < len(body) and body[index + 1] in escapes:
            index += 1
            decoded.append(escapes[body[index]])
        else:
            decoded.append(body[index])
        index += 1
    value = "".join(decoded)
else:
    value = value.split(" #", 1)[0].rstrip()
sys.stdout.write(value)
PY
}

write_env_value() {
  local key="$1"
  local value="$2"
  ENV_WRITE_FILE="$ENV_FILE" ENV_WRITE_KEY="$key" ENV_WRITE_VALUE="$value" python3 - <<'PY'
import os
import stat
import tempfile
from pathlib import Path

path = Path(os.environ["ENV_WRITE_FILE"])
key = os.environ["ENV_WRITE_KEY"]
value = os.environ["ENV_WRITE_VALUE"]
escaped = value.replace("'", "\\'")
lines = path.read_text(encoding="utf-8").splitlines(keepends=True)
replacement = f"{key}='{escaped}'"
matching = [index for index, line in enumerate(lines) if line.rstrip("\r\n").startswith(f"{key}=")]
if matching:
    index = matching[-1]
    ending = "\r\n" if lines[index].endswith("\r\n") else "\n" if lines[index].endswith("\n") else ""
    lines[index] = replacement + ending
else:
    if lines and not lines[-1].endswith(("\n", "\r")):
        lines[-1] += "\n"
    lines.append(replacement + "\n")
metadata = path.stat()
descriptor, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
try:
    os.fchmod(descriptor, stat.S_IMODE(metadata.st_mode))
    try:
        os.fchown(descriptor, metadata.st_uid, metadata.st_gid)
    except PermissionError:
        pass
    with os.fdopen(descriptor, "w", encoding="utf-8", newline="") as handle:
        handle.writelines(lines)
        handle.flush()
        os.fsync(handle.fileno())
    os.replace(temporary, path)
except Exception:
    try:
        os.unlink(temporary)
    except FileNotFoundError:
        pass
    raise
PY
}

generate_hex_secret() {
  od -An -N32 -tx1 /dev/urandom | tr -d ' \n'
}

read_secret_cache() {
  local cache_file="$1"
  if [[ -L "$cache_file" ]]; then
    echo "MixSpace upgrade stopped: a credential cache path is a symbolic link" >&2
    return 1
  fi
  if [[ -s "$cache_file" ]]; then
    sed -n '1p' "$cache_file" | tr -d '\r\n'
  fi
}

write_secret_cache() {
  local cache_file="$1"
  local value="$2"
  if [[ -L "$cache_file" ]]; then
    echo "MixSpace upgrade stopped: a credential cache path is a symbolic link" >&2
    return 1
  fi
  printf '%s\n' "$value" > "$cache_file"
  chmod 600 "$cache_file"
}

run_upgrade_tool() {
  local field_key="$1"
  local jwt_secret="$2"
  local pg_password="$3"
  shift 3
  PG_PASSWORD="$pg_password" ENCRYPT_KEY="$field_key" JWT_SECRET="$jwt_secret" \
    docker-compose run --rm --no-deps -T \
      -e PG_PASSWORD -e ENCRYPT_KEY -e JWT_SECRET "$APP_SERVICE" node upgrade.mjs "$@"
}

run_release_migration() {
  local field_key="$1"
  local jwt_secret="$2"
  local pg_password="$3"
  PG_PASSWORD="$pg_password" ENCRYPT_KEY="$field_key" JWT_SECRET="$jwt_secret" \
    docker-compose run --rm --no-deps -T \
      -e PG_PASSWORD -e ENCRYPT_KEY -e JWT_SECRET "$APP_SERVICE" node migrate.mjs
}

check_upgrade_report() {
  python3 - "$1" "$2" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
returncode = int(sys.argv[2])
report = None
for line in reversed(path.read_text(encoding="utf-8", errors="replace").splitlines()):
    try:
        candidate = json.loads(line)
    except json.JSONDecodeError:
        continue
    if isinstance(candidate, dict) and candidate.get("target") == 18:
        report = candidate
        break
if report is None:
    print("v18 upgrade check did not return a readable report", file=sys.stderr)
    sys.exit(1)

status = report.get("status")
issues = report.get("issues")
if status not in {"ready", "needs-action"} or not isinstance(issues, list):
    print("v18 upgrade check returned an error status", file=sys.stderr)
    sys.exit(1)
codes = [item.get("code") for item in issues if isinstance(item, dict)]
allowed = {
    "CREDENTIALS_NEED_MIGRATION",
    "LEGACY_CONFIG",
    "METRICS_INCOMPLETE",
    "CONFIG_MIGRATION_MISSING",
    "JWT_TOO_SHORT",
}
unknown = sorted(set(codes) - allowed)
if unknown:
    print("v18 upgrade check needs manual resolution: " + ", ".join(unknown), file=sys.stderr)
    sys.exit(1)
if status == "needs-action" and not codes:
    print("v18 upgrade check needs action without a recognized migration issue", file=sys.stderr)
    sys.exit(1)
if (status == "ready" and returncode != 0) or (status == "needs-action" and returncode != 2):
    print("v18 upgrade check status did not match its exit code", file=sys.stderr)
    sys.exit(1)
print(f"{status}|{'true' if 'JWT_TOO_SHORT' in codes else 'false'}|{','.join(codes)}")
PY
}

if [[ ! -f "$ENV_FILE" ]]; then
  echo "MixSpace upgrade stopped: $ENV_FILE is missing"
  exit 1
fi
if ! command -v docker-compose >/dev/null 2>&1; then
  echo "MixSpace upgrade stopped: docker-compose is unavailable"
  exit 1
fi

DATA_PATH="${DATA_PATH:-$(read_env_value DATA_PATH || true)}"
DATA_PATH="${DATA_PATH:-./data}"
field_key="$(read_env_value ENCRYPT_KEY || true)"
jwt_secret_from_env="$(read_env_value JWT_SECRET || true)"
pg_password_from_env="$(read_env_value PG_PASSWORD || true)"
jwt_secret="$jwt_secret_from_env"
pg_password="$(read_env_value PG_PASSWORD || true)"
pg_password_cache="${DATA_PATH}/.mixspace_pg_password"
jwt_secret_cache="${DATA_PATH}/.mixspace_jwt_secret"
if [[ -L "$pg_password_cache" || -L "$jwt_secret_cache" ]]; then
  echo "MixSpace upgrade stopped: a credential cache path is a symbolic link" >&2
  exit 1
fi
if [[ -z "$pg_password" ]]; then
  if ! pg_password="$(read_secret_cache "$pg_password_cache")"; then
    exit 1
  fi
fi
if [[ -z "$jwt_secret" ]]; then
  if ! jwt_secret="$(read_secret_cache "$jwt_secret_cache")"; then
    exit 1
  fi
fi
key_generated=false

if [[ -z "$jwt_secret" ]]; then
  echo "MixSpace upgrade stopped: preserve or restore the existing JWT_SECRET or its upgrade cache"
  exit 1
fi
if [[ -z "$pg_password" ]]; then
  echo "MixSpace upgrade stopped: preserve or restore the existing PG_PASSWORD or its upgrade cache"
  exit 1
fi
if [[ -z "$field_key" ]]; then
  field_key="$(generate_hex_secret)"
  key_generated=true
fi
if [[ ! "$field_key" =~ ^[[:xdigit:]]{64}$ ]]; then
  echo "MixSpace upgrade stopped: ENCRYPT_KEY must be exactly 64 hexadecimal characters"
  exit 1
fi
if [[ ! -e "${DATA_PATH}/postgres/PG_VERSION" ]]; then
  echo "MixSpace upgrade stopped: PostgreSQL data was not found at ${DATA_PATH}/postgres"
  exit 1
fi

PG_PASSWORD="$pg_password" docker-compose up -d "$DB_SERVICE"
db_ready=false
for ((attempt = 0; attempt < 30; attempt++)); do
  if docker-compose exec -T "$DB_SERVICE" pg_isready -U mx -d mx_core >/dev/null 2>&1; then
    db_ready=true
    break
  fi
  sleep 2
done
if [[ "$db_ready" != true ]]; then
  echo "MixSpace upgrade stopped: PostgreSQL did not become ready"
  exit 1
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/mixspace-v18-upgrade.XXXXXX")"
chmod 700 "$tmp_dir"
trap 'rm -f "$tmp_dir"/*; rmdir "$tmp_dir" 2>/dev/null || true' EXIT
check_report="$tmp_dir/check.json"
check_rc=0
if run_upgrade_tool "$field_key" "$jwt_secret" "$pg_password" check --json > "$check_report" 2>&1; then
  check_rc=0
else
  check_rc=$?
fi
if [[ "$check_rc" -ne 0 && "$check_rc" -ne 2 ]]; then
  echo "MixSpace upgrade stopped: v18 read-only preflight failed"
  exit 1
fi
if ! check_summary="$(check_upgrade_report "$check_report" "$check_rc")"; then
  exit 1
fi
IFS='|' read -r check_status short_jwt check_codes <<< "$check_summary"
echo "v18 read-only preflight: ${check_status}; issues=${check_codes:-none}"

backup_dir="${DATA_PATH}/backups"
mkdir -p "$backup_dir"
db_size_kb="$(du -sk "${DATA_PATH}/postgres" | awk '{print $1}')"
files_size_kb="$(du -sk "${DATA_PATH}/mx-space" | awk '{print $1}')"
free_kb="$(df -Pk "$backup_dir" | awk 'NR == 2 {print $4}')"
if [[ ! "$db_size_kb" =~ ^[0-9]+$ || ! "$files_size_kb" =~ ^[0-9]+$ || ! "$free_kb" =~ ^[0-9]+$ ]]; then
  echo "MixSpace upgrade stopped: could not estimate snapshot size or available space"
  exit 1
fi
snapshot_size_kb=$((db_size_kb + files_size_kb))
snapshot_headroom_kb=$((snapshot_size_kb / 20))
if (( snapshot_headroom_kb < 1024 )); then
  snapshot_headroom_kb=1024
fi
if (( free_kb < snapshot_size_kb + snapshot_headroom_kb )); then
  echo "MixSpace upgrade stopped: insufficient free space for database and file snapshots"
  exit 1
fi
docker-compose stop "$APP_SERVICE"

stamp="$(date -u +%Y%m%dT%H%M%SZ)-$$"
backup_env="${backup_dir}/mixspace-env-before-v18-${stamp}.env"
backup_tmp="$(mktemp "${backup_dir}/.mixspace-db-before-v18.XXXXXX")"
backup_db="${backup_dir}/mixspace-db-before-v18-${stamp}.dump"
files_tmp="$(mktemp "${backup_dir}/.mixspace-files-before-v18.XXXXXX")"
backup_files="${backup_dir}/mixspace-files-before-v18-${stamp}.tar"
cp "$ENV_FILE" "$backup_env"
chmod 600 "$backup_env"
if [[ -z "$pg_password_from_env" ]]; then
  ENV_FILE="$backup_env" write_env_value PG_PASSWORD "$pg_password"
fi
if [[ -z "$jwt_secret_from_env" ]]; then
  ENV_FILE="$backup_env" write_env_value JWT_SECRET "$jwt_secret"
fi
if ! docker-compose exec -T "$DB_SERVICE" pg_dump -U mx -d mx_core -Fc > "$backup_tmp"; then
  rm -f "$backup_tmp"
  rm -f "$files_tmp" "$backup_env"
  echo "MixSpace upgrade stopped: PostgreSQL backup failed"
  exit 1
fi
if [[ ! -s "$backup_tmp" ]]; then
  rm -f "$backup_tmp"
  rm -f "$files_tmp" "$backup_env"
  echo "MixSpace upgrade stopped: PostgreSQL backup was empty"
  exit 1
fi
chmod 600 "$backup_tmp"
mv "$backup_tmp" "$backup_db"
if ! tar -C "$DATA_PATH" -cf "$files_tmp" mx-space; then
  rm -f "$files_tmp" "$backup_env"
  echo "MixSpace upgrade stopped: application file snapshot failed; the database snapshot is retained"
  exit 1
fi
if [[ ! -s "$files_tmp" ]]; then
  rm -f "$files_tmp" "$backup_env"
  echo "MixSpace upgrade stopped: application file snapshot was empty; the database snapshot is retained"
  exit 1
fi
chmod 600 "$files_tmp"
mv "$files_tmp" "$backup_files"
echo "Created pre-upgrade database, file, and environment snapshots"

if [[ "$key_generated" == true ]]; then
  write_env_value ENCRYPT_KEY "$field_key"
fi
if [[ -z "$pg_password_from_env" ]]; then
  write_env_value PG_PASSWORD "$pg_password"
fi
if [[ -z "$jwt_secret_from_env" ]]; then
  write_env_value JWT_SECRET "$jwt_secret"
fi
write_secret_cache "$pg_password_cache" "$pg_password"
write_secret_cache "$jwt_secret_cache" "$jwt_secret"
write_env_value ENCRYPT_ENABLE true
write_env_value MX_SECRET_STORAGE_V2 true

if [[ "$short_jwt" == true ]]; then
  new_jwt="$(generate_hex_secret)"
  printf '%s' "$jwt_secret" > "$tmp_dir/old-jwt"
  printf '%s' "$new_jwt" > "$tmp_dir/new-jwt"
  chmod 600 "$tmp_dir/old-jwt" "$tmp_dir/new-jwt"
  if ! PG_PASSWORD="$pg_password" ENCRYPT_KEY="$field_key" JWT_SECRET="$jwt_secret" docker-compose run --rm --no-deps -T \
    -e PG_PASSWORD -e ENCRYPT_KEY -e JWT_SECRET \
    -v "$tmp_dir/old-jwt:/tmp/mixspace-old-jwt:ro" \
    -v "$tmp_dir/new-jwt:/tmp/mixspace-new-jwt:ro" \
    "$APP_SERVICE" node upgrade.mjs rotate-jwt --maintenance-confirmed \
      --old-jwt-file /tmp/mixspace-old-jwt --new-jwt-file /tmp/mixspace-new-jwt; then
    echo "MixSpace upgrade stopped: JWT rotation failed; restore from the saved backup if needed"
    exit 1
  fi
  jwt_secret="$new_jwt"
  write_env_value JWT_SECRET "$jwt_secret"
  write_secret_cache "$jwt_secret_cache" "$jwt_secret"
  echo "Rotated the short JWT secret; existing sessions will need to sign in again"
fi

if ! run_release_migration "$field_key" "$jwt_secret" "$pg_password"; then
  echo "MixSpace upgrade stopped: v18 release migration failed; backups are retained"
  exit 1
fi

check_rc=0
if run_upgrade_tool "$field_key" "$jwt_secret" "$pg_password" check --json > "$check_report" 2>&1; then
  check_rc=0
else
  check_rc=$?
fi
if [[ "$check_rc" -ne 0 ]] || ! check_summary="$(check_upgrade_report "$check_report" "$check_rc")"; then
  echo "MixSpace upgrade stopped: v18 post-migration check failed; backups are retained"
  exit 1
fi
IFS='|' read -r check_status short_jwt check_codes <<< "$check_summary"
if [[ "$check_status" != ready || -n "$check_codes" ]]; then
  echo "MixSpace upgrade stopped: v18 reports unresolved issues: ${check_codes:-unknown}"
  exit 1
fi

echo "MixSpace v18 release migration and post-migration check passed"
