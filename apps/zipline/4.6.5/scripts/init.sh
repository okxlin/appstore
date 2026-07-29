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
  temp_file="$(mktemp "${ROOT_DIR}/.zipline-env.tmp.XXXXXX")"
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
  local -a octets
  [[ "$value" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "$key must be an IPv4 address"
  IFS=. read -r -a octets <<< "$value"
  for octet in "${octets[@]}"; do
    ((10#$octet <= 255)) || fail "$key contains an invalid IPv4 octet"
  done
}

validate_port() {
  local value="$1"
  [[ "$value" =~ ^[0-9]+$ ]] || fail "PANEL_APP_PORT_HTTP must be an integer"
  ((10#$value >= 1 && 10#$value <= 65535)) || fail "PANEL_APP_PORT_HTTP must be between 1 and 65535"
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
[[ "$(id -u)" -eq 0 ]] || fail "Zipline init must run as root"
command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate credentials"

validate_ipv4 PANEL_APP_BIND_ADDRESS "$(read_env_value PANEL_APP_BIND_ADDRESS)"
validate_port "$(read_env_value PANEL_APP_PORT_HTTP)"

postgres_db="$(read_env_value POSTGRES_DB)"
postgres_user="$(read_env_value POSTGRES_USER)"
[[ "$postgres_db" =~ ^[A-Za-z_][A-Za-z0-9_]{0,62}$ ]] || fail "POSTGRES_DB is invalid"
[[ "$postgres_user" =~ ^[A-Za-z_][A-Za-z0-9_]{0,62}$ ]] || fail "POSTGRES_USER is invalid"

postgres_password="$(read_env_value POSTGRES_PASSWORD)"
if [[ -z "$postgres_password" || "$postgres_password" == generate ]]; then
  postgres_password="$(generate_alphanumeric 48)"
fi
[[ "$postgres_password" =~ ^[A-Za-z0-9]{32,128}$ ]] ||
  fail "POSTGRES_PASSWORD must contain 32 to 128 alphanumeric characters"

core_secret="$(read_env_value CORE_SECRET)"
if [[ -z "$core_secret" || "$core_secret" == generate ]]; then
  core_secret="$(openssl rand -hex 32)"
fi
[[ "$core_secret" =~ ^[A-Fa-f0-9]{64,128}$ ]] ||
  fail "CORE_SECRET must contain 64 to 128 hexadecimal characters"

max_file_size="$(read_env_value FILES_MAX_FILE_SIZE)"
[[ "$max_file_size" =~ ^[1-9][0-9]*(b|kb|mb|gb|tb)$ ]] ||
  fail "FILES_MAX_FILE_SIZE must be a positive byte quantity such as 100mb"

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

install -d -m 0700 -- "$data_dir/postgres"
install -d -m 0750 -- "$data_dir/uploads" "$data_dir/public" "$data_dir/themes"
resolved_data="$(realpath -e -- "$data_dir")"
case "$resolved_data" in
  "$ROOT_DIR"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
chown -R 70:70 -- "$resolved_data/postgres"
chown -R 1000:1000 -- "$resolved_data/uploads" "$resolved_data/public" "$resolved_data/themes"
chmod 0700 -- "$resolved_data/postgres"

set_env_value POSTGRES_PASSWORD "$postgres_password"
set_env_value CORE_SECRET "$core_secret"
chmod 600 "$ENV_FILE"
