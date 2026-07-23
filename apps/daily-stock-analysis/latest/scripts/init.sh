#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ROOT_DIR}/.env"

read_env() {
  local value
  value="$(sed -n "s/^${1}=//p" "${ENV_FILE}" | tail -n 1)"
  case "${value}" in
    \"*\"|\'*\') value="${value:1:${#value}-2}" ;;
  esac
  printf '%s\n' "${value}"
}

[[ -f "${ENV_FILE}" && ! -L "${ENV_FILE}" ]] || exit 0
DATA_DIR="$(read_env APP_DATA_DIR)"
DATA_DIR="${DATA_DIR:-./data}"
case "${DATA_DIR}" in
  /*) DATA_DIR="$(realpath -m -- "${DATA_DIR}")" ;;
  *)
    DATA_DIR="$(realpath -m -- "${ROOT_DIR}/${DATA_DIR#./}")"
    [[ "${DATA_DIR}" == "${ROOT_DIR}" || "${DATA_DIR}" == "${ROOT_DIR}/"* ]] || exit 1
    ;;
esac
[[ "${DATA_DIR}" != / ]] || exit 1
mkdir -p "${DATA_DIR}"

if [[ ! -e "${DATA_DIR}/.env" ]]; then
  cp -- "${ROOT_DIR}/env.defaults" "${DATA_DIR}/.env"
fi
chown 1000:1000 "${DATA_DIR}/.env" 2>/dev/null || true
chmod u+rw "${DATA_DIR}/.env"
