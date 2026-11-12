#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
VERSION_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
APP_ROOT="$(cd -- "$VERSION_DIR/.." && pwd -P)"
paths=(
  "${CONFIG_PATH:-./data/config}"
)

mkdir -p -- "${paths[@]}"
for path in "${paths[@]}"; do
  resolved_path="$(cd -- "$path" && pwd -P)"
  case "$resolved_path" in
    "$APP_ROOT"/*) chown -R 1000:1000 -- "$resolved_path" 2>/dev/null || true ;;
    *) printf '%s\n' 'Skipping recursive ownership outside this app directory.' ;;
  esac
done
