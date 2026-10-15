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

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

legacy_data_dir="$(configured_value APP_DATA_DIR)"
case "$legacy_data_dir" in
  ""|data|./data) ;;
  *) fail "APP_DATA_DIR is no longer configurable; migrate its data to ${ROOT_DIR}/data before upgrading" ;;
esac

APP_DATA_DIR_ABS="$ROOT_DIR/data"
[[ ! -L "$APP_DATA_DIR_ABS" ]] || fail "package data directory must not be a symbolic link"
if [[ -e "$APP_DATA_DIR_ABS" && ! -d "$APP_DATA_DIR_ABS" ]]; then
  fail "package data directory must be a directory"
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
