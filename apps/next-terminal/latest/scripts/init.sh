#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

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

random_password() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 16
  else
    LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32 || true
  fi
}

ensure_env_value() {
  local key="$1"
  local value="$2"

  if [[ -f "$ENV_FILE" ]] && ! grep -q "^${key}=" "$ENV_FILE"; then
    printf '\n%s="%s"\n' "$key" "$value" >> "$ENV_FILE"
  fi
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_value PANEL_DB_NAME next_terminal
  ensure_env_value PANEL_DB_USER next_terminal
  ensure_env_value PANEL_DB_USER_PASSWORD "$(random_password)"
fi

DATA_DIR="$(resolve_app_path "$(get_env_value DATA_PATH ./data)")"
CONFIG_FILE="${DATA_DIR}/config.yaml"
LOG_DIR="${DATA_DIR}/logs"
DB_DIR="${DATA_DIR}/postgresql"
CONTAINER_NAME="$(get_env_value CONTAINER_NAME next-terminal)"
DB_NAME="$(get_env_value PANEL_DB_NAME next_terminal)"
DB_USER="$(get_env_value PANEL_DB_USER next_terminal)"
DB_PASSWORD="$(get_env_value PANEL_DB_USER_PASSWORD next_terminal)"

mkdir -p "$DATA_DIR" "$LOG_DIR" "$DB_DIR"

if [[ -d "$CONFIG_FILE" ]]; then
  backup="${CONFIG_FILE}.dir-backup-$(date +%Y%m%d%H%M%S)"
  mv "$CONFIG_FILE" "$backup"
  echo "Moved directory blocking config.yaml to $backup"
fi

if [[ -f "$CONFIG_FILE" ]]; then
  echo "Next Terminal config already exists: $CONFIG_FILE"
  exit 0
fi

cat > "$CONFIG_FILE" <<EOF
Database:
  Enabled: true
  Type: postgres
  Postgres:
    Hostname: "$(yaml_escape "${CONTAINER_NAME}-postgresql")"
    Port: 5432
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
