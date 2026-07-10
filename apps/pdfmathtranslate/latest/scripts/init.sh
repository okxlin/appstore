#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

read_env_value() {
  local key="$1"
  [ -f "$ENV_FILE" ] || return 0
  sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1
}

CONFIG_DIR="${APP_CONFIG_DIR:-$(read_env_value APP_CONFIG_DIR)}"
CACHE_DIR="${APP_CACHE_DIR:-$(read_env_value APP_CACHE_DIR)}"
OUTPUT_DIR="${APP_OUTPUT_DIR:-$(read_env_value APP_OUTPUT_DIR)}"

CONFIG_DIR="${CONFIG_DIR:-./data/config}"
CACHE_DIR="${CACHE_DIR:-./data/cache}"
OUTPUT_DIR="${OUTPUT_DIR:-./data/files}"

mkdir -p "$CONFIG_DIR" "$CACHE_DIR" "$OUTPUT_DIR"
chmod 700 "$CONFIG_DIR" "$CACHE_DIR"
chmod 755 "$OUTPUT_DIR"
