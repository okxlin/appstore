#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
DATA_PATH="$(sed -n 's/^DATA_PATH=//p' "$ENV_FILE" | tail -n 1)"
if [[ "$DATA_PATH" == \"*\" ]] || [[ "$DATA_PATH" == \'*\' ]]; then
  DATA_PATH="${DATA_PATH:1:${#DATA_PATH}-2}"
fi
DATA_PATH="${DATA_PATH:-/opt/1panel-data}"

if [[ "$DATA_PATH" != /* ]]; then
  DATA_PATH="$(realpath -m -- "$ROOT_DIR/$DATA_PATH")"
fi
if [[ "$DATA_PATH" != /* ]] || [[ "$DATA_PATH" =~ [[:space:]:] ]]; then
  echo "DATA_PATH must be an absolute path using common path characters" >&2
  exit 1
fi

mkdir -p -- "$DATA_PATH"
DATA_PATH_ESCAPED="$(printf '%s' "$DATA_PATH" | sed 's/[|&\\]/\\&/g')"
if grep -q '^DATA_PATH=' "$ENV_FILE"; then
  sed -i "s|^DATA_PATH=.*$|DATA_PATH=${DATA_PATH_ESCAPED}|" "$ENV_FILE"
else
  printf '\nDATA_PATH=%s\n' "$DATA_PATH" >> "$ENV_FILE"
fi


APP_DATA="$DATA_PATH/1panel"
if [[ -f "$APP_DATA/db/1Panel.db" && ! -f "$APP_DATA/db/core.db" ]]; then
  echo "Direct upgrade from 1Panel V1 to V2 is not supported" >&2
  exit 1
fi
if [[ -f "$APP_DATA/db/core.db" ]]; then
  touch "$APP_DATA/.docker_initialized"
fi
