#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

get_env_value() {
  local key="$1"
  local default="$2"
  local value=""
  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
    if (( ${#value} >= 2 )) && [[ "$value" == \"*\" || "$value" == \'*\' ]]; then
      value="${value:1:${#value}-2}"
    fi
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
    printf '%s\n' "$ROOT_DIR/${raw#./}"
  fi
}

yaml_quote() {
  printf "'%s'" "$(printf '%s' "$1" | sed "s/'/''/g")"
}

APP_DATA_DIR_RAW="${APP_DATA_DIR:-$(get_env_value APP_DATA_DIR './data/storage')}"
APP_CONFIG_DIR_RAW="${APP_CONFIG_DIR:-$(get_env_value APP_CONFIG_DIR './data/config')}"
APP_DATA_DIR_PATH="$(resolve_app_path "$APP_DATA_DIR_RAW")"
APP_CONFIG_DIR_PATH="$(resolve_app_path "$APP_CONFIG_DIR_RAW")"
CONFIG_FILE="$APP_CONFIG_DIR_PATH/config.yaml"

mkdir -p "$APP_DATA_DIR_PATH" "$APP_CONFIG_DIR_PATH"

if [[ -e "$CONFIG_FILE" ]]; then
  EXISTING_DB_TYPE="$(awk '
    $0 == "database:" { in_database = 1; next }
    in_database && /^[^[:space:]]/ { exit }
    in_database && $1 == "type:" { print $2; exit }
  ' "$CONFIG_FILE")"
  case "$EXISTING_DB_TYPE" in
    mysql|postgres)
      printf 'Preserving existing Fast Note Sync configuration: %s\n' "$CONFIG_FILE"
      exit 0
      ;;
    sqlite)
      printf 'Refusing to reuse SQLite configuration for an external database variant: %s\n' "$CONFIG_FILE" >&2
      exit 1
      ;;
    *)
      printf 'Refusing to reuse unrecognized database configuration in %s\n' "$CONFIG_FILE" >&2
      exit 1
      ;;
  esac
fi

DB_TYPE="$(get_env_value PANEL_DB_TYPE mysql)"
DB_HOST="$(get_env_value PANEL_DB_HOST '')"
DB_PORT="$(get_env_value PANEL_DB_PORT 3306)"
DB_NAME="$(get_env_value PANEL_DB_NAME '')"
DB_USER="$(get_env_value PANEL_DB_USER '')"
DB_PASSWORD="$(get_env_value PANEL_DB_USER_PASSWORD '')"

if [[ "$DB_TYPE" != mysql && "$DB_TYPE" != postgresql ]]; then
  printf 'Unsupported external database type: %s\n' "$DB_TYPE" >&2
  exit 1
fi
if [[ -z "$DB_HOST" || -z "$DB_NAME" || -z "$DB_USER" || -z "$DB_PASSWORD" ]]; then
  printf 'Missing external database runtime settings; refusing to create %s\n' "$CONFIG_FILE" >&2
  exit 1
fi
if [[ ! "$DB_PORT" =~ ^[0-9]+$ ]] || (( 10#$DB_PORT < 1 || 10#$DB_PORT > 65535 )); then
  printf 'Invalid database port: %s\n' "$DB_PORT" >&2
  exit 1
fi

CONFIG_DB_TYPE=mysql
if [[ "$DB_TYPE" == postgresql ]]; then
  CONFIG_DB_TYPE=postgres
fi

AUTH_TOKEN="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
umask 077
cat > "$CONFIG_FILE" <<EOF
security:
  auth-token-key: $(yaml_quote "$AUTH_TOKEN")
database:
  type: $CONFIG_DB_TYPE
  path: storage/database/db.sqlite3
  host: $(yaml_quote "$DB_HOST")
  port: $DB_PORT
  username: $(yaml_quote "$DB_USER")
  password: $(yaml_quote "$DB_PASSWORD")
  name: $(yaml_quote "$DB_NAME")
  auto-migrate: true
EOF
if [[ "$CONFIG_DB_TYPE" == mysql ]]; then
  cat >> "$CONFIG_FILE" <<EOF
  charset: utf8mb4
  parse-time: true
EOF
else
  cat >> "$CONFIG_FILE" <<EOF
  ssl-mode: disable
  schema: public
EOF
fi
cat >> "$CONFIG_FILE" <<EOF
user-database:
  type:
EOF
chmod 600 "$CONFIG_FILE"
printf 'Created %s configuration: %s\n' "$CONFIG_DB_TYPE" "$CONFIG_FILE"
