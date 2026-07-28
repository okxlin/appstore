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
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

validate_ipv4() {
  local value="$1"
  local part
  local -a parts
  IFS='.' read -r -a parts <<< "$value"
  [[ ${#parts[@]} -eq 4 ]] || return 1
  for part in "${parts[@]}"; do
    [[ "$part" =~ ^[0-9]{1,3}$ ]] || return 1
    (( 10#$part <= 255 )) || return 1
  done
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

bind_address="$(read_env_value PANEL_APP_BIND_ADDRESS)"
validate_ipv4 "$bind_address" || fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address"

pooling_size="$(read_env_value WAYBACK_POOLING_SIZE)"
[[ "$pooling_size" =~ ^[0-9]+$ ]] || fail "WAYBACK_POOLING_SIZE must be an integer"
(( pooling_size >= 1 && pooling_size <= 32 )) || fail "WAYBACK_POOLING_SIZE must be between 1 and 32"

timeout="$(read_env_value WAYBACK_TIMEOUT)"
[[ "$timeout" =~ ^[0-9]+$ ]] || fail "WAYBACK_TIMEOUT must be an integer"
(( timeout >= 10 && timeout <= 3600 )) || fail "WAYBACK_TIMEOUT must be between 10 and 3600"

media_size="$(read_env_value WAYBACK_MAX_MEDIA_SIZE)"
[[ "$media_size" =~ ^[1-9][0-9]{0,4}(MB|GB)$ ]] || fail "WAYBACK_MAX_MEDIA_SIZE must use MB or GB, for example 512MB"

data_path="$(read_env_value DATA_PATH)"
[[ "$data_path" =~ ^\./[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$ ]] || fail "DATA_PATH must be a relative path inside the app directory"
[[ "/$data_path/" != *"/../"* ]] || fail "DATA_PATH must not contain parent traversal"

data_dir="${ROOT_DIR}/${data_path#./}"
canonical_root="$(realpath -m -- "$ROOT_DIR")"
canonical_data="$(realpath -m -- "$data_dir")"
[[ "$canonical_data" == "$canonical_root"/* ]] || fail "DATA_PATH resolves outside the app directory"
[[ ! -L "$data_dir" ]] || fail "DATA_PATH must not be a symbolic link"

umask 077
mkdir -p "$data_dir"
chown -R 100:101 "$data_dir"
chmod 750 "$data_dir"
chmod 600 "$ENV_FILE"
