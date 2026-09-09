#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker-compose.yml"
COMPOSE_CMD=(docker compose -f "$COMPOSE_FILE" --project-directory "$ROOT_DIR")

# 读取环境变量并提供默认值（与 docker-compose/.env 保持一致）
CONFIG_DIR_RAW="${OPENCLAW_CONFIG_DIR:-./data/conf}"
WORKSPACE_DIR_RAW="${OPENCLAW_WORKSPACE_DIR:-./data/workspace}"
BIND="${OPENCLAW_GATEWAY_BIND:-lan}"
PORT="${PANEL_APP_PORT_HTTP:-${OPENCLAW_GATEWAY_PORT:-18789}}"

# 尝试自动获取宿主机 docker 套接字的 GID 并更新至 .env 中
if [ -f "$ROOT_DIR/.env" ]; then
  # 优先从 .env 读取用户配置的套接字路径，默认为 /var/run/docker.sock
  SOCK_PATH=$(grep "^DOCKER_SOCK_PATH=" "$ROOT_DIR/.env" 2>/dev/null | cut -d '=' -f2 | tr -d '"' | tr -d "'")
  SOCK_PATH=${SOCK_PATH:-/var/run/docker.sock}

  if [ -e "$SOCK_PATH" ]; then
    AUTO_GID=$(stat -c '%g' "$SOCK_PATH" 2>/dev/null || echo "999")
    if grep -q "^DOCKER_GID=" "$ROOT_DIR/.env" 2>/dev/null; then
      sed -i "s|^DOCKER_GID=.*|DOCKER_GID=${AUTO_GID}|" "$ROOT_DIR/.env"
    else
      echo "DOCKER_GID=${AUTO_GID}" >> "$ROOT_DIR/.env"
    fi
    echo "==> 自动检测到 Docker GID: ${AUTO_GID}"
  fi
fi

# 支持相对路径与绝对路径
if [[ "$CONFIG_DIR_RAW" = /* ]]; then
  CONFIG_DIR="$CONFIG_DIR_RAW"
else
  CONFIG_DIR="$ROOT_DIR/${CONFIG_DIR_RAW#./}"
fi

if [[ "$WORKSPACE_DIR_RAW" = /* ]]; then
  WORKSPACE_DIR="$WORKSPACE_DIR_RAW"
else
  WORKSPACE_DIR="$ROOT_DIR/${WORKSPACE_DIR_RAW#./}"
fi

echo "==> 准备数据目录"
mkdir -p "$CONFIG_DIR" "$WORKSPACE_DIR"

# 面板部署常用：确保挂载目录归属为容器内 node 用户（uid/gid 1000）
chown -R 1000:1000 "$ROOT_DIR/data" 2>/dev/null || true

echo "==> 执行 onboard 初始化"
"${COMPOSE_CMD[@]}" run --rm openclaw \
  node dist/index.js onboard --mode local --no-install-daemon

echo "==> 初始化 gateway.mode / gateway.bind"
"${COMPOSE_CMD[@]}" run --rm openclaw \
  node dist/index.js config set gateway.mode local
"${COMPOSE_CMD[@]}" run --rm openclaw \
  node dist/index.js config set gateway.bind "$BIND"

# 如果是从 Sandbox 目录部署 (含 docker.sock 挂载)，自动应用 Sandbox 最佳安全配置
if grep -q "DOCKER_SOCK_PATH" "$COMPOSE_FILE"; then
  echo "==> 检测到 Sandbox 模式，初始化 Sandbox 极简安全配置"
  "${COMPOSE_CMD[@]}" run --rm openclaw \
    node dist/index.js config set agents.defaults.sandbox.mode "non-main"
  "${COMPOSE_CMD[@]}" run --rm openclaw \
    node dist/index.js config set agents.defaults.sandbox.scope "agent"
  "${COMPOSE_CMD[@]}" run --rm openclaw \
    node dist/index.js config set agents.defaults.sandbox.workspaceAccess "none"
fi

echo "==> 初始化完成"
