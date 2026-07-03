#!/bin/bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data/app}"
MODELS_DIR="${APP_MODELS_DIR:-./data/models}"
mkdir -p "$DATA_DIR" "$MODELS_DIR"
