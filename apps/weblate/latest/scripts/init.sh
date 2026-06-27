#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p \
  "${DATA_DIR}/postgres" \
  "${DATA_DIR}/redis" \
  "${DATA_DIR}/weblate-data" \
  "${DATA_DIR}/weblate-cache"

chown -R 1000:1000 \
  "${DATA_DIR}/weblate-data" \
  "${DATA_DIR}/weblate-cache"
