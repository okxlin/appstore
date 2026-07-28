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
  temp_file="$(mktemp "${ROOT_DIR}/.asciinema-env.tmp.XXXXXX")"
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

validate_port() {
  local key="$1"
  local value="$2"
  [[ "$value" =~ ^[0-9]+$ ]] || fail "$key must be an integer"
  ((10#$value >= 1 && 10#$value <= 65535)) || fail "$key must be between 1 and 65535"
}

validate_boolean() {
  local key="$1"
  local value="$2"
  [[ "$value" == "true" || "$value" == "false" ]] || fail "$key must be true or false"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

bind_address="$(read_env_value PANEL_APP_BIND_ADDRESS)"
[[ "$bind_address" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address"
IFS=. read -r octet1 octet2 octet3 octet4 <<< "$bind_address"
for octet in "$octet1" "$octet2" "$octet3" "$octet4"; do
  ((10#$octet <= 255)) || fail "PANEL_APP_BIND_ADDRESS contains an invalid IPv4 octet"
done

validate_port PANEL_APP_PORT_HTTP "$(read_env_value PANEL_APP_PORT_HTTP)"
validate_port ASCIINEMA_URL_PORT "$(read_env_value ASCIINEMA_URL_PORT)"

url_scheme="$(read_env_value ASCIINEMA_URL_SCHEME)"
[[ "$url_scheme" == "http" || "$url_scheme" == "https" ]] || fail "ASCIINEMA_URL_SCHEME must be http or https"

url_host="$(read_env_value ASCIINEMA_URL_HOST)"
[[ ${#url_host} -ge 1 && ${#url_host} -le 253 ]] || fail "ASCIINEMA_URL_HOST has an invalid length"
[[ "$url_host" != *..* ]] || fail "ASCIINEMA_URL_HOST contains an empty label"
IFS=. read -ra host_labels <<< "$url_host"
for host_label in "${host_labels[@]}"; do
  [[ ${#host_label} -le 63 ]] || fail "ASCIINEMA_URL_HOST contains an oversized label"
  [[ "$host_label" =~ ^[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?$ ]] || fail "ASCIINEMA_URL_HOST must be a hostname or IPv4 address"
done

validate_boolean ASCIINEMA_SIGN_UP_DISABLED "$(read_env_value ASCIINEMA_SIGN_UP_DISABLED)"
validate_boolean ASCIINEMA_UPLOAD_AUTH_REQUIRED "$(read_env_value ASCIINEMA_UPLOAD_AUTH_REQUIRED)"

timezone="$(read_env_value ASCIINEMA_TIMEZONE)"
[[ "$timezone" =~ ^[A-Za-z0-9_+/-]{1,64}$ && "$timezone" != *..* ]] || fail "ASCIINEMA_TIMEZONE contains unsupported characters"

secret="$(read_env_value ASCIINEMA_SECRET_KEY_BASE)"
if [[ -z "$secret" || "$secret" == "generate" ]]; then
  command -v base64 >/dev/null 2>&1 || fail "base64 is required to generate ASCIINEMA_SECRET_KEY_BASE"
  random_material="$(head -c 96 /dev/urandom | base64 | tr -dc A-Za-z0-9)"
  secret="${random_material:0:64}"
fi
[[ "$secret" =~ ^[A-Za-z0-9]{64,128}$ ]] || fail "ASCIINEMA_SECRET_KEY_BASE must contain 64 to 128 alphanumeric characters"

postgres_password="$(read_env_value ASCIINEMA_POSTGRES_PASSWORD)"
if [[ -z "$postgres_password" || "$postgres_password" == "generate" ]]; then
  command -v base64 >/dev/null 2>&1 || fail "base64 is required to generate ASCIINEMA_POSTGRES_PASSWORD"
  random_material="$(head -c 48 /dev/urandom | base64 | tr -dc A-Za-z0-9)"
  postgres_password="${random_material:0:32}"
fi
[[ "$postgres_password" =~ ^[A-Za-z0-9]{16,128}$ ]] || fail "ASCIINEMA_POSTGRES_PASSWORD must contain 16 to 128 alphanumeric characters"

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

install -d -m 0750 -- "$data_dir"
resolved_data_dir="$(realpath -e -- "$data_dir")"
case "$resolved_data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
[[ "$(id -u)" -eq 0 ]] || fail "asciinema server init must run as root to prepare data ownership"

for child_name in asciinema postgres; do
  [[ ! -L "$data_dir/$child_name" ]] || fail "APP_DATA_DIR/$child_name must not be a symbolic link"
done
install -d -m 0770 -- "$data_dir/asciinema"
install -d -m 0700 -- "$data_dir/postgres"
for child_name in asciinema postgres; do
  resolved_child="$(realpath -e -- "$data_dir/$child_name")"
  case "$resolved_child" in
    "${resolved_data_dir}"/*) ;;
    *) fail "APP_DATA_DIR/$child_name resolves outside APP_DATA_DIR" ;;
  esac
done
chown -R --no-dereference 1000:0 "$data_dir/asciinema"
chown -R --no-dereference 70:70 "$data_dir/postgres"
chmod 0770 "$data_dir/asciinema"
chmod 0700 "$data_dir/postgres"

set_env_value ASCIINEMA_SECRET_KEY_BASE "$secret"
set_env_value ASCIINEMA_POSTGRES_PASSWORD "$postgres_password"
chmod 600 "$ENV_FILE"
