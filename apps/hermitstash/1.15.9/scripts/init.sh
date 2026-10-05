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

prepare_app_path() {
  local key="$1"
  local default_value="$2"
  local raw path
  raw="$(configured_value "$key" "$default_value")"

  [[ -n "$raw" ]] || {
    printf '%s must not be empty\n' "$key" >&2
    exit 1
  }
  if [[ "$raw" = /* ]]; then
    printf '%s must be relative to the application version directory\n' "$key" >&2
    exit 1
  fi

  path="$(realpath -m -- "$ROOT_DIR/${raw#./}")"
  case "$path" in
    "$ROOT_DIR"/*) ;;
    *)
      printf '%s must remain inside the application version directory\n' "$key" >&2
      exit 1
      ;;
  esac

  install -d -m 0700 "$path"
  path="$(realpath -e -- "$path")"
  case "$path" in
    "$ROOT_DIR"/*) ;;
    *)
      printf '%s resolves outside the application version directory\n' "$key" >&2
      exit 1
      ;;
  esac
  chmod 0700 "$path"
  chown -R --no-dereference 1000:1000 "$path"
}

prepare_app_path APP_DATA_DIR ./data
prepare_app_path APP_UPLOADS_DIR ./uploads
