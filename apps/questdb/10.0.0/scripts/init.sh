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

write_env() {
  local key="$1" value="$2" line temp_file
  local found=false

  case "${value}" in
    *$'\n'* | *$'\r'* | *"'"*) fail "${key} contains unsupported dotenv characters" ;;
  esac
  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  while IFS= read -r line || [[ -n "${line}" ]]; do
    if [[ "${line}" == "${key}="* ]]; then
      if [[ "${found}" == false ]]; then
        printf "%s='%s'\n" "${key}" "${value}" >>"${temp_file}"
        found=true
      fi
    else
      printf '%s\n' "${line}" >>"${temp_file}"
    fi
  done <"${ENV_FILE}"
  [[ "${found}" == true ]] || printf "%s='%s'\n" "${key}" "${value}" >>"${temp_file}"
  chmod --reference="${ENV_FILE}" "${temp_file}"
  mv -f -- "${temp_file}" "${ENV_FILE}"
}

sync_secret() {
  local key="$1" cache_file="$2"
  local current final temp_file

  current="$(read_env "${key}")"
  if [[ -e "${cache_file}" || -L "${cache_file}" ]]; then
    [[ -f "${cache_file}" && ! -L "${cache_file}" ]] || fail "${cache_file} must be a regular file"
  fi
  if [[ -s "${cache_file}" ]]; then
    final="$(<"${cache_file}")"
    chmod 600 -- "${cache_file}"
  else
    [[ -n "${current}" && "${current}" != generate ]] || fail "${key} is missing"
    final="${current}"
    temp_file="$(mktemp "${cache_file}.tmp.XXXXXX")"
    (umask 077; printf '%s\n' "${final}" >"${temp_file}")
    mv -f -- "${temp_file}" "${cache_file}"
  fi
  [[ "${current}" == "${final}" ]] || write_env "${key}" "${final}"
}

[[ -f "${ENV_FILE}" && ! -L "${ENV_FILE}" ]] || fail "${ENV_FILE} must be a regular file"
DATA_DIR="${APP_DATA_DIR:-$(read_env APP_DATA_DIR)}"
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
[[ ! -e "${DATA_DIR}" || -d "${DATA_DIR}" ]] || fail "APP_DATA_DIR must be a directory"
mkdir -p -- "${DATA_DIR}"

sync_secret QUESTDB_HTTP_PASSWORD "${DATA_DIR}/.questdb_http_password"
sync_secret QUESTDB_PG_PASSWORD "${DATA_DIR}/.questdb_pg_password"
