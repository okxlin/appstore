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
  local value
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
  temp_file="$(mktemp "${ROOT_DIR}/.microbin-env.tmp.XXXXXX")"
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

validate_ipv4() {
  local value="$1"
  local octet
  local -a octets
  [[ "$value" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address"
  IFS=. read -r -a octets <<< "$value"
  for octet in "${octets[@]}"; do
    ((10#$octet <= 255)) || fail "PANEL_APP_BIND_ADDRESS contains an invalid IPv4 octet"
  done
}

validate_positive_integer() {
  local key="$1"
  local value="$2"
  local maximum="$3"
  [[ "$value" =~ ^[1-9][0-9]*$ ]] || fail "$key must be a positive integer"
  ((10#$value <= maximum)) || fail "$key must not exceed $maximum"
}

generate_alphanumeric() {
  local length="$1"
  local material
  material="$(openssl rand -base64 96 | tr -dc A-Za-z0-9)"
  [[ ${#material} -ge $length ]] || fail "unable to generate sufficient random material"
  printf '%s\n' "${material:0:length}"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"
[[ "$(id -u)" -eq 0 ]] || fail "MicroBin init must run as root"
command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate credentials"

validate_ipv4 "$(read_env_value PANEL_APP_BIND_ADDRESS)"
validate_positive_integer PANEL_APP_PORT_HTTP "$(read_env_value PANEL_APP_PORT_HTTP)" 65535

admin_username="$(read_env_value MICROBIN_ADMIN_USERNAME)"
[[ "$admin_username" =~ ^[A-Za-z0-9][A-Za-z0-9_.-]{0,63}$ ]] || fail "MICROBIN_ADMIN_USERNAME is invalid"

admin_password="$(read_env_value MICROBIN_ADMIN_PASSWORD)"
if [[ -z "$admin_password" || "$admin_password" == generate ]]; then
  admin_password="$(generate_alphanumeric 48)"
fi
[[ "$admin_password" =~ ^[A-Za-z0-9]{32,128}$ ]] ||
  fail "MICROBIN_ADMIN_PASSWORD must contain 32 to 128 alphanumeric characters"

validate_positive_integer MICROBIN_MAX_FILE_SIZE_ENCRYPTED_MB "$(read_env_value MICROBIN_MAX_FILE_SIZE_ENCRYPTED_MB)" 4096
validate_positive_integer MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB "$(read_env_value MICROBIN_MAX_FILE_SIZE_UNENCRYPTED_MB)" 4096

data_raw="$(read_env_value APP_DATA_DIR)"
[[ -n "$data_raw" && "$data_raw" != /* ]] || fail "APP_DATA_DIR must be a non-empty relative path"
case "$data_raw" in
  *$'\n'* | *$'\r'* | *\\* | *:* | *'$'* | *'#'* | *'"'* | *"'"*)
    fail "APP_DATA_DIR contains unsupported characters"
    ;;
esac

relative_data="${data_raw#./}"
[[ -n "$relative_data" ]] || fail "APP_DATA_DIR must not resolve to the version root"
current="$ROOT_DIR"
IFS=/ read -r -a components <<< "$relative_data"
for component in "${components[@]}"; do
  [[ -n "$component" && "$component" != . && "$component" != .. ]] || fail "APP_DATA_DIR contains traversal"
  current="$current/$component"
  [[ ! -L "$current" ]] || fail "APP_DATA_DIR must not contain symbolic-link components"
done

data_dir="$(realpath -m -- "$ROOT_DIR/$relative_data")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *) fail "APP_DATA_DIR must stay inside the application version directory" ;;
esac

install -d -m 0750 -- "$data_dir"
resolved_data="$(realpath -e -- "$data_dir")"
case "$resolved_data" in
  "$ROOT_DIR"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
chown -R 65534:65534 -- "$resolved_data"

set_env_value MICROBIN_ADMIN_PASSWORD "$admin_password"
chmod 600 "$ENV_FILE"
