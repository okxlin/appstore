#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
APP_ROOT="${APP_ROOT:-$(CDPATH="" cd -- "${SCRIPT_DIR}/.." && pwd -P)}"
ENV_FILE="${ENV_FILE:-${APP_ROOT}/.env}"

if [[ "${ENV_FILE}" != /* ]]; then
  ENV_FILE="${APP_ROOT}/${ENV_FILE#./}"
fi

strip_matching_quotes() {
  local value="$1"

  case "${value}" in
    \"*\")
      value="${value#\"}"
      value="${value%\"}"
      ;;
    \'*\')
      value="${value#\'}"
      value="${value%\'}"
      ;;
  esac
  printf '%s\n' "${value}"
}

ensure_allow_no_auth() {
  local current temp_file

  current="${ALLOW_NO_AUTH:-}"
  if [[ -z "${current}" && -f "${ENV_FILE}" ]]; then
    current="$(sed -n 's/^ALLOW_NO_AUTH=//p' "${ENV_FILE}" | tail -n 1)"
    current="$(strip_matching_quotes "${current}")"
  fi
  [[ -n "${current}" || ! -f "${ENV_FILE}" ]] && return 0

  temp_file="$(mktemp "${ENV_FILE}.upgrade.XXXXXX")"
  awk '
    BEGIN { updated = 0 }
    /^ALLOW_NO_AUTH=/ {
      if (!updated) {
        print "ALLOW_NO_AUTH=1"
        updated = 1
      }
      next
    }
    { print }
    END { if (!updated) print "ALLOW_NO_AUTH=1" }
  ' "${ENV_FILE}" >"${temp_file}"
  chmod --reference="${ENV_FILE}" "${temp_file}" 2>/dev/null || chmod 0600 "${temp_file}"
  mv -f -- "${temp_file}" "${ENV_FILE}"
}

ensure_allow_no_auth

app_data_dir="${APP_DATA_DIR_1:-}"
if [[ -z "${app_data_dir}" && -f "${ENV_FILE}" ]]; then
  app_data_dir="$(sed -n 's/^APP_DATA_DIR_1=//p' "${ENV_FILE}" | tail -n 1)"
fi
app_data_dir="$(strip_matching_quotes "${app_data_dir}")"
app_data_dir="${app_data_dir:-./data}"
if [[ "${app_data_dir}" != /* ]]; then
  app_data_dir="${APP_ROOT}/${app_data_dir#./}"
fi

mkdir -p "${app_data_dir}"
exit 0
