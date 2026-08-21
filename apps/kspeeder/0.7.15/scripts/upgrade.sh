#!/bin/bash
set -euo pipefail

DATA_DIR="${APP_DATA_DIR:-./data/runtime}"
CONFIG_DIR="${APP_CONFIG_DIR:-./data/config}"
mkdir -p "$DATA_DIR" "$CONFIG_DIR"
