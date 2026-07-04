#!/usr/bin/env bash
set -euo pipefail

DATA_PATH="${DATA_PATH:-./data/data}"
SHARED_PATH="${SHARED_PATH:-./data/shared}"
SHARED_TARGET="${SHARED_TARGET:-/vol/shared}"

if [[ "$SHARED_TARGET" != /vol/* ]]; then
  echo "SHARED_TARGET must start with /vol/ so the mount is visible inside the LXC container."
  exit 1
fi

mkdir -p "$DATA_PATH" "$SHARED_PATH"
