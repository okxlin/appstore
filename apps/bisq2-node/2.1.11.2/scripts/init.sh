#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

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
pairing_ttl="$(configured_value PAIRING_TTL_SECONDS 86400)"

[[ -n "$data_raw" && "$data_raw" != /* && "$data_raw" =~ ^[A-Za-z0-9._/-]+$ ]] || {
  printf '%s\n' 'APP_DATA_DIR must be a non-empty relative path using only letters, digits, dots, underscores, hyphens, and slashes' >&2
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

if [[ ! "$pairing_ttl" =~ ^[0-9]+$ ]] || ((10#$pairing_ttl < 300 || 10#$pairing_ttl > 86400)); then
  printf '%s\n' 'PAIRING_TTL_SECONDS must be an integer from 300 through 86400' >&2
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
