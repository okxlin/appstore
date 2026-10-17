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
  if [[ ${#value} -ge 2 && "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
    value="${value:1:${#value}-2}"
  elif [[ ${#value} -ge 2 && "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.prest-env.tmp.XXXXXX")"
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
    END {
      if (!written) print key "=" value
    }
  ' "$ENV_FILE" > "$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

generate_key() {
  local value=""
  if command -v openssl >/dev/null 2>&1; then
    value="$(openssl rand -hex 32)"
  elif [[ -r /dev/urandom ]] && command -v od >/dev/null 2>&1; then
    value="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  fi
  [[ "$value" =~ ^[a-f0-9]{64}$ ]] || fail "Unable to generate a secure PreST JWT key"
  printf '%s\n' "$value"
}

validate_simple() {
  local name="$1"
  local value="$2"
  [[ -n "$value" ]] || fail "$name is required"
  [[ "$value" =~ ^[A-Za-z0-9_.-]+$ ]] || fail "$name contains unsupported characters"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

db_host="$(read_env_value PANEL_DB_HOST)"
db_port="$(read_env_value PANEL_DB_PORT)"
db_name="$(read_env_value PANEL_DB_NAME)"
db_user="$(read_env_value PANEL_DB_USER)"
db_password="$(read_env_value PANEL_DB_USER_PASSWORD)"
ssl_mode="$(read_env_value PREST_PG_SSL_MODE)"

validate_simple PANEL_DB_HOST "$db_host"
if [[ ! "$db_port" =~ ^[0-9]+$ ]] || ((db_port < 1 || db_port > 65535)); then
  fail "PANEL_DB_PORT must be a valid TCP port"
fi
validate_simple PANEL_DB_NAME "$db_name"
validate_simple PANEL_DB_USER "$db_user"
[[ -n "$db_password" ]] || fail "PANEL_DB_USER_PASSWORD is required"
case "$db_password" in
  *$'\n'* | *$'\r'*) fail "PANEL_DB_USER_PASSWORD contains a newline" ;;
esac
[[ "$ssl_mode" =~ ^(disable|require|verify-ca|verify-full)$ ]] || fail "PREST_PG_SSL_MODE is invalid"

requested_key="$(read_env_value PREST_JWT_KEY)"
if [[ -z "$requested_key" || "$requested_key" == "generate" ]]; then
  jwt_key="$(generate_key)"
else
  [[ "$requested_key" =~ ^[A-Za-z0-9._~+/=-]{32,256}$ ]] || fail "PREST_JWT_KEY must be generate or a 32-256 character secret"
  jwt_key="$requested_key"
fi

compose_file="${ROOT_DIR}/docker-compose.yml"
[[ -f "$compose_file" && ! -L "$compose_file" ]] || fail "docker-compose.yml must be a regular file"
grep -Fq 'PREST_JWT_DEFAULT=true' "$compose_file" || fail "PreST JWT protection must remain enabled"
grep -Fq 'PREST_OTEL_ENABLED=false' "$compose_file" || fail "PreST OpenTelemetry must remain disabled by default"

set_env_value PREST_JWT_KEY "$jwt_key"
chmod 600 "$ENV_FILE"
