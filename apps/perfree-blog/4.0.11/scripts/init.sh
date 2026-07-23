#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

read_env_value() {
  local key="$1"
  local value
  [[ -f "${ENV_FILE}" && ! -L "${ENV_FILE}" ]] || return 0
  value="$(sed -n "s/^${key}=//p" "${ENV_FILE}" | tail -n 1)"
  case "${value}" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "${value}"
}

DATA_DIR="${DATA_PATH:-$(read_env_value DATA_PATH)}"
DATA_DIR="${DATA_DIR:-./data}"
if [[ "${DATA_DIR}" != /* ]]; then
  DATA_DIR="${ROOT_DIR}/${DATA_DIR#./}"
fi
[[ "${DATA_DIR}" != / ]] || exit 1
mkdir -p -- "${DATA_DIR}"
