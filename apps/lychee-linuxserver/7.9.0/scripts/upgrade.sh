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
  ensure_env_default "APP_NAME" "Lychee"
  ensure_env_default "APP_URL" ""
  ensure_env_default "TRUSTED_PROXIES" ""
  ensure_env_default "DB_CONNECTION" "sqlite"
  ensure_env_default "DB_DATABASE" "/config/lychee.sqlite"
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
