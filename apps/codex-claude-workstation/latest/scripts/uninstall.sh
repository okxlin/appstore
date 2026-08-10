#!/bin/bash
# uninstall.sh — codex-claude-workstation cleanup
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
cd "$ROOT_DIR"

if docker compose version >/dev/null 2>&1; then
  docker compose down
elif docker-compose version >/dev/null 2>&1; then
  docker-compose down
else
  echo "Docker Compose is not available" >&2
  exit 1
fi

echo "Persistent bind data and the codex-home volume were preserved."
