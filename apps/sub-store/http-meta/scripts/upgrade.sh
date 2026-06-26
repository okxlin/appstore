#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

get_env_value() {
  local key="$1"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1 || true)"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
  fi

  printf '%s\n' "$value"
}

if [[ -f "$ENV_FILE" ]] && ! grep -q '^SUB_STORE_BACKEND_SYNC_CRON=' "$ENV_FILE"; then
  legacy_cron="$(get_env_value SUB_STORE_CRON)"
  if [[ -z "$legacy_cron" ]]; then
    legacy_cron="$(get_env_value SUB_STORE_BACKEND_CRON)"
  fi
  if [[ -n "$legacy_cron" ]]; then
    printf '\nSUB_STORE_BACKEND_SYNC_CRON="%s"\n' "$legacy_cron" >> "$ENV_FILE"
    echo "Migrated legacy Sub-Store cron to SUB_STORE_BACKEND_SYNC_CRON."
  fi
fi

echo "Sub-Store upgrade preflight completed."
