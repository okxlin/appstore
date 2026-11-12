#!/usr/bin/env bash
set -euo pipefail

if command -v docker-compose >/dev/null 2>&1; then
  docker-compose down --volumes
else
  docker compose down --volumes
fi
