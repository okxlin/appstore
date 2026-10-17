#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"
LEGACY_BOOKSTACK_APP_KEY="base64:j1wQ2YbRrQ3j0tG5h6v8cYpV1gW9mN4uQ2xZ7aE3sT8="
LEGACY_BOOKSTACK_DB_PASSWORD="bookstack-change-me"

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
APP_KEY_CACHE="${APP_KEY_CACHE:-${CONFIG_PATH_VALUE}/.bookstack_app_key}"
DB_PASSWORD_CACHE="${DB_PASSWORD_CACHE:-${CONFIG_PATH_VALUE}/.bookstack_db_password}"

if [[ -f "$ENV_FILE" ]]; then
  app_key="$(read_env_value APP_KEY || true)"
  cached_app_key="$(read_cache_value "$APP_KEY_CACHE" || true)"
  if laravel_app_key_is_valid "$app_key" && [[ "$app_key" != "$LEGACY_BOOKSTACK_APP_KEY" ]]; then
    write_cache_value "$APP_KEY_CACHE" "$app_key"
  elif laravel_app_key_is_valid "$cached_app_key"; then
    set_env_value "APP_KEY" "$cached_app_key"
  else
    app_key="$(generate_laravel_app_key)"
    set_env_value "APP_KEY" "$app_key"
    write_cache_value "$APP_KEY_CACHE" "$app_key"
  fi

  db_password="$(read_env_value DB_PASSWORD || true)"
  cached_db_password="$(read_cache_value "$DB_PASSWORD_CACHE" || true)"
  if [[ -n "$db_password" && "$db_password" != "$LEGACY_BOOKSTACK_DB_PASSWORD" ]]; then
    write_cache_value "$DB_PASSWORD_CACHE" "$db_password"
  elif [[ -n "$cached_db_password" ]]; then
    set_env_value "DB_PASSWORD" "$cached_db_password"
  else
    db_password="$(generate_alnum_secret)"
    set_env_value "DB_PASSWORD" "$db_password"
    write_cache_value "$DB_PASSWORD_CACHE" "$db_password"
  fi
fi

paths=(
  "${CONFIG_PATH:-./data/config}"
  "${DB_DATA_PATH:-./data/db}"
)

mkdir -p "${paths[@]}"
for path in "${paths[@]}"; do
  case "$path" in
    ./*|../*) chown -R 1000:1000 "$path" 2>/dev/null || true ;;
  esac
done
