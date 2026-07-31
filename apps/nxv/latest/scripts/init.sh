#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
IMAGE="ghcr.io/utensils/nxv:latest"

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
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E '^APP_DATA_DIR=' "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi
  value="${value%$'\r'}"
  strip_matching_quotes "$value"
}

if [[ ${APP_DATA_DIR+x} ]]; then
  DATA_DIR_RAW="$APP_DATA_DIR"
else
  DATA_DIR_RAW="$(read_env_value)"
fi
DATA_DIR_RAW="$(strip_matching_quotes "${DATA_DIR_RAW:-./data}")"

[[ -n "$DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be empty"
case "$DATA_DIR_RAW" in
  *$'\n'* | *$'\r'* | *:*) fail "APP_DATA_DIR contains unsupported characters" ;;
esac

if [[ "$DATA_DIR_RAW" = /* ]]; then
  [[ ! -L "$DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_RAW")"
  [[ "$DATA_DIR_ABS" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
else
  DATA_DIR_PATH="${ROOT_DIR}/${DATA_DIR_RAW#./}"
  [[ ! -L "$DATA_DIR_PATH" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  ROOT_DIR_ABS="$(realpath -m -- "$ROOT_DIR")"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_PATH")"
  case "$DATA_DIR_ABS" in
    "${ROOT_DIR_ABS}"/*) ;;
    *) fail "Relative APP_DATA_DIR must remain inside the app version directory" ;;
  esac
fi

if [[ -e "$DATA_DIR_ABS" && ! -d "$DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi
install -d -m 0750 -- "$DATA_DIR_ABS"

docker run --rm --volume "${DATA_DIR_ABS}:/data" "$IMAGE" \
  --db-path /data/index.db sync

[[ -s "$DATA_DIR_ABS/index.db" ]] || fail "nxv sync did not create index.db"
[[ -s "$DATA_DIR_ABS/index.bloom" ]] || fail "nxv sync did not create index.bloom"
