#!/bin/bash
# init.sh — codex-claude-workstation 1Panel 初始化脚本
set -eo pipefail

echo "Codex Claude Workstation installed successfully."
echo ""
echo "Access:"
echo "  http://<server-ip>:${PANEL_APP_PORT_HTTP}"
echo "  Login: code-server password"
echo "  Switch to root: su - root (password: ${ROOT_PASSWORD:-codex2024})"
echo ""
echo "AI Tools (run in code-server terminal):"
echo "  codex --help          OpenAI Codex CLI"
echo "  claude --help         Anthropic Claude Code"
echo ""
echo "Docker CLI (if DOCKER_SOCK_SRC set):"
echo "  su - root"
echo "  docker ps"
echo ""
echo "Proxy (manual enable):"
echo "  supervisorctl start clash-meta  # or sing-box, xray"
echo "  Configs: ~/proxy/"
