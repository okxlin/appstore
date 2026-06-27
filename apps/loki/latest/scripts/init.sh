#!/usr/bin/env bash
set -euo pipefail
DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${DATA_DIR}/chunks" "${DATA_DIR}/rules" "${DATA_DIR}/wal" "${DATA_DIR}/compactor"
chown -R 10001:10001 "${DATA_DIR}" 2>/dev/null || true
