#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"
LEGACY_SPEEDTEST_APP_KEY="base64:dGVzdGluZy1saW51eHNlcnZlci1hcHBzLTEyMzQ1Njc="

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

read_cache_value() {
  local cache_file="$1"
  if [[ ! -s "$cache_file" ]]; then
    return
  fi
  sed -n '1p' "$cache_file" | tr -d '\r\n'
}

write_cache_value() {
  local cache_file="$1"
  local value="$2"

  mkdir -p "$(dirname "$cache_file")"
  printf '%s\n' "$value" > "$cache_file"
  chmod 600 "$cache_file" 2>/dev/null || true
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\/&|]/\\&/g'
}

set_env_value() {
  local key="$1"
  local value="$2"

  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped $key generation"
    return
  fi

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

generate_alnum_secret() {
  local secret=""
  local chunk=""
  while [[ ${#secret} -lt 32 ]]; do
    chunk="$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $((32 - ${#secret})) || true)"
    secret="${secret}${chunk}"
  done
  printf '%s\n' "$secret"
}

generate_laravel_app_key() {
  if command -v openssl >/dev/null 2>&1; then
    printf 'base64:%s\n' "$(openssl rand -base64 32 | tr -d '\r\n')"
    return
  fi

  if command -v base64 >/dev/null 2>&1; then
    printf 'base64:%s\n' "$(head -c 32 /dev/urandom | base64 | tr -d '\r\n')"
    return
  fi

  generate_alnum_secret
}

laravel_app_key_is_valid() {
  local value="$1"
  [[ "$value" =~ ^base64:[A-Za-z0-9+/=]{43,}$ ]] && return 0
  [[ "$value" =~ ^[A-Za-z0-9]{32,}$ ]] && return 0
  return 1
}

CONFIG_PATH_VALUE="${CONFIG_PATH:-$(read_env_value CONFIG_PATH || true)}"
CONFIG_PATH_VALUE="${CONFIG_PATH_VALUE:-./data/config}"
APP_KEY_CACHE="${APP_KEY_CACHE:-${CONFIG_PATH_VALUE}/.speedtest_tracker_app_key}"

if [[ -f "$ENV_FILE" ]]; then
  app_key="$(read_env_value APP_KEY || true)"
  cached_app_key="$(read_cache_value "$APP_KEY_CACHE" || true)"
  if laravel_app_key_is_valid "$app_key" && [[ "$app_key" != "$LEGACY_SPEEDTEST_APP_KEY" ]]; then
    write_cache_value "$APP_KEY_CACHE" "$app_key"
  elif laravel_app_key_is_valid "$cached_app_key"; then
    set_env_value "APP_KEY" "$cached_app_key"
  else
    app_key="$(generate_laravel_app_key)"
    set_env_value "APP_KEY" "$app_key"
    write_cache_value "$APP_KEY_CACHE" "$app_key"
  fi

  ensure_env_default "DB_CONNECTION" "sqlite"
  ensure_env_default "DB_HOST" ""
  ensure_env_default "DB_PORT" ""
  ensure_env_default "DB_DATABASE" ""
  ensure_env_default "DB_USERNAME" ""
  ensure_env_default "DB_PASSWORD" ""
  ensure_env_default "PRUNE_RESULTS_OLDER_THAN" "0"
  ensure_env_default "DISPLAY_TIMEZONE" "Asia/Shanghai"
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
