#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${DATA_DIR}/logs" "${DATA_DIR}/cache"
chown -R 13:13 "${DATA_DIR}/logs" "${DATA_DIR}/cache"
