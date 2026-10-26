#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

read_env_value() {
  local key="$1"
  [[ -f "$ENV_FILE" ]] || return 0
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

data_raw="${APP_DATA_DIR:-}"
if [[ -z "$data_raw" ]]; then
  data_raw="$(read_env_value APP_DATA_DIR)"
fi
data_raw="${data_raw:-./data}"

[[ "$data_raw" != /* ]] || {
  printf '%s\n' 'APP_DATA_DIR must be a relative path' >&2
  exit 1
}

data_dir="$(realpath -m -- "$ROOT_DIR/${data_raw#./}")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *)
    printf '%s\n' 'APP_DATA_DIR must remain inside the application version directory' >&2
    exit 1
    ;;
esac

mkdir -p -- "$data_dir"
resolved_data_dir="$(realpath -e -- "$data_dir")"
case "$resolved_data_dir" in
  "$ROOT_DIR"/*) ;;
  *)
    printf '%s\n' 'APP_DATA_DIR resolves outside the application version directory' >&2
    exit 1
    ;;
esac

chown 1000:1000 -- "$resolved_data_dir"
chmod 0700 -- "$resolved_data_dir"
