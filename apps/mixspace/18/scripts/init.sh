#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

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

write_env_value() {
  local key="$1"
  local value="$2"

  if grep -qE "^${key}=" "$ENV_FILE"; then
    sed -i -E "s|^${key}=.*|${key}=\"${value}\"|" "$ENV_FILE"
  else
    printf '%s="%s"\n' "$key" "$value" >> "$ENV_FILE"
  fi
}

ensure_field_key() {
  local current key
  current="$(read_env_value ENCRYPT_KEY || true)"

  if [[ -n "$current" ]]; then
    if [[ ! "$current" =~ ^[[:xdigit:]]{64}$ ]]; then
      echo "ENCRYPT_KEY must be exactly 64 hexadecimal characters"
      return 1
    fi
    return
  fi

  if [[ -e "${DATA_PATH}/postgres/PG_VERSION" ]]; then
    echo "Existing PostgreSQL data found; the upgrade script will validate the existing field key"
    return
  fi

  key="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  if [[ ! "$key" =~ ^[[:xdigit:]]{64}$ ]]; then
    echo "Could not generate a 64-character field encryption key"
    return 1
  fi
  write_env_value ENCRYPT_KEY "$key"
  echo "Generated the initial field encryption key"
}

mkdir -p "${DATA_PATH}/mx-space" "${DATA_PATH}/postgres" "${DATA_PATH}/redis"
ensure_field_key
