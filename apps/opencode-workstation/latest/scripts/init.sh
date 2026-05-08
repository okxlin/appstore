#!/bin/bash
set -euo pipefail

mkdir -p "${APP_DATA_DIR_1:-./data/workspace}" \
         "${APP_DATA_DIR_2:-./data/config}" \
         "${APP_DATA_DIR_3:-./data/cache}" \
         "${APP_DATA_DIR_4:-./data/runtime}"

echo '[opencode-workstation:init] initialized persistent directories:'
echo "  ${APP_DATA_DIR_1:-./data/workspace} -> /workspace"
echo "  ${APP_DATA_DIR_2:-./data/config} -> /config"
echo "  ${APP_DATA_DIR_3:-./data/cache} -> /cache"
echo "  ${APP_DATA_DIR_4:-./data/runtime} -> /data"
echo '[opencode-workstation:init] default serve address: http://0.0.0.0:4096'
echo '[opencode-workstation:init] ACP port: 8765'
