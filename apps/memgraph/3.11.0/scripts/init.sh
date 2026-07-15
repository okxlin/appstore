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

  value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  strip_matching_quotes "$value"
}

configured_value() {
  local key="$1"

  if [[ ${!key+x} ]]; then
    strip_matching_quotes "${!key}"
  else
    read_env_value "$key"
  fi
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

APP_DATA_DIR_RAW="$(configured_value APP_DATA_DIR)"
APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW:-./data}"
[[ -n "$APP_DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be empty"
path_is_dotenv_safe "$APP_DATA_DIR_RAW" || fail "APP_DATA_DIR contains unsupported dotenv characters"

if [[ "$APP_DATA_DIR_RAW" == /* ]]; then
  APP_DATA_DIR_PATH="$(realpath -ms -- "$APP_DATA_DIR_RAW")"
  [[ ! -L "$APP_DATA_DIR_PATH" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  APP_DATA_DIR_ABS="$(realpath -m -- "$APP_DATA_DIR_PATH")"
else
  APP_DATA_DIR_PATH="$(realpath -ms -- "${ROOT_DIR}/${APP_DATA_DIR_RAW#./}")"
  case "$APP_DATA_DIR_PATH" in
    "${ROOT_DIR}" | "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_DATA_DIR must stay inside the application directory" ;;
  esac
  [[ ! -L "$APP_DATA_DIR_PATH" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  APP_DATA_DIR_ABS="$(realpath -m -- "$APP_DATA_DIR_PATH")"
  case "$APP_DATA_DIR_ABS" in
    "${ROOT_DIR}" | "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_DATA_DIR must stay inside the application directory" ;;
  esac
fi

[[ "$APP_DATA_DIR_ABS" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
if [[ -e "$APP_DATA_DIR_ABS" && ! -d "$APP_DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi
for child in data logs; do
  [[ ! -L "${APP_DATA_DIR_ABS}/${child}" ]] || fail "${child} directory must not be a symbolic link"
done

MEMGRAPH_USER_VALUE="$(configured_value MEMGRAPH_USER)"
MEMGRAPH_PASSWORD_VALUE="$(configured_value MEMGRAPH_PASSWORD)"
MEMGRAPH_MEMORY_LIMIT_VALUE="$(configured_value MEMGRAPH_MEMORY_LIMIT)"
MEMGRAPH_WORKERS_VALUE="$(configured_value MEMGRAPH_WORKERS)"
MEMGRAPH_SNAPSHOT_INTERVAL_VALUE="$(configured_value MEMGRAPH_SNAPSHOT_INTERVAL)"

[[ "$MEMGRAPH_USER_VALUE" =~ ^[A-Za-z0-9_.+@-]+$ ]] || \
  fail "MEMGRAPH_USER must be a valid username using letters, digits, ., _, +, @, or -"
[[ ${#MEMGRAPH_USER_VALUE} -le 128 ]] || fail "MEMGRAPH_USER username is too long"

[[ ${#MEMGRAPH_PASSWORD_VALUE} -ge 16 ]] || fail "MEMGRAPH_PASSWORD must be at least 16 characters"
case "$MEMGRAPH_PASSWORD_VALUE" in
  *$'\n'* | *$'\r'*) fail "MEMGRAPH_PASSWORD must stay on one line" ;;
esac

[[ "$MEMGRAPH_MEMORY_LIMIT_VALUE" =~ ^[1-9][0-9]*$ ]] || \
  fail "MEMGRAPH_MEMORY_LIMIT must be a positive integer in MiB"
[[ ${#MEMGRAPH_MEMORY_LIMIT_VALUE} -le 9 ]] || fail "MEMGRAPH_MEMORY_LIMIT exceeds the supported range"
MEMGRAPH_MEMORY_LIMIT_DECIMAL=$((10#${MEMGRAPH_MEMORY_LIMIT_VALUE}))
((MEMGRAPH_MEMORY_LIMIT_DECIMAL >= 512)) || fail "MEMGRAPH_MEMORY_LIMIT must be at least 512 MiB"

[[ "$MEMGRAPH_WORKERS_VALUE" =~ ^[1-9][0-9]*$ ]] || fail "MEMGRAPH_WORKERS must be a positive integer"
[[ ${#MEMGRAPH_WORKERS_VALUE} -le 9 ]] || fail "MEMGRAPH_WORKERS must be a positive integer in the supported range"

[[ "$MEMGRAPH_SNAPSHOT_INTERVAL_VALUE" =~ ^[1-9][0-9]*$ ]] || \
  fail "MEMGRAPH_SNAPSHOT_INTERVAL must be a positive integer"
[[ ${#MEMGRAPH_SNAPSHOT_INTERVAL_VALUE} -le 9 ]] || \
  fail "MEMGRAPH_SNAPSHOT_INTERVAL exceeds the supported range"
MEMGRAPH_SNAPSHOT_INTERVAL_DECIMAL=$((10#${MEMGRAPH_SNAPSHOT_INTERVAL_VALUE}))
((MEMGRAPH_SNAPSHOT_INTERVAL_DECIMAL >= 60)) || \
  fail "MEMGRAPH_SNAPSHOT_INTERVAL must be at least 60 seconds"

mkdir -p -- "$APP_DATA_DIR_ABS" "${APP_DATA_DIR_ABS}/data" "${APP_DATA_DIR_ABS}/logs"
chown 101:103 -- "${APP_DATA_DIR_ABS}/data" "${APP_DATA_DIR_ABS}/logs"
chmod 750 -- "${APP_DATA_DIR_ABS}/data" "${APP_DATA_DIR_ABS}/logs"
chmod 600 -- "$ENV_FILE"
