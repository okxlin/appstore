#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

DATA_DIR="$ROOT_DIR/data"
[[ ! -L "$DATA_DIR" ]] || { echo "unsafe PACKAGE_DATA_DIR path" >&2; exit 1; }
mkdir -p -- "$DATA_DIR"
[[ ! -L "$DATA_DIR" ]] || { echo "unsafe PACKAGE_DATA_DIR path" >&2; exit 1; }
