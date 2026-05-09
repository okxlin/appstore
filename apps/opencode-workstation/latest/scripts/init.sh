#!/bin/bash
set -euo pipefail

mkdir -p "${APP_DATA_DIR_1:-./data/workspace}" \
         "${APP_DATA_DIR_2:-./data/home-config}" \
         "${APP_DATA_DIR_3:-./data/home-share}" \
         "${APP_DATA_DIR_4:-./data/home-agents}" \
         "${APP_DATA_DIR_5:-./data/home-claude}" \
         "${APP_DATA_DIR_6:-./data/home-opencode}"

echo '[opencode-workstation:init] initialized persistent directories:'
echo "  ${APP_DATA_DIR_1:-./data/workspace} -> /workspace"
echo "  ${APP_DATA_DIR_2:-./data/home-config} -> /home/opencode/.config"
echo "  ${APP_DATA_DIR_3:-./data/home-share} -> /home/opencode/.local/share"
echo "  ${APP_DATA_DIR_4:-./data/home-agents} -> /home/opencode/.agents"
echo "  ${APP_DATA_DIR_5:-./data/home-claude} -> /home/opencode/.claude"
echo "  ${APP_DATA_DIR_6:-./data/home-opencode} -> /home/opencode/.opencode"
echo '[opencode-workstation:init] default serve address: http://0.0.0.0:4096'
echo '[opencode-workstation:init] ACP port: 8765'
