#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "${ROOT_DIR}"

if command -v docker-compose >/dev/null 2>&1; then
  docker-compose down --remove-orphans
else
  docker compose down --remove-orphans
fi
