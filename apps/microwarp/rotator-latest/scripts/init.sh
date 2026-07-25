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
