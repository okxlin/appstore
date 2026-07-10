#!/usr/bin/env bash
set -euo pipefail

mkdir -p \
  "${UPLOAD_LOCATION:-./data/upload}" \
  "${CACHE_PATH:-./data/cache}" \
  "${DB_PATH:-./data/data}"
