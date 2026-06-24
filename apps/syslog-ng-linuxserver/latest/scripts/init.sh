#!/usr/bin/env bash
set -euo pipefail

paths=(
  "${CONFIG_PATH:-./data/config}"
  "${LOG_PATH:-./data/log}"
)

mkdir -p "${paths[@]}"
for path in "${paths[@]}"; do
  case "$path" in
    ./*|../*) chown -R 1000:1000 "$path" 2>/dev/null || true ;;
  esac
done
