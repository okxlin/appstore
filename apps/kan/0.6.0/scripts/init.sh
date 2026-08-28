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

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "Environment file is missing or is a symbolic link"

better_auth_secret="$(read_env_value BETTER_AUTH_SECRET)"
[[ ${#better_auth_secret} -ge 32 ]] || fail "BETTER_AUTH_SECRET must contain at least 32 characters"

db_password="$(read_env_value PANEL_DB_USER_PASSWORD)"
[[ "$db_password" =~ ^[A-Za-z0-9._~-]+$ ]] || fail "PANEL_DB_USER_PASSWORD must use URL-safe characters"
