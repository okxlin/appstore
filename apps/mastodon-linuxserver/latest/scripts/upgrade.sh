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
  ensure_env_default "REDIS_HOST" "mastodon-redis"
  ensure_env_default "REDIS_PORT" "6379"
  ensure_env_default "DB_HOST" "mastodon-db"
  ensure_env_default "DB_PORT" "5432"
  ensure_env_default "DB_USER" "mastodon"
  ensure_env_default "DB_NAME" "mastodon"
  ensure_env_default "MASTODON_PROMETHEUS_EXPORTER_ENABLED" "false"
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
