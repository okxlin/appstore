#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must be a regular file"

master_key="${GOMODEL_MASTER_KEY:-$(read_env_value GOMODEL_MASTER_KEY)}"
data_value="${APP_DATA_DIR:-$(read_env_value APP_DATA_DIR)}"
[[ -n "$data_value" ]] || data_value='./data'

[[ ${#master_key} -ge 24 && ${#master_key} -le 512 ]] || fail 'GOMODEL_MASTER_KEY must contain 24 to 512 characters'
[[ "$master_key" != *$'\n'* && "$master_key" != *$'\r'* ]] || fail 'GOMODEL_MASTER_KEY must not contain line breaks'
[[ "$data_value" != /* ]] || fail 'APP_DATA_DIR must remain relative to the application version directory'

data_candidate="$ROOT_DIR/${data_value#./}"
[[ ! -L "$data_candidate" ]] || fail 'APP_DATA_DIR must not be a symbolic link'
data_dir="$(realpath -m -- "$data_candidate")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *) fail 'APP_DATA_DIR must remain inside the application version directory' ;;
esac
[[ ! -e "$data_dir" || -d "$data_dir" ]] || fail 'APP_DATA_DIR must be a directory'

install -d -m 0750 -- "$data_dir"
chown 65532:65532 -- "$data_dir"
chmod 0750 -- "$data_dir"
