#!/usr/bin/env bash
set -euo pipefail

paths=(
  "${CONFIG_PATH:-./data/config}"
)

mkdir -p "${paths[@]}"
