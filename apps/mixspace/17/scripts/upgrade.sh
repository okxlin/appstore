#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

generate_secret() {
  if [[ -r /dev/urandom ]]; then
    local secret=""
    local chunk=""
    while [[ ${#secret} -lt 32 ]]; do
      chunk="$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $((32 - ${#secret})) || true)"
      secret="${secret}${chunk}"
    done
    printf '%s\n' "$secret"
  else
    printf '%s\n' 'MxPostgres2026ChangeThisValue01'
  fi
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\/&|]/\\&/g'
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
    current="${current%\'}"
    current="${current#\'}"
    if [[ "$fill_empty" == "true" && -z "$current" ]]; then
      local replacement
      replacement="$(escape_sed_replacement "$value")"
      sed -i -E "s|^${key}=.*|${key}=${replacement}|" "$ENV_FILE"
      echo "Updated empty $key"
    else
      echo "$key already exists"
    fi
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

DATA_PATH="${DATA_PATH:-$(read_env_value DATA_PATH || true)}"
DATA_PATH="${DATA_PATH:-./data}"
PG_PASSWORD_CACHE="${PG_PASSWORD_CACHE:-${DATA_PATH}/.mixspace_pg_password}"
JWT_SECRET_CACHE="${JWT_SECRET_CACHE:-${DATA_PATH}/.mixspace_jwt_secret}"

write_secret_cache() {
  local cache_file="$1"
  local value="$2"

  mkdir -p "$(dirname "$cache_file")"
  printf '%s\n' "$value" > "$cache_file"
  chmod 600 "$cache_file" 2>/dev/null || true
}

ensure_cached_secret() {
  local key="$1"
  local cache_file="$2"
  local value

  value="$(read_env_value "$key" || true)"
  if [[ -n "$value" ]]; then
    local cached=""
    if [[ -s "$cache_file" ]]; then
      cached="$(sed -n '1p' "$cache_file" | tr -d '\r\n')"
    fi
    if [[ "$cached" != "$value" ]]; then
      write_secret_cache "$cache_file" "$value"
    fi
    echo "$key already exists"
    return
  fi

  if [[ -s "$cache_file" ]]; then
    value="$(sed -n '1p' "$cache_file" | tr -d '\r\n')"
  fi
  if [[ -z "$value" ]]; then
    value="$(generate_secret)"
    write_secret_cache "$cache_file" "$value"
  fi

  ensure_env_default "$key" "$value" true
}

mkdir -p "${DATA_PATH}/mx-space" "${DATA_PATH}/postgres" "${DATA_PATH}/redis"

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_default "DATA_PATH" "./data" true
  ensure_cached_secret "PG_PASSWORD" "$PG_PASSWORD_CACHE"
  ensure_cached_secret "JWT_SECRET" "$JWT_SECRET_CACHE"
  ensure_env_default "SUBNET_PREFIX" "10.250.0" true
else
  echo "$ENV_FILE not found; skipped MixSpace environment migration"
fi

if [[ -d "${DATA_PATH}/db" ]]; then
  echo "Found legacy MongoDB data at ${DATA_PATH}/db. It is preserved, but this script does not migrate MongoDB data to PostgreSQL."
fi
