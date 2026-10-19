#!/usr/bin/env bash
set -euo pipefail

ZIPLINE_STORED_POSTGRES_PASSWORD=""
ZIPLINE_STORED_CORE_SECRET=""
ZIPLINE_SNAPSHOT_POSTGRES_PASSWORD=""
ZIPLINE_SNAPSHOT_CORE_SECRET=""

zipline_fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

zipline_read_env_value() {
  local file="$1"
  local key="$2"
  local value
  [[ -f "$file" && ! -L "$file" ]] || return 1
  value="$(awk -v key="$key" '
    index($0, key "=") == 1 {
      count++
      value = substr($0, length(key) + 2)
    }
    END {
      if (count != 1) exit 1
      print value
    }
  ' "$file")" || return 1
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

zipline_resolve_data_dir() {
  local root_dir="$1"
  local raw="$2"
  local clean current resolved part
  local -a parts=()
  [[ -n "$raw" && "$raw" != /* ]] || zipline_fail "APP_DATA_DIR must be a non-empty relative path"
  [[ ! "$raw" =~ [[:cntrl:]] ]] || zipline_fail "APP_DATA_DIR contains control characters"
  case "$raw" in
    *\\* | *:* | *'$'* | *'#'* | *'"'* | *"'"*)
      zipline_fail "APP_DATA_DIR contains unsupported characters"
      ;;
  esac
  clean="${raw#./}"
  [[ -n "$clean" ]] || zipline_fail "APP_DATA_DIR must not resolve to the version root"
  IFS=/ read -r -a parts <<< "$clean"
  current="$root_dir"
  for part in "${parts[@]}"; do
    [[ -n "$part" && "$part" != . && "$part" != .. ]] || zipline_fail "APP_DATA_DIR contains traversal"
    current="$current/$part"
    [[ ! -L "$current" ]] || zipline_fail "APP_DATA_DIR must not contain symbolic-link components"
  done
  resolved="$(realpath -m -- "$root_dir/$clean")" || zipline_fail "APP_DATA_DIR could not be resolved"
  case "$resolved" in
    "$root_dir"/*) ;;
    *) zipline_fail "APP_DATA_DIR must stay inside the application version directory" ;;
  esac
  printf '%s\n' "$resolved"
}

zipline_validate_postgres_password() {
  [[ "$1" =~ ^[A-Za-z0-9]{32,128}$ ]]
}

zipline_validate_core_secret() {
  [[ "$1" =~ ^[A-Fa-f0-9]{64,128}$ ]]
}

zipline_generate_postgres_password() {
  local material
  material="$(openssl rand -base64 96 | tr -dc A-Za-z0-9)"
  [[ ${#material} -ge 48 ]] || zipline_fail "unable to generate sufficient database password material"
  printf '%s\n' "${material:0:48}"
}

zipline_write_env_credentials() {
  local env_file="$1"
  local postgres_password="$2"
  local core_secret="$3"
  local temp_file
  temp_file="$(mktemp "${env_file}.zipline-tmp.XXXXXX")" || zipline_fail "unable to stage Zipline environment update"
  if ! ZIPLINE_DB_PASSWORD="$postgres_password" ZIPLINE_CORE_SECRET="$core_secret" awk '
    BEGIN {
      db_password = ENVIRON["ZIPLINE_DB_PASSWORD"]
      core_secret = ENVIRON["ZIPLINE_CORE_SECRET"]
    }
    /^POSTGRES_PASSWORD=/ {
      if (!db_written++) print "POSTGRES_PASSWORD=" db_password
      next
    }
    /^CORE_SECRET=/ {
      if (!core_written++) print "CORE_SECRET=" core_secret
      next
    }
    { print }
    END {
      if (!db_written) print "POSTGRES_PASSWORD=" db_password
      if (!core_written) print "CORE_SECRET=" core_secret
    }
  ' "$env_file" > "$temp_file"; then
    rm -f -- "$temp_file"
    zipline_fail "unable to render Zipline environment update"
  fi
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$env_file"
  chmod 600 "$env_file"
}

zipline_write_secret_state() {
  local data_dir="$1"
  local postgres_password="$2"
  local core_secret="$3"
  local secret_file="$data_dir/.zipline-secrets"
  local temp_file
  [[ -d "$data_dir" && ! -L "$data_dir" ]] || zipline_fail "Zipline data directory is unavailable"
  [[ ! -L "$secret_file" ]] || zipline_fail "Zipline secret state must not be a symbolic link"
  temp_file="$(mktemp "${secret_file}.tmp.XXXXXX")" || zipline_fail "unable to stage Zipline secret state"
  if ! printf 'POSTGRES_PASSWORD=%s\nCORE_SECRET=%s\n' "$postgres_password" "$core_secret" > "$temp_file"; then
    rm -f -- "$temp_file"
    zipline_fail "unable to write Zipline secret state"
  fi
  chmod 600 "$temp_file"
  chown 0:0 -- "$temp_file"
  mv -f -- "$temp_file" "$secret_file"
  chmod 600 "$secret_file"
  chown 0:0 -- "$secret_file"
}

zipline_load_secret_state() {
  local data_dir="$1"
  local secret_file="$data_dir/.zipline-secrets"
  [[ -e "$secret_file" || -L "$secret_file" ]] || return 1
  [[ -f "$secret_file" && ! -L "$secret_file" ]] || zipline_fail "Zipline secret state is not a regular file"
  ZIPLINE_STORED_POSTGRES_PASSWORD="$(zipline_read_env_value "$secret_file" POSTGRES_PASSWORD)" ||
    zipline_fail "Zipline secret state is incomplete"
  ZIPLINE_STORED_CORE_SECRET="$(zipline_read_env_value "$secret_file" CORE_SECRET)" ||
    zipline_fail "Zipline secret state is incomplete"
  zipline_validate_postgres_password "$ZIPLINE_STORED_POSTGRES_PASSWORD" ||
    zipline_fail "Zipline secret state has an invalid database password"
  zipline_validate_core_secret "$ZIPLINE_STORED_CORE_SECRET" ||
    zipline_fail "Zipline secret state has an invalid session secret"
  chmod 600 "$secret_file"
  chown 0:0 -- "$secret_file"
}

zipline_init_credentials() {
  local env_file="$1"
  local data_dir="$2"
  local postgres_password core_secret stored
  local postgres_default=false core_default=false
  [[ -f "$env_file" && ! -L "$env_file" ]] || zipline_fail "Zipline .env file is unavailable"
  postgres_password="$(zipline_read_env_value "$env_file" POSTGRES_PASSWORD)" ||
    zipline_fail "POSTGRES_PASSWORD is missing from Zipline .env"
  core_secret="$(zipline_read_env_value "$env_file" CORE_SECRET)" ||
    zipline_fail "CORE_SECRET is missing from Zipline .env"
  [[ -n "$postgres_password" && "$postgres_password" != generate ]] || postgres_default=true
  [[ -n "$core_secret" && "$core_secret" != generate ]] || core_default=true

  if zipline_load_secret_state "$data_dir"; then
    if [[ "$postgres_default" == true ]]; then
      postgres_password="$ZIPLINE_STORED_POSTGRES_PASSWORD"
    elif [[ "$postgres_password" != "$ZIPLINE_STORED_POSTGRES_PASSWORD" ]]; then
      zipline_fail "POSTGRES_PASSWORD cannot change while Zipline data is retained"
    fi
    if [[ "$core_default" == true ]]; then
      core_secret="$ZIPLINE_STORED_CORE_SECRET"
    elif [[ "$core_secret" != "$ZIPLINE_STORED_CORE_SECRET" ]]; then
      zipline_fail "CORE_SECRET cannot change while Zipline data is retained"
    fi
  else
    if [[ -f "$data_dir/postgres/PG_VERSION" && ( "$postgres_default" == true || "$core_default" == true ) ]]; then
      zipline_fail "existing PostgreSQL data has no Zipline secret state; supply its original credentials to preserve it"
    fi
    if [[ "$postgres_default" == true ]]; then
      postgres_password="$(zipline_generate_postgres_password)"
    fi
    if [[ "$core_default" == true ]]; then
      core_secret="$(openssl rand -hex 32)"
    fi
  fi

  zipline_validate_postgres_password "$postgres_password" ||
    zipline_fail "POSTGRES_PASSWORD must contain 32 to 128 alphanumeric characters"
  zipline_validate_core_secret "$core_secret" ||
    zipline_fail "CORE_SECRET must contain 64 to 128 hexadecimal characters"
  zipline_write_env_credentials "$env_file" "$postgres_password" "$core_secret"
  zipline_write_secret_state "$data_dir" "$postgres_password" "$core_secret"
}

zipline_find_upgrade_snapshot() {
  local root_dir="$1"
  local env_file="$2"
  local current_name="$3"
  local current_data_dir="$4"
  local current_db="$5"
  local current_user="$6"
  local temp_root snapshot old_env old_compose old_name old_data old_db old_user
  local snapshot_time env_time best_time=-1 tied=false snapshot_uid snapshot_mode old_env_uid old_env_mode
  local best_snapshot=""
  local -a candidates=()

  temp_root="$(realpath -e -- "${TMPDIR:-/tmp}")" || zipline_fail "1Panel upgrade snapshot directory is unavailable"
  [[ -d "$temp_root" ]] || zipline_fail "1Panel upgrade snapshot directory is unavailable"
  env_time="$(stat -c '%Y' "$env_file")" || zipline_fail "Zipline .env timestamp is unavailable"
  shopt -s nullglob
  candidates=("$temp_root"/1panel-app-upgrade-*)
  shopt -u nullglob
  for snapshot in "${candidates[@]}"; do
    [[ -d "$snapshot" && ! -L "$snapshot" ]] || continue
    snapshot_uid="$(stat -c '%u' "$snapshot")" || continue
    snapshot_mode="$(stat -c '%a' "$snapshot")" || continue
    [[ "$snapshot_uid" == 0 ]] || continue
    (( (8#$snapshot_mode & 077) == 0 )) || continue
    old_env="$snapshot/.env"
    old_compose="$snapshot/docker-compose.yml"
    [[ -f "$old_env" && ! -L "$old_env" && -f "$old_compose" && ! -L "$old_compose" ]] || continue
    old_env_uid="$(stat -c '%u' "$old_env")" || continue
    old_env_mode="$(stat -c '%a' "$old_env")" || continue
    [[ "$old_env_uid" == 0 ]] || continue
    (( (8#$old_env_mode & 077) == 0 )) || continue
    grep -Eq 'image:[[:space:]]*"?ghcr\.io/diced/zipline:4\.(6\.5|7\.0|8\.0)@sha256:[[:xdigit:]]{64}"?[[:space:]]*$' "$old_compose" || continue
    old_name="$(zipline_read_env_value "$old_env" CONTAINER_NAME)" || continue
    [[ "$old_name" == "$current_name" ]] || continue
    old_data="$(zipline_read_env_value "$old_env" APP_DATA_DIR)" || zipline_fail "matching 1Panel snapshot lacks APP_DATA_DIR"
    old_db="$(zipline_read_env_value "$old_env" POSTGRES_DB)" || zipline_fail "matching 1Panel snapshot lacks POSTGRES_DB"
    old_user="$(zipline_read_env_value "$old_env" POSTGRES_USER)" || zipline_fail "matching 1Panel snapshot lacks POSTGRES_USER"
    [[ "$old_data" == "$current_data_dir" && "$old_db" == "$current_db" && "$old_user" == "$current_user" ]] ||
      zipline_fail "matching 1Panel snapshot does not preserve the configured data path and database identity"
    ZIPLINE_SNAPSHOT_POSTGRES_PASSWORD="$(zipline_read_env_value "$old_env" POSTGRES_PASSWORD)" ||
      zipline_fail "matching 1Panel snapshot lacks its database password"
    ZIPLINE_SNAPSHOT_CORE_SECRET="$(zipline_read_env_value "$old_env" CORE_SECRET)" ||
      zipline_fail "matching 1Panel snapshot lacks its session secret"
    zipline_validate_postgres_password "$ZIPLINE_SNAPSHOT_POSTGRES_PASSWORD" ||
      zipline_fail "matching 1Panel snapshot has an invalid database password"
    zipline_validate_core_secret "$ZIPLINE_SNAPSHOT_CORE_SECRET" ||
      zipline_fail "matching 1Panel snapshot has an invalid session secret"
    snapshot_time="$(stat -c '%Y' "$snapshot")" || zipline_fail "1Panel upgrade snapshot timestamp is unavailable"
    if (( snapshot_time > best_time )); then
      best_time="$snapshot_time"
      best_snapshot="$snapshot"
      tied=false
    elif (( snapshot_time == best_time )); then
      tied=true
    fi
  done
  [[ -n "$best_snapshot" ]] || zipline_fail "could not find this Zipline install's 1Panel upgrade snapshot"
  [[ "$tied" == false ]] || zipline_fail "multiple matching 1Panel upgrade snapshots are ambiguous"
  (( best_time <= env_time && env_time - best_time <= 600 )) ||
    zipline_fail "matching 1Panel upgrade snapshot is stale"
}

zipline_restore_upgrade_credentials() {
  local root_dir="$1"
  local env_file="$2"
  local raw_data_dir data_dir current_name current_db current_user
  local postgres_password core_secret current_password current_core_secret
  [[ -f "$env_file" && ! -L "$env_file" ]] || zipline_fail "Zipline .env file is unavailable"
  current_name="$(zipline_read_env_value "$env_file" CONTAINER_NAME)" || zipline_fail "CONTAINER_NAME is missing from Zipline .env"
  [[ "$current_name" =~ ^[A-Za-z0-9][A-Za-z0-9_.-]*$ ]] || zipline_fail "CONTAINER_NAME is invalid"
  raw_data_dir="$(zipline_read_env_value "$env_file" APP_DATA_DIR)" || zipline_fail "APP_DATA_DIR is missing from Zipline .env"
  data_dir="$(zipline_resolve_data_dir "$root_dir" "$raw_data_dir")"
  [[ -d "$data_dir" && ! -L "$data_dir" ]] || zipline_fail "configured Zipline data directory is missing"
  current_db="$(zipline_read_env_value "$env_file" POSTGRES_DB)" || zipline_fail "POSTGRES_DB is missing from Zipline .env"
  current_user="$(zipline_read_env_value "$env_file" POSTGRES_USER)" || zipline_fail "POSTGRES_USER is missing from Zipline .env"
  current_password="$(zipline_read_env_value "$env_file" POSTGRES_PASSWORD)" || zipline_fail "POSTGRES_PASSWORD is missing from Zipline .env"
  current_core_secret="$(zipline_read_env_value "$env_file" CORE_SECRET)" || zipline_fail "CORE_SECRET is missing from Zipline .env"

  zipline_find_upgrade_snapshot "$root_dir" "$env_file" "$current_name" "$raw_data_dir" "$current_db" "$current_user"
  postgres_password="$ZIPLINE_SNAPSHOT_POSTGRES_PASSWORD"
  core_secret="$ZIPLINE_SNAPSHOT_CORE_SECRET"
  if zipline_load_secret_state "$data_dir"; then
    [[ "$ZIPLINE_STORED_POSTGRES_PASSWORD" == "$postgres_password" && "$ZIPLINE_STORED_CORE_SECRET" == "$core_secret" ]] ||
      zipline_fail "Zipline secret state does not match the 1Panel upgrade snapshot"
  fi
  if [[ -n "$current_password" && "$current_password" != generate && "$current_password" != "$postgres_password" ]]; then
    zipline_fail "POSTGRES_PASSWORD changed during upgrade; refusing to alter the existing database credential"
  fi
  if [[ -n "$current_core_secret" && "$current_core_secret" != generate && "$current_core_secret" != "$core_secret" ]]; then
    zipline_fail "CORE_SECRET changed during upgrade; refusing to rotate the existing session secret"
  fi
  zipline_validate_postgres_password "$postgres_password" || zipline_fail "saved database password is invalid"
  zipline_validate_core_secret "$core_secret" || zipline_fail "saved session secret is invalid"
  zipline_write_env_credentials "$env_file" "$postgres_password" "$core_secret"
  zipline_write_secret_state "$data_dir" "$postgres_password" "$core_secret"
  printf '%s\n' "Zipline secrets were restored from the matching 1Panel upgrade snapshot."
}
