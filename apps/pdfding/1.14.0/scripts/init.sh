#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

umask 027
mkdir -p -- "$ROOT_DIR/data/db" "$ROOT_DIR/data/media"
chown 1000:1000 -- "$ROOT_DIR/data/db" "$ROOT_DIR/data/media" 2>/dev/null || true
chmod 0750 -- "$ROOT_DIR/data/db" "$ROOT_DIR/data/media"
