#!/bin/bash
# upgrade.sh — codex-claude-workstation 1Panel upgrade helper
set -eo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

ensure_env_default() {
  local key="$1"
  local value="$2"

  if grep -qE "^${key}=" "$ENV_FILE"; then
    echo "${key} already exists"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added ${key}=${value}"
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_default "FIX_WORKSPACE_OWNERSHIP_RECURSIVE" "false"
else
  echo "${ENV_FILE} not found; skipped environment migration"
fi

echo "Codex Claude Workstation upgrade migration completed."
