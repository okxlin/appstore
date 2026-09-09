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
    local current
    current="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
    current="${current%\"}"
    current="${current#\"}"
    current="${current%\'}"
    current="${current#\'}"
    if [[ -n "$current" ]]; then
      echo "$key already exists"
      return
    fi
    sed -i -E "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
    echo "Updated empty $key"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added $key"
}

ensure_env_default "PANEL_DB_PORT" "5432"
