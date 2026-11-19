#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
DATA_DIR="$ROOT_DIR/data"
CONFIG_FILE="$DATA_DIR/config.yaml"
DEFAULT_CONFIG="$ROOT_DIR/default-config.yaml"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

[[ ! -L "$DATA_DIR" ]] || fail "data must not be a symbolic link"
[[ ! -L "$CONFIG_FILE" ]] || fail "config.yaml must not be a symbolic link"
[[ -f "$DEFAULT_CONFIG" ]] || fail "$DEFAULT_CONFIG not found"

install -d -m 0750 -- "$DATA_DIR"
resolved_data="$(realpath -e -- "$DATA_DIR")"
case "$resolved_data" in
  "$ROOT_DIR"/*) ;;
  *) fail "data resolves outside the application version directory" ;;
esac

if [[ ! -e "$CONFIG_FILE" ]]; then
  install -m 0640 -- "$DEFAULT_CONFIG" "$CONFIG_FILE"
fi
[[ -f "$CONFIG_FILE" ]] || fail "config.yaml must be a regular file"

if [[ "$(id -u)" -eq 0 ]]; then
  chown -R --no-dereference 1000:1000 "$DATA_DIR"
fi
chmod 0750 "$DATA_DIR"
chmod 0640 "$CONFIG_FILE"
