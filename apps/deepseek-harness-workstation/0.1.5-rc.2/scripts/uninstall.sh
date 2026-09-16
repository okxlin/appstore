#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT_DIR"
if docker compose version >/dev/null 2>&1; then
  docker compose down --remove-orphans
elif docker-compose version >/dev/null 2>&1; then
  docker-compose down --remove-orphans
else
  echo "Docker Compose is not available" >&2
  exit 1
fi

echo "Compose resources were removed. Persistent ./data/data, ./data/workspace, and dsh-home are preserved."
