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
  temp_file="$(mktemp "${ROOT_DIR}/.kaneo-env.tmp.XXXXXX")"
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
  local key="$1"
  local value="$2"
  [[ "$value" =~ ^[0-9]+$ ]] || fail "$key must be an integer"
  ((10#$value >= 1 && 10#$value <= 65535)) || fail "$key must be between 1 and 65535"
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
[[ "$(id -u)" -eq 0 ]] || fail "Kaneo init must run as root"
command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate credentials"

validate_ipv4 PANEL_APP_BIND_ADDRESS "$(read_env_value PANEL_APP_BIND_ADDRESS)"
validate_port PANEL_APP_PORT_HTTP "$(read_env_value PANEL_APP_PORT_HTTP)"

client_url="$(read_env_value KANEO_CLIENT_URL)"
[[ "$client_url" =~ ^https?://([A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?|localhost)(:([0-9]{1,5}))?$ ]] ||
  fail "KANEO_CLIENT_URL must be an HTTP(S) origin without a path"
[[ "$client_url" != *..* ]] || fail "KANEO_CLIENT_URL contains an invalid hostname"
if [[ -n "${BASH_REMATCH[4]:-}" ]]; then
  validate_port KANEO_CLIENT_URL_PORT "${BASH_REMATCH[4]}"
fi

disable_registration="$(read_env_value DISABLE_REGISTRATION)"
[[ "$disable_registration" == true || "$disable_registration" == false ]] ||
  fail "DISABLE_REGISTRATION must be true or false"

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

auth_secret="$(read_env_value AUTH_SECRET)"
if [[ -z "$auth_secret" || "$auth_secret" == generate ]]; then
  auth_secret="$(openssl rand -hex 32)"
fi
[[ "$auth_secret" =~ ^[A-Fa-f0-9]{64,128}$ ]] ||
  fail "AUTH_SECRET must contain 64 to 128 hexadecimal characters"

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
resolved_data="$(realpath -e -- "$data_dir")"
case "$resolved_data" in
  "$ROOT_DIR"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
chown -R 70:70 -- "$resolved_data/postgres"
chmod 0700 -- "$resolved_data/postgres"

set_env_value POSTGRES_PASSWORD "$postgres_password"
set_env_value AUTH_SECRET "$auth_secret"
chmod 600 "$ENV_FILE"
