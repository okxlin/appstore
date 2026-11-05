#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi
  if [[ ${#value} -ge 2 && "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
    value="${value:1:${#value}-2}"
  elif [[ ${#value} -ge 2 && "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "$value"
}

if [[ ${APP_DATA_DIR+x} ]]; then
  APP_DATA_DIR_RAW="$APP_DATA_DIR"
else
  APP_DATA_DIR_RAW="$(read_env_value APP_DATA_DIR)"
fi
APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW:-./data}"

[[ -n "$APP_DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be empty"
case "$APP_DATA_DIR_RAW" in
  *$'\n'* | *$'\r'* | *'$'* | *'#'*) fail "APP_DATA_DIR contains unsupported dotenv characters" ;;
esac

case "$APP_DATA_DIR_RAW" in
  /*) APP_DATA_DIR_ABS="$(realpath -m -- "$APP_DATA_DIR_RAW")" ;;
  *)
    APP_DATA_DIR_ABS="$(realpath -m -- "${ROOT_DIR}/${APP_DATA_DIR_RAW#./}")"
    case "$APP_DATA_DIR_ABS" in
      "$ROOT_DIR" | "$ROOT_DIR"/*) ;;
      *) fail "Relative APP_DATA_DIR must stay inside the application directory" ;;
    esac
    ;;
esac

[[ "$APP_DATA_DIR_ABS" != / ]] || fail "APP_DATA_DIR must not be the filesystem root"
[[ ! -L "$APP_DATA_DIR_ABS" ]] || fail "APP_DATA_DIR must not be a symbolic link"
if [[ -e "$APP_DATA_DIR_ABS" && ! -d "$APP_DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi

opencloud_paths=(
  "$APP_DATA_DIR_ABS/config"
  "$APP_DATA_DIR_ABS/storage"
  "$APP_DATA_DIR_ABS/apps"
)
traefik_paths=(
  "$APP_DATA_DIR_ABS/traefik/dynamic"
  "$APP_DATA_DIR_ABS/traefik/certs"
)

mkdir -p -- "${opencloud_paths[@]}" "${traefik_paths[@]}"
for path in "${opencloud_paths[@]}"; do
  [[ ! -L "$path" ]] || fail "OpenCloud data subdirectory must not be a symbolic link: $path"
  chown 1000:1000 -- "$path" 2>/dev/null || true
done
