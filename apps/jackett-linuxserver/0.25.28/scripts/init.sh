#!/usr/bin/env bash
set -euo pipefail

paths=(
  "${CONFIG_PATH:-./data/config}"
  "${DOWNLOAD_PATH:-./data/downloads}"
)

mkdir -p "${paths[@]}"
