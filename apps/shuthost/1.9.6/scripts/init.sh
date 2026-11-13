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

  value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2-)"
  case "$value" in
    \"*\" | \'*\') value="${value:1:${#value}-2}" ;;
  esac
  printf '%s\n' "$value"
}

[[ "$(id -u)" -eq 0 ]] || fail "ShutHost init must run as root"
[[ -f "$ENV_FILE" ]] || fail "Environment file not found: ${ENV_FILE}"
[[ ! -L "$ENV_FILE" ]] || fail "Environment file must not be a symbolic link"

DATA_DIR_RAW="${SHUTHOST_DATA_DIR:-$(read_env_value SHUTHOST_DATA_DIR)}"
AUTH_TOKEN="${SHUTHOST_AUTH_TOKEN:-$(read_env_value SHUTHOST_AUTH_TOKEN)}"

[[ -n "$DATA_DIR_RAW" ]] || fail "SHUTHOST_DATA_DIR must not be empty"
case "$DATA_DIR_RAW" in
  *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) fail "SHUTHOST_DATA_DIR contains unsupported dotenv characters" ;;
esac
[[ "$AUTH_TOKEN" =~ ^[A-Za-z0-9._~-]{16,}$ ]] || fail "SHUTHOST_AUTH_TOKEN must contain at least 16 safe characters"

if [[ "$DATA_DIR_RAW" = /* ]]; then
  [[ ! -L "$DATA_DIR_RAW" ]] || fail "SHUTHOST_DATA_DIR must not be a symbolic link"
  DATA_DIR="$(realpath -m -- "$DATA_DIR_RAW")"
  [[ "$DATA_DIR" != "/" ]] || fail "SHUTHOST_DATA_DIR must not be the filesystem root"
else
  DATA_DIR="$(realpath -m -- "${ROOT_DIR}/${DATA_DIR_RAW#./}")"
  case "$DATA_DIR" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative SHUTHOST_DATA_DIR must remain inside the application version directory" ;;
  esac
fi

[[ ! -L "$DATA_DIR" ]] || fail "SHUTHOST_DATA_DIR must not be a symbolic link"
install -d -m 0700 -- "$DATA_DIR"
CONFIG_FILE="${DATA_DIR}/config.toml"
[[ ! -L "$CONFIG_FILE" ]] || fail "ShutHost configuration must not be a symbolic link"

if [[ ! -e "$CONFIG_FILE" ]]; then
  umask 077
  {
    printf '%s\n' '[server]'
    printf '%s\n' 'port = 8080'
    printf '%s\n' 'bind = "0.0.0.0"'
    printf '\n%s\n' '[server.auth.token]'
    printf 'token = "%s"\n' "$AUTH_TOKEN"
    printf '\n%s\n' '[db]'
    printf '%s\n' 'path = "/config/shuthost.db"'
    printf '%s\n' 'enable = true'
    printf '\n%s\n' '[hosts]'
    printf '\n%s\n' '[clients]'
  } > "$CONFIG_FILE"
  chmod 0600 -- "$CONFIG_FILE"
elif [[ ! -f "$CONFIG_FILE" ]]; then
  fail "ShutHost configuration path must be a regular file"
fi
