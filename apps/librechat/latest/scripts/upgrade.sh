#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p \
  "${DATA_DIR}/images" \
  "${DATA_DIR}/uploads" \
  "${DATA_DIR}/logs" \
  "${DATA_DIR}/skill" \
  "${DATA_DIR}/mongodb" \
  "${DATA_DIR}/meilisearch" \
  "${DATA_DIR}/pgvector"

chown -R 1000:1000 \
  "${DATA_DIR}/images" \
  "${DATA_DIR}/uploads" \
  "${DATA_DIR}/logs" \
  "${DATA_DIR}/skill"
