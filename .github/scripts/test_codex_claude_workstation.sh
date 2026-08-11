#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_DIR="$(cd -- "${SCRIPT_DIR}/../.." && pwd -P)"
APP_DIR="${REPO_DIR}/apps/codex-claude-workstation/latest"
COMPOSE_FILE="${APP_DIR}/docker-compose.yml"
DATA_FILE="${APP_DIR}/data.yml"
ENV_SAMPLE="${APP_DIR}/.env.sample"
UPGRADE_SCRIPT="${APP_DIR}/scripts/upgrade.sh"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

require_text() {
  local file="$1"
  local text="$2"
  grep -Fq -- "$text" "$file" || fail "${file} is missing: ${text}"
}

reject_text() {
  local file="$1"
  local text="$2"
  if grep -Fq -- "$text" "$file"; then
    fail "${file} unexpectedly contains: ${text}"
  fi
}

# These are exact Compose source contracts, not shell expressions to expand.
# shellcheck disable=SC2016
require_text "${COMPOSE_FILE}" '"${PASEO_BIND_IP:-127.0.0.1}:${PANEL_APP_PORT_PASEO:-6767}:6767"'
# shellcheck disable=SC2016
require_text "${COMPOSE_FILE}" '${DOCKER_SOCK_SRC:-/dev/null}:/var/run/docker.sock'
require_text "${COMPOSE_FILE}" 'seccomp=unconfined'
require_text "${COMPOSE_FILE}" 'apparmor=unconfined'
reject_text "${COMPOSE_FILE}" '6768'

require_text "${DATA_FILE}" 'envKey: PANEL_APP_PORT_PASEO'
require_text "${DATA_FILE}" 'rule: paramPort'
require_text "${DATA_FILE}" 'envKey: PASEO_BIND_IP'
require_text "${DATA_FILE}" 'default: 127.0.0.1'
require_text "${ENV_SAMPLE}" 'PASEO_BIND_IP=127.0.0.1'
require_text "${UPGRADE_SCRIPT}" 'ensure_env_default "PASEO_BIND_IP" "127.0.0.1"'

TMP_ROOT="$(mktemp -d)"
trap 'rm -rf -- "${TMP_ROOT}"' EXIT

prepare_case() {
  local name="$1"
  local bind_line="${2-}"
  local root="${TMP_ROOT}/${name}/latest"

  mkdir -p -- "${root}/scripts"
  cp -- "${UPGRADE_SCRIPT}" "${root}/scripts/upgrade.sh"
  chmod 0755 -- "${root}/scripts/upgrade.sh"
  {
    printf '%s\n' \
      'PANEL_APP_PORT_HTTP=8080' \
      'PANEL_APP_PORT_PASEO=7777' \
      'CODE_SERVER_PASSWORD=legacy-password' \
      'PASEO_PASSWORD=' \
      'CUSTOM_ENV_FILE=./data/custom.env'
    if [[ -n "${bind_line}" ]]; then
      printf '%s\n' "${bind_line}"
    fi
  } > "${root}/.env"
  chmod 0644 -- "${root}/.env"
  printf '%s\n' "${root}"
}

missing_root="$(prepare_case missing)"
bash "${missing_root}/scripts/upgrade.sh" >/dev/null
bash "${missing_root}/scripts/upgrade.sh" >/dev/null

[[ "$(grep -c '^PASEO_BIND_IP=' "${missing_root}/.env")" == 1 ]] || \
  fail 'missing PASEO_BIND_IP was not added exactly once'
require_text "${missing_root}/.env" 'PASEO_BIND_IP=127.0.0.1'
require_text "${missing_root}/.env" 'PANEL_APP_PORT_PASEO=7777'
[[ "$(stat -c '%a' "${missing_root}/.env")" == 600 ]] || fail '.env mode is not 0600'
[[ "$(stat -c '%a' "${missing_root}/data/custom.env")" == 600 ]] || \
  fail 'custom.env mode is not 0600'

custom_root="$(prepare_case custom 'PASEO_BIND_IP=0.0.0.0')"
bash "${custom_root}/scripts/upgrade.sh" >/dev/null
bash "${custom_root}/scripts/upgrade.sh" >/dev/null

[[ "$(grep -c '^PASEO_BIND_IP=' "${custom_root}/.env")" == 1 ]] || \
  fail 'custom PASEO_BIND_IP was duplicated'
require_text "${custom_root}/.env" 'PASEO_BIND_IP=0.0.0.0'
require_text "${custom_root}/.env" 'PANEL_APP_PORT_PASEO=7777'
if grep -Fq 'PASEO_BIND_IP=127.0.0.1' "${custom_root}/.env"; then
  fail 'custom PASEO_BIND_IP was overwritten with the default'
fi

invalid_root="$(prepare_case invalid 'PASEO_BIND_IP=127.0.0.1:9999')"
if bash "${invalid_root}/scripts/upgrade.sh" >/dev/null 2>&1; then
  fail 'invalid PASEO_BIND_IP was accepted'
fi
require_text "${invalid_root}/.env" 'PANEL_APP_PORT_PASEO=7777'

printf 'Codex Claude Workstation app contract passed.\n'
