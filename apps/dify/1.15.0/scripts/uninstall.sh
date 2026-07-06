#!/bin/bash
set -euo pipefail

if docker compose version >/dev/null 2>&1; then
  docker compose down --volumes
else
  docker-compose down --volumes
fi
