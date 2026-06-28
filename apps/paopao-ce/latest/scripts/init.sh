#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SQL="${SCRIPT_DIR}/../data/paopao-mysql.sql"

mkdir -p \
  "${DATA_DIR}/custom/data/paopao-ce/oss" \
  "${DATA_DIR}/custom/data/paopao-ce/logs" \
  "${DATA_DIR}/initdb" \
  "${DATA_DIR}/meili" \
  "${DATA_DIR}/mysql" \
  "${DATA_DIR}/redis"

if [ ! -f "${DATA_DIR}/initdb/paopao.sql" ]; then
  cp "${SOURCE_SQL}" "${DATA_DIR}/initdb/paopao.sql"
fi
