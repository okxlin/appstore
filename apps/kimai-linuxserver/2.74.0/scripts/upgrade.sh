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

read_env_value() {
  local key="$1"

  if [[ ! -f "$ENV_FILE" ]] || ! grep -qE "^${key}=" "$ENV_FILE"; then
    return
  fi

  local current
  current="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  current="${current%\"}"
  current="${current#\"}"
  current="${current%\'}"
  current="${current#\'}"
  printf '%s\n' "$current"
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\/&|]/\\&/g'
}

set_env_value() {
  local key="$1"
  local value="$2"
  local replacement

  replacement="$(escape_sed_replacement "$value")"
  if grep -qE "^${key}=" "$ENV_FILE"; then
    sed -i -E "s|^${key}=.*|${key}=${replacement}|" "$ENV_FILE"
    echo "Updated $key"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added $key"
}

generate_secret() {
  local secret=""
  local chunk=""

  while [[ ${#secret} -lt 64 ]]; do
    chunk="$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $((64 - ${#secret})) || true)"
    secret="${secret}${chunk}"
  done
  printf '%s\n' "$secret"
}

if [[ -f "$ENV_FILE" ]]; then
  app_secret="$(read_env_value APP_SECRET || true)"
  if [[ -z "$app_secret" ]]; then
    set_env_value "APP_SECRET" "$(generate_secret)"
  else
    echo "APP_SECRET already exists"
  fi

  trusted_hosts="$(read_env_value TRUSTED_HOSTS || true)"
  if [[ -z "$trusted_hosts" ]]; then
    set_env_value "TRUSTED_HOSTS" ".*"
  else
    echo "TRUSTED_HOSTS already exists"
  fi

  ensure_env_default "TRUSTED_PROXIES" "127.0.0.1/32"
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
