#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p \
  "${DATA_DIR}/app" \
  "${DATA_DIR}/logs/supervisor"
