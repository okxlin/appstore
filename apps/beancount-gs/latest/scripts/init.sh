#!/usr/bin/env bash
set -euo pipefail
DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${DATA_DIR}/icons" "${DATA_DIR}/config" "${DATA_DIR}/bak" "${DATA_DIR}/logs"
