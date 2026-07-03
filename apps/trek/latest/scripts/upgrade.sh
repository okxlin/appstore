#!/bin/bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
UPLOADS_DIR="${APP_UPLOADS_DIR:-./data/uploads}"
mkdir -p "$DATA_DIR" "$UPLOADS_DIR"
