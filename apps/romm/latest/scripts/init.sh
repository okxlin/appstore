#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

read_env_value() {
  local key="$1"
  [ -f "$ENV_FILE" ] || return 0
  sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1
}

DATA_DIR="${APP_DATA_DIR:-$(read_env_value APP_DATA_DIR)}"
DATA_DIR="${DATA_DIR:-./data}"

case "$DATA_DIR" in
  /|.|"")
    echo "Refusing unsafe APP_DATA_DIR: '$DATA_DIR'" >&2
    exit 1
    ;;
esac

umask 077
mkdir -p \
  "$DATA_DIR/romm/library/roms" \
  "$DATA_DIR/romm/assets" \
  "$DATA_DIR/romm/config" \
  "$DATA_DIR/romm/resources" \
  "$DATA_DIR/redis" \
  "$DATA_DIR/mariadb"

chmod 755 \
  "$DATA_DIR/romm" \
  "$DATA_DIR/romm/library" \
  "$DATA_DIR/romm/library/roms" \
  "$DATA_DIR/romm/assets" \
  "$DATA_DIR/romm/config" \
  "$DATA_DIR/romm/resources" \
  "$DATA_DIR/redis"
chmod 700 "$DATA_DIR/mariadb"
