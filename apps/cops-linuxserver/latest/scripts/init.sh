#!/usr/bin/env bash
set -euo pipefail

paths=(
  "${BOOKS_PATH:-./data/books}"
  "${CONFIG_PATH:-./data/config}"
)

mkdir -p "${paths[@]}"
for path in "${paths[@]}"; do
  case "$path" in
    ./*|../*) chown -R 1000:1000 "$path" 2>/dev/null || true ;;
  esac
done
