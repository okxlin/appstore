#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

ensure_env_default() {
  local key="$1"
  local value="$2"

  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped $key migration"
    return
  fi

  if grep -qE "^${key}=" "$ENV_FILE"; then
    echo "$key already exists"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added $key"
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_default "DB_HOST" "hedgedoc-db"
  ensure_env_default "DB_PORT" "3306"
  ensure_env_default "DB_USER" "hedgedoc"
  ensure_env_default "DB_NAME" "hedgedoc"
  ensure_env_default "CMD_URL_ADDPORT" "true"
  ensure_env_default "CMD_PROTOCOL_USESSL" "false"
  ensure_env_default "CMD_PORT" "3000"
  ensure_env_default "CMD_ALLOW_ORIGIN" "['localhost']"
  ensure_env_default "CMD_DB_DIALECT" "mariadb"
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
