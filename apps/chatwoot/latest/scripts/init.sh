#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p \
  "${DATA_DIR}/storage" \
  "${DATA_DIR}/postgres" \
  "${DATA_DIR}/redis"
