#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
APP_ROOT="${APP_ROOT:-$(CDPATH="" cd -- "${SCRIPT_DIR}/.." && pwd -P)}"
ENV_FILE="${ENV_FILE:-${APP_ROOT}/.env}"
TARGET_VERSION_DIR="0.1.3-rotator-http"

if [[ "${ENV_FILE}" != /* ]]; then
  ENV_FILE="${APP_ROOT}/${ENV_FILE#./}"
fi

resource_dir_for_app() {
  local panel_root app_path app_key

  case "${APP_ROOT}" in
    */apps/local/*)
      panel_root="${APP_ROOT%%/apps/local/*}"
      app_path="${APP_ROOT#"${panel_root}/apps/local/"}"
      app_key="${app_path%%/*}"
      [[ -n "${panel_root}" && -n "${app_key}" ]] || return 1
      printf '%s/resource/apps/local/%s\n' "${panel_root}" "${app_key}"
      ;;
    *)
      return 1
      ;;
  esac
}

find_rotate_source() {
  local resource_dir candidate_upgrade candidate_rotate

  if [[ -n "${ROTATE_SOURCE:-}" ]]; then
    printf '%s\n' "${ROTATE_SOURCE}"
    return 0
  fi

  if resource_dir="$(resource_dir_for_app 2>/dev/null)" && [[ -d "${resource_dir}" ]]; then
    candidate_upgrade="${resource_dir}/${TARGET_VERSION_DIR}/scripts/upgrade.sh"
    candidate_rotate="${resource_dir}/${TARGET_VERSION_DIR}/rotate.sh"
    if [[ -f "${candidate_upgrade}" && -f "${candidate_rotate}" ]] \
      && cmp -s "${SCRIPT_DIR}/upgrade.sh" "${candidate_upgrade}" \
      && grep -q 'ROTATE_MAX_ATTEMPTS' "${candidate_rotate}"; then
      printf '%s\n' "${candidate_rotate}"
      return 0
    fi
  fi

  if [[ -f "${APP_ROOT}/rotate.sh" ]] \
    && grep -q 'ROTATE_MAX_ATTEMPTS' "${APP_ROOT}/rotate.sh"; then
    printf '%s\n' "${APP_ROOT}/rotate.sh"
    return 0
  fi

  return 1
}

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

rotate_target="${APP_ROOT}/rotate.sh"
rotate_source="$(find_rotate_source || true)"
if [[ -z "${rotate_source}" || ! -f "${rotate_source}" ]]; then
  echo "Unable to locate the upgraded rotate.sh payload; refusing to keep the old script" >&2
  exit 1
fi

if [[ "${rotate_source}" != "${rotate_target}" ]] \
  && ! cmp -s "${rotate_source}" "${rotate_target}"; then
  rotate_tmp="$(mktemp "${rotate_target}.upgrade.XXXXXX")"
  # shellcheck disable=SC2317
  cleanup_rotate_tmp() {
    rm -f -- "${rotate_tmp}"
  }
  trap cleanup_rotate_tmp EXIT

  cp -- "${rotate_source}" "${rotate_tmp}"
  if [[ -e "${rotate_target}" ]]; then
    chmod --reference="${rotate_target}" "${rotate_tmp}" 2>/dev/null || true
  else
    chmod 0644 "${rotate_tmp}"
  fi
  mv -f -- "${rotate_tmp}" "${rotate_target}"
  trap - EXIT
  echo "Updated ${rotate_target} from the target version payload"
fi

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
