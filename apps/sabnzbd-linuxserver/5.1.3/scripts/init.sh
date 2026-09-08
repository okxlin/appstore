#!/usr/bin/env bash
set -euo pipefail

paths=(
  "${CONFIG_PATH:-./data/config}"
  "${DOWNLOAD_PATH:-./data/downloads}"
  "${INCOMPLETE_DOWNLOAD_PATH:-./data/incomplete-downloads}"
)

mkdir -p "${paths[@]}"
