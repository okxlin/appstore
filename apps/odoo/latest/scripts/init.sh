#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p \
  "${DATA_DIR}/odoo-data" \
  "${DATA_DIR}/addons" \
  "${DATA_DIR}/postgres"

chown -R 100:101 \
  "${DATA_DIR}/odoo-data" \
  "${DATA_DIR}/addons"
