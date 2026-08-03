#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
DEFAULT_CONFIG="${ROOT_DIR}/config.yml"

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

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.godoxy-env.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { written = 0 }
    $0 ~ "^" key "=" {
      if (!written) {
        print key "=" value
        written = 1
      }
      next
    }
    { print }
    END { if (!written) print key "=" value }
  ' "$ENV_FILE" > "$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

bind_address="$(read_env_value PANEL_APP_BIND_ADDRESS)"
[[ "$bind_address" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address"
IFS=. read -r octet1 octet2 octet3 octet4 <<< "$bind_address"
for octet in "$octet1" "$octet2" "$octet3" "$octet4"; do
  ((10#$octet <= 255)) || fail "PANEL_APP_BIND_ADDRESS contains an invalid IPv4 octet"
done

webui_host="$(read_env_value GODOXY_WEBUI_HOST)"
[[ ${#webui_host} -le 253 ]] || fail "GODOXY_WEBUI_HOST is too long"
[[ "$webui_host" != *..* ]] || fail "GODOXY_WEBUI_HOST contains an empty label"
IFS=. read -ra host_labels <<< "$webui_host"
for host_label in "${host_labels[@]}"; do
  [[ ${#host_label} -le 63 ]] || fail "GODOXY_WEBUI_HOST contains a label longer than 63 characters"
  [[ "$host_label" =~ ^[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?$ ]] || fail "GODOXY_WEBUI_HOST must be a hostname or IPv4 address"
done

admin_user="$(read_env_value GODOXY_API_USER)"
[[ "$admin_user" =~ ^[A-Za-z0-9_.@-]{3,64}$ ]] || fail "GODOXY_API_USER contains unsupported characters"

admin_password="$(read_env_value GODOXY_API_PASSWORD)"
[[ ${#admin_password} -ge 12 ]] || fail "GODOXY_API_PASSWORD must contain at least 12 characters"
[[ "$admin_password" =~ ^[A-Za-z0-9._~!@%+=:,/-]+$ ]] || fail "GODOXY_API_PASSWORD contains unsupported dotenv characters"

jwt_secret="$(read_env_value GODOXY_API_JWT_SECRET)"
if [[ -z "$jwt_secret" || "$jwt_secret" == "generate" ]]; then
  command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate GODOXY_API_JWT_SECRET"
  jwt_secret="$(openssl rand -base64 32 | tr -d '\r\n')"
fi
[[ "$jwt_secret" =~ ^[A-Za-z0-9+/]{43}=$ ]] || fail "GODOXY_API_JWT_SECRET must be base64 for exactly 32 bytes"

data_dir_raw="$(read_env_value APP_DATA_DIR)"
[[ -n "$data_dir_raw" ]] || data_dir_raw="./data"
case "$data_dir_raw" in
  /*) fail "APP_DATA_DIR must be relative to the application version directory" ;;
  *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'") fail "APP_DATA_DIR contains unsupported characters" ;;
esac
data_dir="$(realpath -m -- "${ROOT_DIR}/${data_dir_raw#./}")"
case "$data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR must stay inside the application version directory" ;;
esac
[[ ! -L "$data_dir" ]] || fail "APP_DATA_DIR must not be a symbolic link"

install -d -m 0750 -- "$data_dir" "$data_dir/config" "$data_dir/logs" "$data_dir/error_pages" "$data_dir/runtime" "$data_dir/certs"
resolved_data_dir="$(realpath -e -- "$data_dir")"
case "$resolved_data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac

config_file="$data_dir/config/config.yml"
[[ ! -L "$config_file" ]] || fail "config.yml must not be a symbolic link"
[[ -f "$DEFAULT_CONFIG" ]] || fail "$DEFAULT_CONFIG not found"
if [[ ! -e "$config_file" ]]; then
  install -m 0640 -- "$DEFAULT_CONFIG" "$config_file"
fi
[[ -f "$config_file" ]] || fail "config.yml must be a regular file"

if [[ "$(id -u)" -eq 0 ]]; then
  chown -R 1000:1000 -- "$data_dir"
else
  [[ "$(stat -c '%u:%g' "$data_dir")" == "1000:1000" ]] || fail "GoDoxy init must run as root to prepare APP_DATA_DIR"
fi
chmod 0750 "$data_dir" "$data_dir/config" "$data_dir/logs" "$data_dir/error_pages" "$data_dir/runtime" "$data_dir/certs"
chmod 0640 "$config_file"
set_env_value GODOXY_API_JWT_SECRET "$jwt_secret"
