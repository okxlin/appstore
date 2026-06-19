#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CUSTOM_ENV_FILE_RAW="${CUSTOM_ENV_FILE:-./data/custom.env}"

resolve_app_path() {
  local raw="$1"
  if [[ "$raw" = /* ]]; then
    printf '%s\n' "$raw"
  else
    printf '%s\n' "$ROOT_DIR/${raw#./}"
  fi
}

CUSTOM_ENV_FILE_ABS="$(resolve_app_path "$CUSTOM_ENV_FILE_RAW")"

mkdir -p "${APP_DATA_DIR_1:-./data/workspace}" \
         "${APP_DATA_DIR_2:-./data/home-config}" \
         "${APP_DATA_DIR_3:-./data/home-share}" \
         "${APP_DATA_DIR_4:-./data/home-agents}" \
         "${APP_DATA_DIR_5:-./data/home-claude}" \
         "${APP_DATA_DIR_6:-./data/home-opencode}"
mkdir -p "$(dirname "$CUSTOM_ENV_FILE_ABS")"
touch "$CUSTOM_ENV_FILE_ABS"

echo '[opencode-workstation:init] initialized persistent directories:'
echo "  ${APP_DATA_DIR_1:-./data/workspace} -> /workspace"
echo "  ${APP_DATA_DIR_2:-./data/home-config} -> /home/opencode/.config"
echo "  ${APP_DATA_DIR_3:-./data/home-share} -> /home/opencode/.local/share"
echo "  ${APP_DATA_DIR_4:-./data/home-agents} -> /home/opencode/.agents"
echo "  ${APP_DATA_DIR_5:-./data/home-claude} -> /home/opencode/.claude"
echo "  ${APP_DATA_DIR_6:-./data/home-opencode} -> /home/opencode/.opencode"
echo "  ${CUSTOM_ENV_FILE_ABS} -> custom env_file"
echo '[opencode-workstation:init] default serve address: http://0.0.0.0:4096'
echo '[opencode-workstation:init] ACP port: 8765'
