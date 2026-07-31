#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

read_env_value() {
  local key="$1"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  fi
  value="${value%$'\r'}"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

data_root="$(read_env_value APP_DATA_DIR)"
data_root="${data_root:-./data}"
if [[ "$data_root" != /* ]]; then
  data_root="${ROOT_DIR}/${data_root}"
fi

install -d -m 0750 -o 1000 -g 1000 -- "${data_root}/data" "${data_root}/imports"
