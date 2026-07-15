#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env() {
  local value

  value="$(sed -n "s/^${1}=//p" "${ENV_FILE}" | tail -n 1)"
  if [[ ${#value} -ge 2 && "${value:0:1}" == "${value: -1}" && "${value:0:1}" =~ [\"\'] ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "${value}"
}

restore_legacy_key() {
  local key="$1" cache_file="$2"
  local value temp_file

  [[ -e "${cache_file}" || -L "${cache_file}" ]] || return 0
  [[ -s "${cache_file}" && -f "${cache_file}" && ! -L "${cache_file}" ]] \
    || fail "${cache_file} must be a non-empty regular file"
  value="$(<"${cache_file}")"
  [[ ${#value} -ge 35 && ${#value} -le 100 && "${value}" =~ ^sk-[A-Za-z0-9_-]+$ ]] \
    || fail "${cache_file} contains an invalid legacy key"

  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  awk -v key="${key}" -v value="${value}" '
    BEGIN { written = 0 }
    $0 ~ "^" key "=" {
      if (!written) { print key "=" value; written = 1 }
      next
    }
    { print }
    END { if (!written) print key "=" value }
  ' "${ENV_FILE}" >"${temp_file}"
  chmod --reference="${ENV_FILE}" "${temp_file}"
  mv -f -- "${temp_file}" "${ENV_FILE}"
}

[[ -f "${ENV_FILE}" && ! -L "${ENV_FILE}" ]] || fail "${ENV_FILE} must be a regular file"
DATA_DIR="$(read_env APP_DATA_DIR)"
DATA_DIR="${DATA_DIR:-./data}"
case "${DATA_DIR}" in
  /*) DATA_DIR="$(realpath -m -- "${DATA_DIR}")" ;;
  *)
    DATA_DIR="$(realpath -m -- "${ROOT_DIR}/${DATA_DIR#./}")"
    [[ "${DATA_DIR}" == "${ROOT_DIR}" || "${DATA_DIR}" == "${ROOT_DIR}/"* ]] \
      || fail "Relative APP_DATA_DIR must stay inside the application directory"
    ;;
esac
[[ "${DATA_DIR}" != / ]] || fail "APP_DATA_DIR must not be the filesystem root"
[[ -d "${DATA_DIR}" ]] || exit 0

restore_legacy_key LITELLM_MASTER_KEY "${DATA_DIR}/.litellm-master-key"
restore_legacy_key LITELLM_SALT_KEY "${DATA_DIR}/.litellm-salt-key"
