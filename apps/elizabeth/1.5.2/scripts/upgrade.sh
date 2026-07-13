#!/bin/bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data}"
STORAGE_DIR="${APP_STORAGE_DIR:-./storage}"
mkdir -p "$DATA_DIR" "$STORAGE_DIR"
