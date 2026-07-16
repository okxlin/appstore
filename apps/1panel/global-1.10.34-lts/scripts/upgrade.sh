#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
DATA_PATH="$(sed -n 's/^DATA_PATH=//p' "$ENV_FILE" | tail -n 1)"
DATA_PATH="${DATA_PATH#\"}"
DATA_PATH="${DATA_PATH%\"}"
[[ "$DATA_PATH" == /* ]] || DATA_PATH="$ROOT_DIR/${DATA_PATH:-./data}"

APP_DATA="$DATA_PATH/1panel"
if [[ -f "$APP_DATA/db/core.db" && ! -f "$APP_DATA/db/1Panel.db" ]]; then
  echo "Direct downgrade from 1Panel V2 to V1 is not supported" >&2
  exit 1
fi
if [[ -f "$APP_DATA/db/1Panel.db" ]]; then
  touch "$APP_DATA/.docker_initialized"
fi
