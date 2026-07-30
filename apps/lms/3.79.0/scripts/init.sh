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

path_is_dotenv_safe() {
  local value="$1"

  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) return 1 ;;
    *) return 0 ;;
  esac
}

resolve_path() {
  local raw="$1"
  local label="$2"
  local candidate

  [[ -n "$raw" ]] || fail "${label} must not be empty"
  path_is_dotenv_safe "$raw" || fail "${label} contains unsupported dotenv characters"
  [[ ! -L "$raw" ]] || fail "${label} must not be a symbolic link"

  if [[ "$raw" = /* ]]; then
    candidate="$(realpath -m -- "$raw")"
    [[ "$candidate" != "/" ]] || fail "${label} must not be the filesystem root"
  else
    candidate="${ROOT_DIR}/${raw#./}"
    [[ ! -L "$candidate" ]] || fail "${label} must not be a symbolic link"
    candidate="$(realpath -m -- "$candidate")"
    case "$candidate" in
      "${ROOT_DIR}"/*) ;;
      *) fail "Relative ${label} must remain inside the application version directory" ;;
    esac
  fi

  printf '%s\n' "$candidate"
}

[[ -f "$ENV_FILE" ]] || fail "Environment file not found: ${ENV_FILE}"
chmod 600 "$ENV_FILE"

BIND_ADDRESS="$(read_env_value PANEL_APP_BIND_ADDRESS)"
[[ "$BIND_ADDRESS" =~ ^[A-Za-z0-9.:-]+$ ]] || fail "PANEL_APP_BIND_ADDRESS contains unsupported characters"

HTTP_PORT="$(read_env_value PANEL_APP_PORT_HTTP)"
[[ "$HTTP_PORT" =~ ^[0-9]+$ ]] || fail "PANEL_APP_PORT_HTTP must be numeric"
(( 10#$HTTP_PORT >= 1 && 10#$HTTP_PORT <= 65535 )) || fail "PANEL_APP_PORT_HTTP must be between 1 and 65535"

TIME_ZONE="$(read_env_value TZ)"
[[ "$TIME_ZONE" =~ ^[A-Za-z0-9_+./-]+$ ]] || fail "TZ contains unsupported characters"

if [[ ${LMS_DATA_DIR+x} ]]; then
  DATA_DIR_RAW="$(strip_matching_quotes "$LMS_DATA_DIR")"
else
  DATA_DIR_RAW="$(read_env_value LMS_DATA_DIR)"
fi
DATA_DIR_ABS="$(resolve_path "$DATA_DIR_RAW" LMS_DATA_DIR)"

if [[ -e "$DATA_DIR_ABS" && ! -d "$DATA_DIR_ABS" ]]; then
  fail "LMS_DATA_DIR must be a directory"
fi
if [[ ! -e "$DATA_DIR_ABS" ]]; then
  install -d -m 0750 -- "$DATA_DIR_ABS"
fi
if [[ "$(id -u)" -eq 0 ]]; then
  chown 100:101 -- "$DATA_DIR_ABS"
fi
chmod 0750 -- "$DATA_DIR_ABS"
[[ "$(stat -c '%u:%g' "$DATA_DIR_ABS")" == "100:101" ]] || \
  fail "LMS_DATA_DIR must be owned by UID/GID 100:101"

if [[ ${LMS_MUSIC_DIR+x} ]]; then
  MUSIC_DIR_RAW="$(strip_matching_quotes "$LMS_MUSIC_DIR")"
else
  MUSIC_DIR_RAW="$(read_env_value LMS_MUSIC_DIR)"
fi
MUSIC_DIR_ABS="$(resolve_path "$MUSIC_DIR_RAW" LMS_MUSIC_DIR)"

if [[ -e "$MUSIC_DIR_ABS" && ! -d "$MUSIC_DIR_ABS" ]]; then
  fail "LMS_MUSIC_DIR must be a directory"
fi
if [[ ! -e "$MUSIC_DIR_ABS" ]]; then
  if [[ "$MUSIC_DIR_RAW" = /* ]]; then
    fail "Absolute LMS_MUSIC_DIR must already exist"
  fi
  install -d -m 0755 -- "$MUSIC_DIR_ABS"
fi

CONFIG_DIR="${ROOT_DIR}/config"
[[ ! -L "$CONFIG_DIR" ]] || fail "config directory must not be a symbolic link"
if [[ -e "$CONFIG_DIR" && ! -d "$CONFIG_DIR" ]]; then
  fail "config path must be a directory"
fi
install -d -m 0755 -- "$CONFIG_DIR"
