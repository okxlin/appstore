#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

generate_secret() {
  if [[ -r /dev/urandom ]]; then
    local secret=""
    local chunk=""
    while [[ ${#secret} -lt 24 ]]; do
      chunk="$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $((24 - ${#secret})) || true)"
      secret="${secret}${chunk}"
    done
    printf '%s\n' "$secret"
  else
    printf '%s\n' 'linuxserver-change-me'
  fi
}

ensure_env_default() {
  local key="$1"
  local value="$2"
  local fill_empty="${3:-false}"

  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped $key migration"
    return
  fi

  if grep -qE "^${key}=" "$ENV_FILE"; then
    local current
    current="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
    current="${current%\"}"
    current="${current#\"}"
    current="${current%'}"
    current="${current#'}"
    if [[ "$fill_empty" == "true" && -z "$current" ]]; then
      sed -i -E "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
      echo "Updated empty $key"
    else
      echo "$key already exists"
    fi
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added $key"
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_default "TITLE" "DB Browser for SQLite" false
  ensure_env_default "SELKIES_UI_TITLE" "Selkies" false
  ensure_env_default "DASHBOARD" "selkies-dashboard" false
  ensure_env_default "LC_ALL" "zh_CN.UTF-8" false
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
