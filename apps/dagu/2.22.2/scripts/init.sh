#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

read_env_value() {
  local key="$1"
  local value
  [[ -f "$ENV_FILE" ]] || return 0
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  value="${value%$'\r'}"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

DATA_DIR="${APP_DATA_DIR:-}"
if [[ -z "$DATA_DIR" ]]; then
  DATA_DIR="$(read_env_value APP_DATA_DIR)"
fi
DATA_DIR="${DATA_DIR:-./data}"

if [[ "$DATA_DIR" = /* ]]; then
  RESOLVED_DATA_DIR="$(realpath -m -- "$DATA_DIR")"
  if [[ -L "$DATA_DIR" ]]; then
    printf 'APP_DATA_DIR must not be a symbolic link\n' >&2
    exit 1
  fi
  if [[ -e "$RESOLVED_DATA_DIR" ]]; then
    [[ -d "$RESOLVED_DATA_DIR" ]] || {
      printf 'APP_DATA_DIR must refer to a directory\n' >&2
      exit 1
    }
    [[ "$(stat -c '%u:%g' "$RESOLVED_DATA_DIR")" == '1000:1000' ]] || {
      printf 'Existing absolute APP_DATA_DIR must be owned by UID/GID 1000:1000\n' >&2
      exit 1
    }
  else
    install -d -m 0750 -- "$RESOLVED_DATA_DIR"
    if [[ "$(id -u)" -eq 0 ]]; then
      chown 1000:1000 -- "$RESOLVED_DATA_DIR"
    fi
  fi
else
  RESOLVED_DATA_DIR="$(realpath -m -- "$ROOT_DIR/${DATA_DIR#./}")"
  case "$RESOLVED_DATA_DIR" in
    "$ROOT_DIR"/*) ;;
    *)
      printf 'Relative APP_DATA_DIR must remain inside the application version directory\n' >&2
      exit 1
      ;;
  esac
  install -d -m 0750 -- "$RESOLVED_DATA_DIR"
  if [[ "$(id -u)" -eq 0 ]]; then
    chown 1000:1000 -- "$RESOLVED_DATA_DIR"
  fi
fi
