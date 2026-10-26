#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${DATA_DIR}/storage" "${DATA_DIR}/cache"
chown -R 1000:1000 "${DATA_DIR}" 2>/dev/null || true
