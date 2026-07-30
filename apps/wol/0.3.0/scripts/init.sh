#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
CONFIG_TEMPLATE="${ROOT_DIR}/config-template/config.yaml"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

strip_matching_quotes() {
  local value="$1"

  if [[ ${#value} -ge 2 ]]; then
    if [[ "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
      value="${value:1:${#value}-2}"
    elif [[ "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
      value="${value:1:${#value}-2}"
    fi
  fi
  printf '%s\n' "$value"
}

read_env_value() {
  local key="$1"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi
  value="${value%$'\r'}"
  strip_matching_quotes "$value"
}

path_is_dotenv_safe() {
  local value="$1"

  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) return 1 ;;
    *) return 0 ;;
  esac
}

[[ -f "$CONFIG_TEMPLATE" ]] || fail "Configuration template not found: ${CONFIG_TEMPLATE}"

if [[ ${APP_DATA_DIR+x} ]]; then
  DATA_DIR_RAW="$APP_DATA_DIR"
else
  DATA_DIR_RAW="$(read_env_value APP_DATA_DIR)"
fi
DATA_DIR_RAW="$(strip_matching_quotes "${DATA_DIR_RAW:-./data}")"

[[ -n "$DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be empty"
path_is_dotenv_safe "$DATA_DIR_RAW" || fail "APP_DATA_DIR contains unsupported dotenv characters"

if [[ "$DATA_DIR_RAW" = /* ]]; then
  [[ ! -L "$DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_RAW")"
  [[ "$DATA_DIR_ABS" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
else
  DATA_DIR_PATH="${ROOT_DIR}/${DATA_DIR_RAW#./}"
  [[ ! -L "$DATA_DIR_PATH" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_PATH")"
  case "$DATA_DIR_ABS" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_DATA_DIR must remain inside the application version directory" ;;
  esac
fi

if [[ -e "$DATA_DIR_ABS" ]]; then
  [[ -d "$DATA_DIR_ABS" ]] || fail "APP_DATA_DIR must be a directory"
else
  install -d -m 0755 -- "$DATA_DIR_ABS"
fi

CONFIG_FILE="${DATA_DIR_ABS}/config.yaml"
[[ ! -L "$CONFIG_FILE" ]] || fail "Configuration target must not be a symbolic link: ${CONFIG_FILE}"
if [[ -e "$CONFIG_FILE" ]]; then
  [[ -f "$CONFIG_FILE" ]] || fail "Configuration target must be a regular file: ${CONFIG_FILE}"
else
  install -m 0644 -- "$CONFIG_TEMPLATE" "$CONFIG_FILE"
fi
