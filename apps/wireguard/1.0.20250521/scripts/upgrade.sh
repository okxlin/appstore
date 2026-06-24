#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${CONFIG_PATH:-./config}"
mkdir -p "$CONFIG_DIR"
chown -R "${PUID:-1000}:${PGID:-1000}" "$CONFIG_DIR" 2>/dev/null || true
