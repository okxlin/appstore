#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

read_env_value() {
  local key="$1"
  local value=""
  [[ -f "$ENV_FILE" ]] || return 0
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

config_path="${CONFIG_PATH:-$(read_env_value CONFIG_PATH)}"
config_path="${config_path:-./data/config}"

if [[ "$config_path" == /* ]]; then
  resolved_config_path="$(realpath -m -- "$config_path")"
  chown_config=false
else
  resolved_config_path="$(realpath -m -- "$ROOT_DIR/${config_path#./}")"
  case "$resolved_config_path" in
    "$ROOT_DIR"/*) ;;
    *) printf '%s\n' 'CONFIG_PATH must remain inside the application version directory' >&2; exit 1 ;;
  esac
  chown_config=true
fi

[[ ! -L "$resolved_config_path" ]] || {
  printf '%s\n' 'CONFIG_PATH must not be a symbolic link' >&2
  exit 1
}
mkdir -p -- "$resolved_config_path"
if [[ "$chown_config" == true ]]; then
  chown -R 1000:1000 -- "$resolved_config_path" 2>/dev/null || true
fi
