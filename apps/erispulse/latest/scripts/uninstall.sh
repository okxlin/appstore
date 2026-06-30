#!/usr/bin/env bash
if [ -n "${BASH_VERSION:-}" ]; then
    set -euo pipefail
else
    set -eu
fi
docker compose down --volumes 2>/dev/null || echo "[ErisPulse] Failed to clean up containers/volumes. Manual check may be required."
