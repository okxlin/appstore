#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
POLARIS_UID=100
POLARIS_GID=100

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  value="${value%$'\r'}"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

reject_symlink_components() {
  local path="$1"
  local current=""
  local component
  IFS='/' read -r -a components <<< "${path#/}"
  for component in "${components[@]}"; do
    [[ -n "$component" ]] || continue
    current="${current}/${component}"
    [[ ! -L "$current" ]] || fail "$path must not contain symbolic-link components"
  done
}

resolve_path() {
  local key="$1"
  local raw="$2"
  local candidate
  local resolved

  [[ -n "$raw" ]] || fail "$key must not be empty"
  [[ "$raw" =~ ^[A-Za-z0-9._/\ -]+$ ]] || fail "$key contains unsupported characters"
  if [[ "$raw" == /* ]]; then
    candidate="$raw"
  else
    candidate="${ROOT_DIR}/${raw#./}"
  fi
  reject_symlink_components "$candidate"
  resolved="$(realpath -m -- "$candidate")" || fail "Unable to resolve $key"
  [[ "$resolved" != "/" ]] || fail "$key must not be the filesystem root"
  if [[ "$raw" != /* ]]; then
    case "$resolved" in
      "${ROOT_DIR}"/*) ;;
      *) fail "Relative $key must stay inside the application directory" ;;
    esac
  fi
  [[ ! -e "$resolved" || -d "$resolved" ]] || fail "$key must be a directory"
  printf '%s\n' "$resolved"
}

prepare_path() {
  local key="$1"
  local ownership="$2"
  local resolved
  resolved="$(resolve_path "$key" "$(read_env_value "$key")")"
  install -d -m 0755 -- "$resolved" || fail "Unable to create $key"
  resolved="$(realpath -e -- "$resolved")" || fail "Unable to verify $key"
  reject_symlink_components "$resolved"
  [[ -z "$(find "$resolved" -xdev -type l -print -quit)" ]] || fail "$key must not contain symbolic links"
  if [[ "$ownership" == "polaris" ]]; then
    chown -R --no-dereference "${POLARIS_UID}:${POLARIS_GID}" "$resolved" || fail "Unable to set $key ownership"
  fi
}

[[ "$(id -u)" -eq 0 ]] || fail "Polaris init must run as root"
[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "Environment file not found or unsafe: $ENV_FILE"

prepare_path POLARIS_MUSIC_DIR readonly
prepare_path POLARIS_CACHE_DIR polaris
prepare_path POLARIS_DATA_DIR polaris
