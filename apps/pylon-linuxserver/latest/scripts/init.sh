#!/usr/bin/env bash
set -euo pipefail

paths=(
  "${CODE_PATH:-./data/code}"
)

mkdir -p "${paths[@]}"
for path in "${paths[@]}"; do
  case "$path" in
    ./*|../*) chown -R 1000:1000 "$path" 2>/dev/null || true ;;
  esac
done
