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

configured_value() {
  local key="$1"
  local default_value="$2"
  local value="${!key:-}"
  if [[ -z "$value" ]]; then
    value="$(read_env_value "$key")"
  fi
  printf '%s\n' "${value:-$default_value}"
}

data_raw="$(configured_value APP_DATA_DIR ./data)"
admin_username="$(configured_value ADMIN_USERNAME admin)"
admin_password="$(configured_value ADMIN_PASSWORD '')"

[[ -n "$data_raw" && "$data_raw" != /* ]] || {
  printf '%s\n' 'APP_DATA_DIR must be a non-empty relative path' >&2
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

[[ "$admin_username" =~ ^[A-Za-z0-9._-]{1,64}$ ]] || {
  printf '%s\n' 'ADMIN_USERNAME must contain 1 to 64 letters, numbers, dots, underscores, or hyphens' >&2
  exit 1
}
[[ ${#admin_password} -ge 12 && ${#admin_password} -le 256 ]] || {
  printf '%s\n' 'ADMIN_PASSWORD must contain 12 to 256 characters' >&2
  exit 1
}
if [[ "$admin_password" == *$'\n'* || "$admin_password" == *$'\r'* ]]; then
  printf '%s\n' 'ADMIN_PASSWORD must not contain line breaks' >&2
  exit 1
fi

install -d -m 0750 "$data_dir"
data_dir="$(realpath -e -- "$data_dir")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *)
    printf '%s\n' 'APP_DATA_DIR resolves outside the application version directory' >&2
    exit 1
    ;;
esac
chmod 0750 "$data_dir"
