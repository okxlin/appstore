#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

if [[ -L "${ENV_FILE}" ]]; then
  echo "Refusing to migrate a symlinked .env file" >&2
  exit 1
fi
if [[ ! -f "${ENV_FILE}" ]]; then
  echo "${ENV_FILE} not found; skipped VNC port migration"
  exit 0
fi

get_env_value() {
  local key="$1"
  local value
  value="$(awk -v prefix="${key}=" 'index($0, prefix) == 1 { value = substr($0, length(prefix) + 1) } END { if (value != "") print value }' "${ENV_FILE}")"
  if [[ ${#value} -ge 2 ]]; then
    if [[ "${value:0:1}" == '"' && "${value: -1}" == '"' ]] || [[ "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
      value="${value:1:${#value}-2}"
    fi
  fi
  printf '%s\n' "${value}"
}

valid_port() {
  local value="$1"
  [[ "${value}" =~ ^[0-9]{1,5}$ ]] && (( 10#${value} >= 1 && 10#${value} <= 65535 ))
}

marker="$(get_env_value VNC_PORT_MIGRATION_COMPLETE)"
if [[ "${marker}" == "1" ]]; then
  echo "VNC port migration already completed"
  exit 0
fi

legacy_port="$(get_env_value VNC_PORT)"
panel_port="$(get_env_value PANEL_APP_PORT_VNC)"
if [[ -n "${legacy_port}" ]] && ! valid_port "${legacy_port}"; then
  echo "VNC_PORT must be a valid port before upgrade" >&2
  exit 1
fi
if [[ -n "${panel_port}" ]] && ! valid_port "${panel_port}"; then
  echo "PANEL_APP_PORT_VNC must be a valid port before upgrade" >&2
  exit 1
fi

if [[ -z "${panel_port}" ]]; then
  if [[ -z "${legacy_port}" ]]; then
    echo "Neither legacy nor current VNC port is configured; skipped migration"
    exit 0
  fi
  panel_port="${legacy_port}"
elif [[ "${panel_port}" == "40328" && -n "${legacy_port}" && "${legacy_port}" != "40328" ]]; then
  # If the panel supplied the new field's default during upgrade, preserve the
  # existing installation's custom public VNC port once.
  panel_port="${legacy_port}"
fi

tmp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
cleanup() {
  [[ ! -f "${tmp_file}" ]] || rm -f -- "${tmp_file}"
}
trap cleanup EXIT

awk -v panel_port="${panel_port}" -v marker_key="VNC_PORT_MIGRATION_COMPLETE" '
  BEGIN { panel_written = 0; marker_written = 0 }
  /^PANEL_APP_PORT_VNC=/ {
    if (!panel_written) print "PANEL_APP_PORT_VNC=" panel_port
    panel_written = 1
    next
  }
  /^VNC_PORT_MIGRATION_COMPLETE=/ {
    if (!marker_written) print marker_key "=1"
    marker_written = 1
    next
  }
  { print }
  END {
    if (!panel_written) print "PANEL_APP_PORT_VNC=" panel_port
    if (!marker_written) print marker_key "=1"
  }
' "${ENV_FILE}" > "${tmp_file}"
chmod --reference="${ENV_FILE}" -- "${tmp_file}"
chown --reference="${ENV_FILE}" -- "${tmp_file}" 2>/dev/null || true
mv -- "${tmp_file}" "${ENV_FILE}"
trap - EXIT

echo "Preserved the VNC port and recorded the migration"
