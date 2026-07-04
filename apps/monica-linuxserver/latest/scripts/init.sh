#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"
LEGACY_MONICA_DB_PASSWORD="monica-change-me"

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

CONFIG_PATH_VALUE="${CONFIG_PATH:-$(read_env_value CONFIG_PATH || true)}"
CONFIG_PATH_VALUE="${CONFIG_PATH_VALUE:-./data/config}"
DB_PASSWORD_CACHE="${DB_PASSWORD_CACHE:-${CONFIG_PATH_VALUE}/.monica_db_password}"

if [[ -f "$ENV_FILE" ]]; then
  db_password="$(read_env_value DB_PASSWORD || true)"
  cached_db_password="$(read_cache_value "$DB_PASSWORD_CACHE" || true)"
  if [[ -n "$db_password" && "$db_password" != "$LEGACY_MONICA_DB_PASSWORD" ]]; then
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
