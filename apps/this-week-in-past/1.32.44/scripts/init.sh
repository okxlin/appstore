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
  [[ -f "$ENV_FILE" ]] || return 0
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

photo_path="$(configured_value PHOTO_LIBRARY_PATH ./data/photos)"
[[ -n "$photo_path" ]] || fail "PHOTO_LIBRARY_PATH must not be empty"
if [[ "$photo_path" = /* ]]; then
  resolved_photo_path="$(realpath -m -- "$photo_path")"
else
  resolved_photo_path="$(realpath -m -- "$ROOT_DIR/${photo_path#./}")"
  case "$resolved_photo_path" in
    "$ROOT_DIR"/*) ;;
    *) fail "relative PHOTO_LIBRARY_PATH must remain inside the application version directory" ;;
  esac
fi
mkdir -p -- "$resolved_photo_path"
[[ -d "$resolved_photo_path" ]] || fail "PHOTO_LIBRARY_PATH must resolve to a directory"

data_path="$(configured_value APP_DATA_DIR ./data/app)"
[[ -n "$data_path" ]] || fail "APP_DATA_DIR must not be empty"
[[ "$data_path" != /* ]] || fail "APP_DATA_DIR must be relative to the application version directory"
resolved_data_path="$(realpath -m -- "$ROOT_DIR/${data_path#./}")"
case "$resolved_data_path" in
  "$ROOT_DIR"/*) ;;
  *) fail "APP_DATA_DIR must remain inside the application version directory" ;;
esac
[[ ! -L "$resolved_data_path" ]] || fail "APP_DATA_DIR must not be a symbolic link"
install -d -m 0750 -- "$resolved_data_path"
resolved_data_path="$(realpath -e -- "$resolved_data_path")"
case "$resolved_data_path" in
  "$ROOT_DIR"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
chown -R --no-dereference 1337:1337 "$resolved_data_path"
chmod 0750 "$resolved_data_path"
