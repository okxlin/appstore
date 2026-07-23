#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

get_env_value() {
  local key="$1"
  local default="$2"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1 || true)"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
  fi

  if [[ -n "$value" ]]; then
    printf '%s\n' "$value"
  else
    printf '%s\n' "$default"
  fi
}

resolve_app_path() {
  local raw="$1"
  if [[ "$raw" = /* ]]; then
    printf '%s\n' "$raw"
  else
    printf '%s\n' "${ROOT_DIR}/${raw#./}"
  fi
}

restore_previous_release() {
  if command -v docker-compose >/dev/null 2>&1; then
    (cd "$ROOT_DIR" && docker-compose up -d)
  elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    (cd "$ROOT_DIR" && docker compose up -d)
  else
    printf '%s\n' "Unable to restore the previous release because Docker Compose is unavailable." >&2
    return 1
  fi
}

refuse_direct_upgrade() {
  local reason="$1"
  printf '%s\n' "$reason" >&2
  if restore_previous_release; then
    printf '%s\n' "The previous Next Terminal release was restored. Install 3.5.2 separately and migrate the database manually." >&2
  else
    printf '%s\n' "Previous-release restoration failed; start the existing compose manually before retrying." >&2
  fi
  return 1
}

DATA_DIR="$(resolve_app_path "$(get_env_value DATA_PATH ./data)")"
DB_HOST="$(get_env_value PANEL_DB_HOST '')"

if [[ -d "${DATA_DIR}/postgresql" ]]; then
  refuse_direct_upgrade "Direct upgrade from the bundled-PostgreSQL layout is not supported."
fi

if [[ -z "$DB_HOST" ]]; then
  refuse_direct_upgrade "PANEL_DB_HOST is missing; select a PostgreSQL service on a fresh 3.5.2 installation."
fi

if ! bash "${SCRIPT_DIR}/init.sh"; then
  refuse_direct_upgrade "Next Terminal upgrade preflight failed without changing the existing configuration."
fi

echo "Next Terminal external PostgreSQL upgrade preflight completed."
