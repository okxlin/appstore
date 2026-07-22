#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "$ENV_FILE not found; skipped Immich environment migration"
  exit 0
fi

if grep -qE '^DB_STORAGE_TYPE=' "$ENV_FILE"; then
  echo "DB_STORAGE_TYPE already exists"
else
  printf '%s\n' 'DB_STORAGE_TYPE=SSD' >> "$ENV_FILE"
  echo "Added DB_STORAGE_TYPE"
fi
