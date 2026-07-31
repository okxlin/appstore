#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

if [[ ! -f "${ENV_FILE}" || -L "${ENV_FILE}" ]]; then
  "${SCRIPT_DIR}/init.sh"
  exit 0
fi

read_env_value() {
  local key="$1"
  local value
  value="$(sed -n "s/^${key}=//p" "${ENV_FILE}" | tail -n 1)"
  case "${value}" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "${value}"
}

append_if_missing() {
  local key="$1"
  local value="$2"
  if ! grep -qE "^${key}=" "${ENV_FILE}"; then
    printf '%s=%s\n' "${key}" "${value}" >> "${ENV_FILE}"
  fi
}

append_db_password_from_root() {
  if grep -qE '^SEATABLE_MYSQL_DB_PASSWORD=' "${ENV_FILE}"; then
    return 0
  fi
  local root_value
  root_value="$(sed -n 's/^PANEL_DB_ROOT_PASSWORD=//p' "${ENV_FILE}" | tail -n 1)"
  if [[ -z "${root_value}" ]]; then
    echo "PANEL_DB_ROOT_PASSWORD is required to preserve the legacy SeaTable database connection" >&2
    return 1
  fi
  printf 'SEATABLE_MYSQL_DB_PASSWORD=%s\n' "${root_value}" >> "${ENV_FILE}"
}

append_if_missing SEATABLE_MYSQL_DB_DTABLE_DB_NAME dtable_db
append_if_missing SEATABLE_MYSQL_DB_CCNET_DB_NAME ccnet_db
append_if_missing SEATABLE_MYSQL_DB_SEAFILE_DB_NAME seafile_db
append_if_missing SEATABLE_MYSQL_DB_USER root
append_db_password_from_root

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

if ! grep -qE '^PANEL_DB_PORT=' "${ENV_FILE}"; then
  legacy_db_port="$(read_env_value SEAFILE_DB_PORT)"
  append_if_missing PANEL_DB_PORT "${legacy_db_port:-3306}"
fi
if ! grep -qE '^JWT_PRIVATE_KEY=' "${ENV_FILE}"; then
  append_if_missing JWT_PRIVATE_KEY "$(generate_secret)"
fi
