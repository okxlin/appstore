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
  value="${value%$'\r'}"
  strip_matching_quotes "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file

  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { updated = 0 }
    $0 ~ ("^" key "=") {
      if (!updated) {
        print key "=" value
        updated = 1
      }
      next
    }
    { print }
    END {
      if (!updated) print key "=" value
    }
  ' "$ENV_FILE" > "$temp_file"
  chmod --reference="$ENV_FILE" "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

path_is_dotenv_safe() {
  local value="$1"

  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) return 1 ;;
    *) return 0 ;;
  esac
}

secret_is_safe() {
  [[ "$1" =~ ^[A-Za-z0-9._~-]+$ ]]
}

generate_hex() {
  local bytes="$1"
  od -An -N "$bytes" -tx1 /dev/urandom | tr -d ' \n'
}

ensure_secret() {
  local key="$1"
  local minimum_length="$2"
  local random_bytes="$3"
  local value

  value="$(read_env_value "$key")"
  if [[ ${#value} -lt "$minimum_length" ]] || ! secret_is_safe "$value"; then
    printf '%s\n' "${key} is missing, too short, or not dotenv-safe; replacing it with a generated value." >&2
    value="$(generate_hex "$random_bytes")"
    set_env_value "$key" "$value"
  fi
}

[[ -f "$ENV_FILE" ]] || fail "Environment file not found: ${ENV_FILE}"

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
    [[ "$(stat -c '%u:%g' "$DATA_DIR_ABS")" == "10001:10001" ]] || \
      fail "Existing absolute APP_DATA_DIR must be owned by UID/GID 10001:10001"
  else
    install -d -m 0750 -- "$DATA_DIR_ABS"
    if [[ "$(id -u)" -eq 0 ]]; then
      chown 10001:10001 -- "$DATA_DIR_ABS"
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
    chown 10001:10001 -- "$DATA_DIR_ABS"
  fi
fi

[[ "$(stat -c '%u:%g' "$DATA_DIR_ABS")" == "10001:10001" ]] || \
  fail "APP_DATA_DIR must be owned by UID/GID 10001:10001"

ensure_secret WASTEBIN_SIGNING_KEY 64 64
ensure_secret WASTEBIN_PASSWORD_SALT 32 32
