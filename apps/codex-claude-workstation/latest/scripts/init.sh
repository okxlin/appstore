#!/bin/bash
# init.sh — codex-claude-workstation 1Panel 初始化脚本
set -eo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DATA_DIR_RAW="${APP_DATA_DIR:-./data}"
CODEX_UID="${CODEX_UID:-1001}"
CODEX_GID="${CODEX_GID:-1001}"

if [[ "$APP_DATA_DIR_RAW" = /* ]]; then
  APP_DATA_DIR_ABS="$APP_DATA_DIR_RAW"
else
  APP_DATA_DIR_ABS="$ROOT_DIR/${APP_DATA_DIR_RAW#./}"
fi

WORKSPACE_DIR="$APP_DATA_DIR_ABS/workspace"

mkdir -p "$WORKSPACE_DIR"
chown -R "$CODEX_UID:$CODEX_GID" "$WORKSPACE_DIR" 2>/dev/null || true

echo "Codex Claude Workstation installed successfully."
echo ""
echo "Persistent directories:"
echo "  ${WORKSPACE_DIR} -> /workspace (${CODEX_UID}:${CODEX_GID})"
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
