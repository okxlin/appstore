#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

get_env_value() {
  local key="$1"
  local default="$2"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1 || true)"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
  fi

  if [[ -n "$value" ]]; then
    printf '%s\n' "$value"
  else
    printf '%s\n' "$default"
  fi
}

resolve_app_path() {
  local raw="$1"
  if [[ "$raw" = /* ]]; then
    printf '%s\n' "$raw"
  else
    printf '%s\n' "${ROOT_DIR}/${raw#./}"
  fi
}

yaml_escape() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '%s\n' "$value"
}

[[ -f "$ENV_FILE" ]] || fail "Environment file not found: ${ENV_FILE}"

DATA_DIR="$(resolve_app_path "$(get_env_value DATA_PATH ./data)")"
CONFIG_FILE="${DATA_DIR}/config.yaml"
LOG_DIR="${DATA_DIR}/logs"
CONTAINER_NAME="$(get_env_value CONTAINER_NAME next-terminal)"
DB_HOST="$(get_env_value PANEL_DB_HOST '')"
DB_PORT="$(get_env_value PANEL_DB_PORT 5432)"
DB_NAME="$(get_env_value PANEL_DB_NAME next_terminal)"
DB_USER="$(get_env_value PANEL_DB_USER next_terminal)"
DB_PASSWORD="$(get_env_value PANEL_DB_USER_PASSWORD next_terminal)"

[[ -n "$DB_HOST" ]] || fail "PANEL_DB_HOST is required. Select a running PostgreSQL application and service in 1Panel."

mkdir -p "$DATA_DIR" "$LOG_DIR"

if [[ -d "$CONFIG_FILE" ]]; then
  backup="${CONFIG_FILE}.dir-backup-$(date +%Y%m%d%H%M%S)"
  mv "$CONFIG_FILE" "$backup"
  echo "Moved directory blocking config.yaml to $backup"
fi

if [[ -f "$CONFIG_FILE" ]]; then
  CURRENT_DB_HOST="$(sed -n -E 's/^[[:space:]]*Hostname:[[:space:]]*"?([^"[:space:]]+)"?[[:space:]]*$/\1/p' "$CONFIG_FILE" | head -n 1)"
  [[ -n "$CURRENT_DB_HOST" ]] || fail "Existing config.yaml has an unrecognized database host; it was preserved and the operation was stopped."
  [[ "$CURRENT_DB_HOST" == "$DB_HOST" ]] || fail "Existing config.yaml uses database host '${CURRENT_DB_HOST}', but 1Panel selected '${DB_HOST}'. The file was preserved; migrate the database and configuration manually before retrying."
  echo "Next Terminal config already exists: $CONFIG_FILE"
  exit 0
fi

cat > "$CONFIG_FILE" <<EOF
Database:
  Enabled: true
  Type: postgres
  Postgres:
    Hostname: "$(yaml_escape "$DB_HOST")"
    Port: $(yaml_escape "$DB_PORT")
    Username: "$(yaml_escape "$DB_USER")"
    Password: "$(yaml_escape "$DB_PASSWORD")"
    Database: "$(yaml_escape "$DB_NAME")"
  ShowSql: false
log:
  Level: info
  Filename: /usr/local/next-terminal/logs/nt.log

Server:
  Addr: "0.0.0.0:8088"

App:
  Website:
    AccessLog: /usr/local/next-terminal/logs/access.log
  Recording:
    Type: "local"
    Path: "/usr/local/next-terminal/data/recordings"
  Guacd:
    Drive: "/usr/local/next-terminal/data/drive"
    Hosts:
      - Hostname: "$(yaml_escape "${CONTAINER_NAME}-guacd")"
        Port: 4822
        Weight: 1
  ReverseProxy:
    Enabled: false
    HttpEnabled: true
    HttpAddr: ":80"
    HttpRedirectToHttps: false
    HttpsEnabled: true
    HttpsAddr: ":443"
    SelfProxyEnabled: true
    SelfDomain: "nt.yourdomain.com"
    Root: ""
    IpExtractor: "direct"
    IpTrustList:
      - "0.0.0.0/0"
EOF

echo "Generated Next Terminal config: $CONFIG_FILE"
