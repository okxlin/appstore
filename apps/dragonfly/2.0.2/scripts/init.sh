#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

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
  strip_matching_quotes "$value"
}

path_is_dotenv_safe() {
  local value="$1"

  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) return 1 ;;
    *) return 0 ;;
  esac
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

if [[ ${APP_DATA_DIR+x} ]]; then
  APP_DATA_DIR_RAW="$APP_DATA_DIR"
else
  APP_DATA_DIR_RAW="$(read_env_value APP_DATA_DIR)"
fi
APP_DATA_DIR_RAW="$(strip_matching_quotes "${APP_DATA_DIR_RAW:-./data}")"

[[ -n "$APP_DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be empty"
path_is_dotenv_safe "$APP_DATA_DIR_RAW" || fail "APP_DATA_DIR contains unsupported dotenv characters"

case "$APP_DATA_DIR_RAW" in
  /*)
    APP_DATA_DIR_ABS="$(realpath -m -- "$APP_DATA_DIR_RAW")"
    ;;
  *)
    APP_DATA_DIR_ABS="$(realpath -m -- "${ROOT_DIR}/${APP_DATA_DIR_RAW#./}")"
    case "$APP_DATA_DIR_ABS" in
      "${ROOT_DIR}" | "${ROOT_DIR}"/*) ;;
      *) fail "Relative APP_DATA_DIR must stay inside the application directory" ;;
    esac
    ;;
esac

[[ "$APP_DATA_DIR_ABS" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
[[ ! -L "$APP_DATA_DIR_ABS" ]] || fail "APP_DATA_DIR must not be a symbolic link"
if [[ -e "$APP_DATA_DIR_ABS" && ! -d "$APP_DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi

DRAGONFLY_PASSWORD_VALUE="${DRAGONFLY_PASSWORD:-$(read_env_value DRAGONFLY_PASSWORD)}"
DRAGONFLY_MAX_MEMORY_VALUE="${DRAGONFLY_MAX_MEMORY:-$(read_env_value DRAGONFLY_MAX_MEMORY)}"
DRAGONFLY_THREADS_VALUE="${DRAGONFLY_THREADS:-$(read_env_value DRAGONFLY_THREADS)}"
DRAGONFLY_SNAPSHOT_CRON_VALUE="${DRAGONFLY_SNAPSHOT_CRON:-$(read_env_value DRAGONFLY_SNAPSHOT_CRON)}"

[[ ${#DRAGONFLY_PASSWORD_VALUE} -ge 16 ]] || fail "DRAGONFLY_PASSWORD must be at least 16 characters"
case "$DRAGONFLY_PASSWORD_VALUE" in
  *$'\n'* | *$'\r'*) fail "DRAGONFLY_PASSWORD must stay on one line" ;;
esac

DRAGONFLY_MAX_MEMORY_VALUE="${DRAGONFLY_MAX_MEMORY_VALUE,,}"
[[ "$DRAGONFLY_MAX_MEMORY_VALUE" =~ ^[1-9][0-9]*(b|kb|mb|gb|kib|mib|gib)$ ]] || \
  fail "DRAGONFLY_MAX_MEMORY must be a memory size such as 1gb"
MEMORY_AMOUNT="${DRAGONFLY_MAX_MEMORY_VALUE%%[a-z]*}"
MEMORY_UNIT="${DRAGONFLY_MAX_MEMORY_VALUE#"${MEMORY_AMOUNT}"}"
[[ ${#MEMORY_AMOUNT} -le 9 ]] || fail "DRAGONFLY_MAX_MEMORY exceeds the supported memory size range"
[[ "$DRAGONFLY_THREADS_VALUE" =~ ^[1-9][0-9]*$ ]] || \
  fail "DRAGONFLY_THREADS must be a positive integer"
[[ ${#DRAGONFLY_THREADS_VALUE} -le 9 ]] || fail "DRAGONFLY_THREADS must be a positive integer in the supported range"

MEMORY_AMOUNT_DECIMAL=$((10#${MEMORY_AMOUNT}))
THREAD_COUNT=$((10#${DRAGONFLY_THREADS_VALUE}))
case "$MEMORY_UNIT" in
  b) MEMORY_KIB=$((MEMORY_AMOUNT_DECIMAL / 1024)) ;;
  kb | kib) MEMORY_KIB=$MEMORY_AMOUNT_DECIMAL ;;
  mb | mib) MEMORY_KIB=$((MEMORY_AMOUNT_DECIMAL * 1024)) ;;
  gb | gib) MEMORY_KIB=$((MEMORY_AMOUNT_DECIMAL * 1048576)) ;;
  *) fail "DRAGONFLY_MAX_MEMORY must use b, kb, mb, gb, kib, mib, or gib" ;;
esac
REQUIRED_MEMORY_KIB=$((THREAD_COUNT * 262144))
((MEMORY_KIB >= REQUIRED_MEMORY_KIB)) || \
  fail "DRAGONFLY_MAX_MEMORY must provide at least 256 MiB per worker thread"

[[ "$DRAGONFLY_SNAPSHOT_CRON_VALUE" =~ ^[^[:space:]]+([[:space:]]+[^[:space:]]+){4}$ ]] || \
  fail "DRAGONFLY_SNAPSHOT_CRON must contain five cron fields"
[[ "$DRAGONFLY_SNAPSHOT_CRON_VALUE" =~ ^[0-9*/?,\ -]+$ ]] || \
  fail "DRAGONFLY_SNAPSHOT_CRON contains unsupported characters"

mkdir -p -- "$APP_DATA_DIR_ABS"
chown 999:999 -- "$APP_DATA_DIR_ABS"
chmod 700 -- "$APP_DATA_DIR_ABS"
chmod 600 -- "$ENV_FILE"
