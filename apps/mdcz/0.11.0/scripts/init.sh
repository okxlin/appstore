#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

read_env_value() {
  local key="$1"
  [ -f "$ENV_FILE" ] || return 0
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  value="${value%\"}"
  value="${value#\"}"
  value="${value%\'}"
  value="${value#\'}"
  printf '%s\n' "$value"
}

resolve_app_path() {
  local raw="$1"
  if [[ "$raw" = /* ]]; then
    printf '%s\n' "$raw"
  else
    printf '%s\n' "$ROOT_DIR/${raw#./}"
  fi
}

DATA_PATH="${APP_DATA_DIR:-$(read_env_value APP_DATA_DIR)}"
MEDIA_PATH="${MEDIA_DIR:-$(read_env_value MEDIA_DIR)}"

DATA_PATH="${DATA_PATH:-./data}"
MEDIA_PATH="${MEDIA_PATH:-./data/media}"

DATA_DIR="$(resolve_app_path "$DATA_PATH")"
MEDIA_PATH="$(resolve_app_path "$MEDIA_PATH")"

mkdir -p "$DATA_DIR" "$MEDIA_PATH"
chown -R 1000:1000 "$DATA_DIR"
chown 1000:1000 "$MEDIA_PATH"
chmod 755 "$DATA_DIR" "$MEDIA_PATH"
