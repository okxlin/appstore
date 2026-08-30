#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
TEMPLATE_DIR="${ROOT_DIR}/site-template"

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

[[ -d "$TEMPLATE_DIR" ]] || fail "Starter template directory not found: ${TEMPLATE_DIR}"

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

  if [[ -e "$DATA_DIR_ABS" ]]; then
    [[ -d "$DATA_DIR_ABS" ]] || fail "APP_DATA_DIR must be a directory"
    [[ "$(stat -c '%u:%g' "$DATA_DIR_ABS")" == "1000:1000" ]] || \
      fail "Existing absolute APP_DATA_DIR must be owned by UID/GID 1000:1000"
  else
    install -d -m 0750 -- "$DATA_DIR_ABS"
    if [[ "$(id -u)" -eq 0 ]]; then
      chown 1000:1000 -- "$DATA_DIR_ABS"
    fi
  fi
else
  DATA_DIR_PATH="${ROOT_DIR}/${DATA_DIR_RAW#./}"
  [[ ! -L "$DATA_DIR_PATH" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_PATH")"
  case "$DATA_DIR_ABS" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_DATA_DIR must remain inside the application version directory" ;;
  esac
  if [[ -e "$DATA_DIR_ABS" && ! -d "$DATA_DIR_ABS" ]]; then
    fail "APP_DATA_DIR must be a directory"
  fi
  install -d -m 0750 -- "$DATA_DIR_ABS"
  if [[ "$(id -u)" -eq 0 ]]; then
    chown 1000:1000 -- "$DATA_DIR_ABS"
  fi
fi

[[ "$(stat -c '%u:%g' "$DATA_DIR_ABS")" == "1000:1000" ]] || \
  fail "APP_DATA_DIR must be owned by UID/GID 1000:1000"

for source_file in "${TEMPLATE_DIR}"/*.sql; do
  target_file="${DATA_DIR_ABS}/${source_file##*/}"
  [[ ! -L "$target_file" ]] || fail "Starter target must not be a symbolic link: ${target_file}"
  if [[ -e "$target_file" ]]; then
    [[ -f "$target_file" ]] || fail "Starter target must be a regular file: ${target_file}"
    continue
  fi
  install -m 0644 -- "$source_file" "$target_file"
  if [[ "$(id -u)" -eq 0 ]]; then
    chown 1000:1000 -- "$target_file"
  fi
done
