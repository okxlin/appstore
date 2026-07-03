#!/bin/bash
set -euo pipefail

CONFIG_DIR="${APP_CONFIG_DIR:-./data/config}"
STATE_DIR="${APP_STATE_DIR:-./data/state}"
mkdir -p "$CONFIG_DIR" "$STATE_DIR"
