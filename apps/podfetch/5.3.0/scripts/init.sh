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

prepare_directory() {
  local key="$1"
  local raw="$2"
  local absolute=""

  [[ -n "$raw" ]] || fail "${key} must not be empty"
  case "$raw" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) fail "${key} contains unsupported dotenv characters" ;;
  esac
  if [[ "$raw" = /* ]]; then
    [[ ! -L "$raw" ]] || fail "${key} must not be a symbolic link"
    absolute="$(realpath -m -- "$raw")"
    [[ "$absolute" != "/" ]] || fail "${key} must not be the filesystem root"
    if [[ -e "$absolute" ]]; then
      [[ -d "$absolute" ]] || fail "${key} must be a directory"
      [[ "$(stat -c '%u:%g' "$absolute")" == "${PUID}:${PGID}" ]] || fail "Existing ${key} must be owned by ${PUID}:${PGID}"
    else
      install -d -m 0750 -- "$absolute"
      chown "${PUID}:${PGID}" -- "$absolute"
    fi
  else
    absolute="$(realpath -m -- "${ROOT_DIR}/${raw#./}")"
    case "$absolute" in
      "${ROOT_DIR}"/*) ;;
      *) fail "Relative ${key} must remain inside the application version directory" ;;
    esac
    [[ ! -L "$absolute" ]] || fail "${key} must not be a symbolic link"
    install -d -m 0750 -- "$absolute"
    chown "${PUID}:${PGID}" -- "$absolute"
  fi
}

[[ "$(id -u)" -eq 0 ]] || fail "PodFetch init must run as root"
[[ -f "$ENV_FILE" ]] || fail "Environment file not found: ${ENV_FILE}"
[[ ! -L "$ENV_FILE" ]] || fail "Environment file must not be a symbolic link"

PUID="${PUID:-$(read_env_value PUID)}"
PGID="${PGID:-$(read_env_value PGID)}"
[[ "$PUID" =~ ^[0-9]+$ && "$PGID" =~ ^[0-9]+$ ]] || fail "PUID and PGID must be numeric"

prepare_directory PODCASTS_DIR "${PODCASTS_DIR:-$(read_env_value PODCASTS_DIR)}"
prepare_directory DATABASE_DIR "${DATABASE_DIR:-$(read_env_value DATABASE_DIR)}"
