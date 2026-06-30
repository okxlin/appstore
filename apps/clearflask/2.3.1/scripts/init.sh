#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p \
  "${DATA_DIR}/server" \
  "${DATA_DIR}/connect" \
  "${DATA_DIR}/shared" \
  "${DATA_DIR}/mysql" \
  "${DATA_DIR}/localstack"
