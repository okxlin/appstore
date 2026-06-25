#!/usr/bin/env bash
set -euo pipefail

paths=(
  "${ATTACHMENTS_PATH:-./data/attachments}"
  "${CONFIG_PATH:-./data/config}"
)

mkdir -p "${paths[@]}"
