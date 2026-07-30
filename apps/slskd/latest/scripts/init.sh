#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
DATA_DIR="$ROOT_DIR/data"

for path in "$DATA_DIR" "$DATA_DIR/downloads" "$DATA_DIR/incomplete" "$DATA_DIR/shared"; do
  [[ ! -L "$path" ]] || {
    printf 'Refusing symbolic link data path: %s\n' "$path" >&2
    exit 1
  }
done

install -d -m 0750 "$DATA_DIR" "$DATA_DIR/downloads" "$DATA_DIR/incomplete" "$DATA_DIR/shared"
chown 1000:1000 "$DATA_DIR" "$DATA_DIR/downloads" "$DATA_DIR/incomplete" "$DATA_DIR/shared"
