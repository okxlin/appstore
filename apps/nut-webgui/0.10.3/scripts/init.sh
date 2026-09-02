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

effective_value() {
  local key="$1"
  if [[ -v "$key" ]]; then
    printf '%s\n' "${!key}"
  else
    read_env_value "$key"
  fi
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must be a regular file"

upsd_address="$(effective_value UPSD_ADDRESS)"
upsd_port="$(effective_value UPSD_PORT)"
tls_mode="$(effective_value UPSD_TLS_MODE)"
config_raw="$(effective_value APP_CONFIG_DIR)"

[[ -n "$upsd_address" && ! "$upsd_address" =~ [[:space:]/] ]] || fail "UPSD_ADDRESS must be a hostname or IP address"
[[ "$upsd_port" =~ ^[0-9]+$ ]] || fail "UPSD_PORT must be numeric"
((10#$upsd_port >= 1 && 10#$upsd_port <= 65535)) || fail "UPSD_PORT must be between 1 and 65535"
[[ "$tls_mode" == disable || "$tls_mode" == strict || "$tls_mode" == skip ]] || fail "UPSD_TLS_MODE must be disable, strict, or skip"
[[ -n "$config_raw" && ! "$config_raw" =~ [[:cntrl:]\`\$] ]] || fail "APP_CONFIG_DIR is invalid"

if [[ "$config_raw" == /* ]]; then
  config_dir="$(realpath -m -- "$config_raw")"
else
  config_dir="$(realpath -m -- "${ROOT_DIR}/${config_raw#./}")"
  case "$config_dir" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_CONFIG_DIR must stay inside the application version directory" ;;
  esac
fi
case "$config_dir" in
  / | /bin | /boot | /dev | /etc | /home | /lib | /lib64 | /opt | /proc | /root | /run | /sbin | /srv | /sys | /tmp | /usr | /var | /workspace)
    fail "APP_CONFIG_DIR must be a dedicated subdirectory"
    ;;
esac
[[ ! -L "$config_dir" ]] || fail "APP_CONFIG_DIR must not be a symbolic link"
[[ ! -e "$config_dir" || -d "$config_dir" ]] || fail "APP_CONFIG_DIR must be a directory"
install -d -m 0775 -- "$config_dir"
