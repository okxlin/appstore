#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

case "$ENV_FILE" in
  /*) ;;
  *) ENV_FILE="$ROOT_DIR/${ENV_FILE#./}" ;;
esac

ENV_FILE="$(realpath -m -- "$ENV_FILE")"
case "$ENV_FILE" in
  "$ROOT_DIR"/*) ;;
  *) echo "unsafe ENV_FILE path" >&2; exit 1 ;;
esac

if [[ -L "$ENV_FILE" ]]; then
  echo "unsafe ENV_FILE path" >&2
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "$ENV_FILE not found; skipped Immich environment migration"
  exit 0
fi

if grep -qE '^DB_STORAGE_TYPE=' "$ENV_FILE"; then
  echo "DB_STORAGE_TYPE already exists"
else
  if [[ -s "$ENV_FILE" && "$(tail -c 1 "$ENV_FILE")" != $'\n' ]]; then
    printf '\n' >> "$ENV_FILE"
  fi
  printf '%s\n' 'DB_STORAGE_TYPE=SSD' >> "$ENV_FILE"
  echo "Added DB_STORAGE_TYPE"
fi
