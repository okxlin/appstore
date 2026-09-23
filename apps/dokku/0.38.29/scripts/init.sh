#!/usr/bin/env bash
set -euo pipefail

DOKKU_DATA_DIR=/var/lib/dokku

if [[ -L "$DOKKU_DATA_DIR" ]]; then
  echo "Refusing to use symbolic link as Dokku data directory: $DOKKU_DATA_DIR" >&2
  exit 1
fi

mkdir -p -- "$DOKKU_DATA_DIR"
