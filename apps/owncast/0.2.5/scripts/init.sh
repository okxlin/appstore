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
  temp_file="$(mktemp "${ROOT_DIR}/.owncast-env.tmp.XXXXXX")"
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
  local key="$1"
  local value="$2"
  local octet
  [[ "$value" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "$key must be an IPv4 address"
  IFS=. read -r -a octets <<< "$value"
  for octet in "${octets[@]}"; do
    ((10#$octet <= 255)) || fail "$key contains an invalid IPv4 octet"
  done
}

validate_port() {
  local key="$1"
  local value="$2"
  [[ "$value" =~ ^[0-9]+$ ]] || fail "$key must be an integer"
  ((10#$value >= 1 && 10#$value <= 65535)) || fail "$key must be between 1 and 65535"
}

generate_secret() {
  local length="$1"
  local material
  command -v base64 >/dev/null 2>&1 || fail "base64 is required to generate credentials"
  material="$(head -c 96 /dev/urandom | base64 | tr -dc A-Za-z0-9)"
  [[ ${#material} -ge $length ]] || fail "unable to generate sufficient random material"
  printf '%s\n' "${material:0:length}"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"
[[ "$(id -u)" -eq 0 ]] || fail "Owncast init must run as root"

validate_ipv4 PANEL_APP_BIND_ADDRESS "$(read_env_value PANEL_APP_BIND_ADDRESS)"
validate_ipv4 PANEL_APP_RTMP_BIND_ADDRESS "$(read_env_value PANEL_APP_RTMP_BIND_ADDRESS)"
http_port="$(read_env_value PANEL_APP_PORT_HTTP)"
rtmp_port="$(read_env_value PANEL_APP_PORT_RTMP)"
validate_port PANEL_APP_PORT_HTTP "$http_port"
validate_port PANEL_APP_PORT_RTMP "$rtmp_port"
[[ "$http_port" != "$rtmp_port" ]] || fail "PANEL_APP_PORT_HTTP and PANEL_APP_PORT_RTMP must differ"

admin_password="$(read_env_value OWNCAST_ADMIN_PASSWORD)"
if [[ -z "$admin_password" || "$admin_password" == "generate" ]]; then
  admin_password="$(generate_secret 32)"
fi
[[ "$admin_password" =~ ^[A-Za-z0-9]{16,72}$ ]] || fail "OWNCAST_ADMIN_PASSWORD must contain 16 to 72 alphanumeric characters"

stream_key="$(read_env_value OWNCAST_STREAM_KEY)"
if [[ -z "$stream_key" || "$stream_key" == "generate" ]]; then
  stream_key="$(generate_secret 40)"
fi
[[ "$stream_key" =~ ^[A-Za-z0-9]{24,128}$ ]] || fail "OWNCAST_STREAM_KEY must contain 24 to 128 alphanumeric characters"

data_raw="$(read_env_value APP_DATA_DIR)"
[[ -n "$data_raw" && "$data_raw" != /* ]] || fail "APP_DATA_DIR must be a non-empty relative path"
case "$data_raw" in
  *$'\n'* | *$'\r'* | *\\* | *:* | *'$'* | *'#'* | *'"'* | *"'"*) fail "APP_DATA_DIR contains unsupported characters" ;;
esac

relative_data="${data_raw#./}"
[[ -n "$relative_data" ]] || fail "APP_DATA_DIR must not resolve to the version root"
current="$ROOT_DIR"
IFS=/ read -r -a components <<< "$relative_data"
for component in "${components[@]}"; do
  [[ -n "$component" && "$component" != "." && "$component" != ".." ]] || fail "APP_DATA_DIR contains traversal"
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
chown 101:101 "$resolved_data"
chmod 0750 "$resolved_data"

set_env_value OWNCAST_ADMIN_PASSWORD "$admin_password"
set_env_value OWNCAST_STREAM_KEY "$stream_key"
chmod 600 "$ENV_FILE"
