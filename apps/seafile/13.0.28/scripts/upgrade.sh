#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

if [[ ! -f "${ENV_FILE}" || -L "${ENV_FILE}" ]]; then
  "${SCRIPT_DIR}/init.sh"
  exit 0
fi

append_if_missing() {
  local key="$1"
  local value="$2"
  if ! grep -qE "^${key}=" "${ENV_FILE}"; then
    printf '%s=%s\n' "${key}" "${value}" >> "${ENV_FILE}"
  fi
}

append_if_missing SEAFILE_MYSQL_DB_CCNET_DB_NAME ccnet_db
append_if_missing SEAFILE_MYSQL_DB_SEAFILE_DB_NAME seafile_db
append_if_missing SEAFILE_MYSQL_DB_SEAHUB_DB_NAME seahub_db

"${SCRIPT_DIR}/init.sh"

generate_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
  elif command -v od >/dev/null 2>&1; then
    od -An -N32 -tx1 /dev/urandom | tr -d ' \n'
  else
    echo "openssl or od is required to generate JWT_PRIVATE_KEY" >&2
    return 1
  fi
}

append_if_missing PANEL_DB_PORT 3306
append_if_missing CACHE_PROVIDER memcached
append_if_missing MEMCACHED_PORT 11211
if ! grep -qE '^JWT_PRIVATE_KEY=' "${ENV_FILE}"; then
  append_if_missing JWT_PRIVATE_KEY "$(generate_secret)"
fi
