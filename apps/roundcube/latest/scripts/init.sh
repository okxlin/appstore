#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${DATA_DIR}/db" "${DATA_DIR}/config" "${DATA_DIR}/enigma"
chown -R 33:33 "${DATA_DIR}/db" "${DATA_DIR}/enigma" 2>/dev/null || true
chmod 755 "${DATA_DIR}/config" 2>/dev/null || true
