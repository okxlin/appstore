#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p \
  "${DATA_DIR}/config" \
  "${DATA_DIR}/files" \
  "${DATA_DIR}/postgres" \
  "${DATA_DIR}/redis"

chown -R 991:991 "${DATA_DIR}/config" "${DATA_DIR}/files" 2>/dev/null || true
