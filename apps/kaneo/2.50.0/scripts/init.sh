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

configured_value() {
  local key="$1"
  local default_value="$2"
  local value
  value="${!key:-}"
  if [[ -z "$value" ]]; then
    value="$(read_env_value "$key")"
  fi
  printf '%s\n' "${value:-$default_value}"
}

resolve_app_path() {
  local key="$1"
  local raw="$2"
  local clean candidate resolved current part
  local -a parts=()
  case "$raw" in
    ""|/*|.|..|../*|*/../*|*/..) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  if [[ "$raw" =~ [[:cntrl:]] ]]; then
    echo "unsafe ${key} path" >&2
    return 1
  fi
  clean="${raw#./}"
  [[ -n "$clean" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  command -v realpath >/dev/null 2>&1 || { echo "realpath is required" >&2; return 1; }
  candidate="$ROOT_DIR/$clean"
  resolved="$(realpath -m -- "$candidate")" || { echo "unsafe ${key} path" >&2; return 1; }
  case "$resolved" in
    "$ROOT_DIR"/*) ;;
    *) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  current="$ROOT_DIR"
  IFS='/' read -r -a parts <<< "$clean"
  for part in "${parts[@]}"; do
    [[ -z "$part" || "$part" == "." ]] && continue
    current="$current/$part"
    if [[ -L "$current" ]]; then
      echo "unsafe ${key} path" >&2
      return 1
    fi
  done
  printf '%s\n' "$resolved"
}

set_env_value() {
  local key="$1"
  local value
  local temp_file
  case "$key" in
    POSTGRES_PASSWORD|AUTH_SECRET) value="${!key}" ;;
    *) fail "unsupported environment key: $key" ;;
  esac
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

POSTGRES_PASSWORD="$(read_env_value POSTGRES_PASSWORD)"
if [[ -z "$POSTGRES_PASSWORD" || "$POSTGRES_PASSWORD" == generate ]]; then
  POSTGRES_PASSWORD="$(generate_alphanumeric 48)"
fi
[[ "$POSTGRES_PASSWORD" =~ ^[A-Za-z0-9]{32,128}$ ]] ||
  fail "POSTGRES_PASSWORD must contain 32 to 128 alphanumeric characters"

AUTH_SECRET="$(read_env_value AUTH_SECRET)"
if [[ -z "$AUTH_SECRET" || "$AUTH_SECRET" == generate ]]; then
  AUTH_SECRET="$(openssl rand -hex 32)"
fi
[[ "$AUTH_SECRET" =~ ^[A-Fa-f0-9]{64,128}$ ]] ||
  fail "AUTH_SECRET must contain 64 to 128 hexadecimal characters"

data_raw="$(configured_value APP_DATA_DIR ./data)"
data_dir="$(resolve_app_path APP_DATA_DIR "$data_raw")"

install -d -m 0700 -- "$data_dir/postgres"
resolved_data="$(realpath -e -- "$data_dir")"
case "$resolved_data" in
  "$ROOT_DIR"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
chown -R 70:70 -- "$resolved_data/postgres"
chmod 0700 -- "$resolved_data/postgres"

set_env_value POSTGRES_PASSWORD
set_env_value AUTH_SECRET
chmod 600 "$ENV_FILE"
