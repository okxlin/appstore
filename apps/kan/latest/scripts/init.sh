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

  value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1 || true)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

validate_port() {
  local key="$1"
  local value="$2"

  [[ "$value" =~ ^[0-9]+$ ]] || fail "$key must be an integer"
  ((10#$value >= 1 && 10#$value <= 65535)) || fail "$key must be between 1 and 65535"
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "Environment file is missing or is a symbolic link"

public_url="$(read_env_value NEXT_PUBLIC_BASE_URL)"
[[ "$public_url" =~ ^https?://[^[:space:]]+$ ]] || fail "NEXT_PUBLIC_BASE_URL must be a complete HTTP(S) URL"

better_auth_secret="$(read_env_value BETTER_AUTH_SECRET)"
[[ ${#better_auth_secret} -ge 32 ]] || fail "BETTER_AUTH_SECRET must contain at least 32 characters"

db_host="$(read_env_value PANEL_DB_HOST)"
db_type="$(read_env_value PANEL_DB_TYPE)"
db_port="$(read_env_value PANEL_DB_PORT)"
db_name="$(read_env_value PANEL_DB_NAME)"
db_user="$(read_env_value PANEL_DB_USER)"
db_password="$(read_env_value PANEL_DB_USER_PASSWORD)"

[[ "$db_host" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || fail "PANEL_DB_HOST is invalid"
[[ "$db_type" == postgresql ]] || fail "PANEL_DB_TYPE must be postgresql"
validate_port PANEL_DB_PORT "$db_port"
[[ "$db_name" =~ ^[A-Za-z0-9_][A-Za-z0-9_-]*$ ]] || fail "PANEL_DB_NAME is invalid"
[[ "$db_user" =~ ^[A-Za-z0-9_][A-Za-z0-9_.-]*$ ]] || fail "PANEL_DB_USER is invalid"
[[ "$db_password" =~ ^[A-Za-z0-9._~-]+$ ]] || fail "PANEL_DB_USER_PASSWORD must use URL-safe characters"
