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

mkdir -p "${DATA_PATH}/mx-space" "${DATA_PATH}/postgres" "${DATA_PATH}/redis"
