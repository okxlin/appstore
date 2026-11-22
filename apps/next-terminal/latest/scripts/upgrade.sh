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
  local container_name
  local container

  if ! command -v docker >/dev/null 2>&1; then
    printf '%s\n' "Docker CLI is unavailable; the existing Next Terminal containers could not be restarted." >&2
    return 1
  fi

  container_name="$(get_env_value CONTAINER_NAME next-terminal)"
  if ! docker inspect "$container_name" >/dev/null 2>&1; then
    printf '%s\n' "Existing Next Terminal container '$container_name' was not found." >&2
    return 1
  fi

  # The 1Panel upgrade hook runs after stopping old containers. Restart those
  # existing containers directly; do not run Compose from the target version.
  local database_container="${container_name}-postgresql"
  if docker inspect "$database_container" >/dev/null 2>&1; then
    if ! docker start "$database_container" >/dev/null; then
      printf 'Failed to restart existing container %s.\n' "$database_container" >&2
      return 1
    fi

    local db_user db_name attempt database_ready=0
    db_user="$(get_env_value PANEL_DB_USER next_terminal)"
    db_name="$(get_env_value PANEL_DB_NAME next_terminal)"
    for ((attempt=1; attempt<=30; attempt++)); do
      if docker exec "$database_container" pg_isready -U "$db_user" -d "$db_name" >/dev/null 2>&1; then
        database_ready=1
        break
      fi
      sleep 2
    done
    if [[ "$database_ready" -ne 1 ]]; then
      printf 'Existing PostgreSQL container %s did not become ready.\n' "$database_container" >&2
      return 1
    fi
  fi

  for container in "${container_name}-guacd" "$container_name"; do
    if docker inspect "$container" >/dev/null 2>&1; then
      if ! docker start "$container" >/dev/null; then
        printf 'Failed to restart existing container %s.\n' "$container" >&2
        return 1
      fi
    fi
  done
}

refuse_direct_upgrade() {
  local reason="$1"
  printf '%s\n' "$reason" >&2
  if restore_previous_release; then
    printf '%s\n' "Existing Next Terminal containers were restarted. Migrate the bundled PostgreSQL data to an external PostgreSQL service before retrying." >&2
  else
    printf '%s\n' "Previous containers could not be restored automatically; start the existing containers manually before retrying." >&2
  fi
  return 1
}
DATA_DIR="$(resolve_app_path "$(get_env_value DATA_PATH ./data)")"
DB_HOST="$(get_env_value PANEL_DB_HOST '')"

if [[ -d "${DATA_DIR}/postgresql" ]]; then
  refuse_direct_upgrade "Direct upgrade from the bundled-PostgreSQL layout is blocked to protect existing database files."
fi

if [[ -z "$DB_HOST" ]]; then
  refuse_direct_upgrade "PANEL_DB_HOST is missing; select a PostgreSQL service before upgrading to 3.10.3."
fi

if ! bash "${SCRIPT_DIR}/init.sh"; then
  refuse_direct_upgrade "Next Terminal upgrade preflight failed without changing the existing configuration."
fi

echo "Next Terminal external PostgreSQL upgrade preflight completed."
