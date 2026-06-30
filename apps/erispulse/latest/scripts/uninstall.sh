#!/usr/bin/env bash
if [ -n "${BASH_VERSION:-}" ]; then
    set -euo pipefail
else
    set -eu
fi

if docker compose version >/dev/null 2>&1; then
    docker compose down --volumes
elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose down --volumes
else
    echo "[ErisPulse] Docker Compose is not available. Manual cleanup may be required." >&2
    exit 1
fi
