#!/bin/bash
set -euo pipefail

if [[ -f ./.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source ./.env
  set +a
fi

CONFIG_DIR="${APP_CONFIG_DIR:-./data/config}"
STATE_DIR="${APP_STATE_DIR:-./data/state}"
mkdir -p "$CONFIG_DIR" "$STATE_DIR"
