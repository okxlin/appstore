#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

migrate_db_port() {
  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped PANEL_DB_PORT migration"
    return
  fi

  if grep -qE '^PANEL_DB_PORT=' "$ENV_FILE"; then
    echo "PANEL_DB_PORT already exists"
    return
  fi

  if grep -qE '^DB_PORT=' "$ENV_FILE"; then
    local current
    current="$(sed -n -E 's/^DB_PORT=//p' "$ENV_FILE" | tail -n 1)"
    printf 'PANEL_DB_PORT=%s\n' "$current" >> "$ENV_FILE"
    echo "Added PANEL_DB_PORT from legacy DB_PORT"
    return
  fi

  printf 'PANEL_DB_PORT=3306\n' >> "$ENV_FILE"
  echo "Added default PANEL_DB_PORT"
}

migrate_db_port

echo "Jianmu is currently pinned to the verified official image line ui/server v2.8.2 and worker v1.0.13."
echo "Automatic in-place app upgrades are intentionally disabled for this package."
echo "Back up APP_DATA_DIR, the external MySQL database, and the configured Jianmu secrets before changing packaged versions or rotating credentials."
exit 0
