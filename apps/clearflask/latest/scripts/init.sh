#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
DATA_DIR="$ROOT_DIR/data"

if [[ -L "$DATA_DIR" || ( -e "$DATA_DIR" && ! -d "$DATA_DIR" ) ]]; then
  echo "ClearFlask data path must be a directory and must not be a symbolic link: $DATA_DIR" >&2
  exit 1
fi

mkdir -p \
  "$DATA_DIR/server" \
  "$DATA_DIR/connect" \
  "$DATA_DIR/shared" \
  "$DATA_DIR/mysql" \
  "$DATA_DIR/localstack"
