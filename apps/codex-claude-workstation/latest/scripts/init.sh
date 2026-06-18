#!/bin/bash
# init.sh — codex-claude-workstation 1Panel 初始化脚本
set -eo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DATA_DIR_RAW="${APP_DATA_DIR:-./data}"
CUSTOM_ENV_FILE_RAW="${CUSTOM_ENV_FILE:-./data/custom.env}"
CODEX_UID="${CODEX_UID:-1001}"
CODEX_GID="${CODEX_GID:-1001}"

resolve_app_path() {
  local raw="$1"
  if [[ "$raw" = /* ]]; then
    printf '%s\n' "$raw"
  else
    printf '%s\n' "$ROOT_DIR/${raw#./}"
  fi
}

APP_DATA_DIR_ABS="$(resolve_app_path "$APP_DATA_DIR_RAW")"
CUSTOM_ENV_FILE_ABS="$(resolve_app_path "$CUSTOM_ENV_FILE_RAW")"

WORKSPACE_DIR="$APP_DATA_DIR_ABS/workspace"

mkdir -p "$WORKSPACE_DIR"
mkdir -p "$(dirname "$CUSTOM_ENV_FILE_ABS")"
touch "$CUSTOM_ENV_FILE_ABS"
chown -R "$CODEX_UID:$CODEX_GID" "$WORKSPACE_DIR" 2>/dev/null || true
chown "$CODEX_UID:$CODEX_GID" "$CUSTOM_ENV_FILE_ABS" 2>/dev/null || true

echo "Codex Claude Workstation installed successfully."
echo ""
echo "Persistent directories:"
echo "  ${WORKSPACE_DIR} -> /workspace (${CODEX_UID}:${CODEX_GID})"
echo "  ${CUSTOM_ENV_FILE_ABS} -> custom env_file"
echo ""
echo "Access:"
echo "  http://<server-ip>:${PANEL_APP_PORT_HTTP}"
echo "  Login: code-server password"
echo "  Switch to root: su - root (password configured from ROOT_PASSWORD)"
echo ""
echo "AI Tools (run in code-server terminal):"
echo "  codex --help          OpenAI Codex CLI"
echo "  claude --help         Anthropic Claude Code"
echo "  npm install -g <pkg>  Installs to persistent ~/.local"
echo ""
echo "Docker CLI (DOCKER_SOCK_SRC=/var/run/docker.sock by default; leave empty to disable):"
echo "  docker ps"
echo "  sudo docker ps  # fallback if host socket permissions block direct access"
echo ""
echo "Codex sandbox:"
echo "  doctor.sh"
echo "  Host must allow kernel.unprivileged_userns_clone=1"
echo ""
echo "Proxy (manual enable):"
echo "  supervisorctl start clash-meta  # or sing-box, xray"
echo "  Configs: ~/proxy/"
