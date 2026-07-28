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

prepare_data_directory() {
  local raw path
  raw="${APP_DATA_DIR:-}"
  if [[ -z "$raw" ]]; then
    raw="$(read_env_value APP_DATA_DIR)"
  fi
  raw="${raw:-./data}"

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
    "$ROOT_DIR"/*) ;;
    *)
      printf '%s\n' 'APP_DATA_DIR must remain inside the application version directory' >&2
      exit 1
      ;;
  esac

  install -d -m 0750 "$path"
  path="$(realpath -e -- "$path")"
  case "$path" in
    "$ROOT_DIR"/*) ;;
    *)
      printf '%s\n' 'APP_DATA_DIR resolves outside the application version directory' >&2
      exit 1
      ;;
  esac
}

prepare_data_directory
