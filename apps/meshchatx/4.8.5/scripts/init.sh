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

resolve_app_path() {
  local raw="$1"
  local path
  [[ -n "$raw" ]] || {
    printf '%s\n' 'APP_DATA_DIR must not be empty' >&2
    exit 1
  }
  if [[ "$raw" = /* ]]; then
    printf '%s\n' 'APP_DATA_DIR must be relative to the application version directory' >&2
    exit 1
  fi

  path="$(realpath -m -- "$ROOT_DIR/${raw#./}")"
  case "$path" in
    "$ROOT_DIR"/*) printf '%s\n' "$path" ;;
    *)
      printf '%s\n' 'APP_DATA_DIR must remain inside the application version directory' >&2
      exit 1
      ;;
  esac
}

data_dir="$(resolve_app_path "$(configured_value "APP_DATA_DIR" "./data")")"
install -d -m 0750 "$data_dir"
data_dir="$(realpath -e -- "$data_dir")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *)
    printf '%s\n' 'APP_DATA_DIR resolves outside the application version directory' >&2
    exit 1
    ;;
esac
chown -R --no-dereference 1000:1000 "$data_dir"
