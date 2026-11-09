#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
DEFAULT_CONFIG="${ROOT_DIR}/config.yml"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

read_env_value() {
  local key="$1"
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

bind_address="$(read_env_value DNS_BIND_ADDRESS)"
[[ "$bind_address" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "DNS_BIND_ADDRESS must be an IPv4 address"

IFS=. read -r octet1 octet2 octet3 octet4 <<< "$bind_address"
for octet in "$octet1" "$octet2" "$octet3" "$octet4"; do
  ((10#$octet <= 255)) || fail "DNS_BIND_ADDRESS contains an invalid IPv4 octet"
done

data_raw="$(read_env_value APP_DATA_DIR)"
[[ -n "$data_raw" && "$data_raw" != /* ]] || fail "APP_DATA_DIR must be a non-empty relative path"
data_candidate="${ROOT_DIR}/${data_raw#./}"
[[ ! -L "$data_candidate" ]] || fail "APP_DATA_DIR must not be a symbolic link"
data_dir="$(realpath -m -- "$data_candidate")"
case "$data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR must remain inside the application version directory" ;;
esac

install -d -m 0750 "$data_dir"
data_dir="$(realpath -e -- "$data_dir")"
case "$data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac

config_file="${data_dir}/config.yml"
cache_dir="${data_dir}/cache"
[[ ! -L "$config_file" ]] || fail "config.yml must not be a symbolic link"
[[ ! -L "$cache_dir" ]] || fail "cache must not be a symbolic link"
[[ -f "$DEFAULT_CONFIG" ]] || fail "$DEFAULT_CONFIG not found"
if [[ ! -e "$config_file" ]]; then
  install -m 0640 "$DEFAULT_CONFIG" "$config_file"
fi
[[ -f "$config_file" ]] || fail "config.yml must be a regular file"
install -d -m 0750 "$cache_dir"
chown 100:100 "$data_dir" "$config_file" "$cache_dir"
chmod 0640 "$config_file"
