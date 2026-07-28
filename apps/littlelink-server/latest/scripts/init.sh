#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
env_file="${ENV_FILE:-${root_dir}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  local value
  value="$(grep -E "^${key}=" "$env_file" | tail -n 1 | cut -d '=' -f 2- || true)"
  if [[ ${#value} -ge 2 && "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
    value="${value:1:${#value}-2}"
  elif [[ ${#value} -ge 2 && "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "$value"
}

[[ -f "$env_file" ]] || fail "$env_file not found"
[[ ! -L "$env_file" ]] || fail "$env_file must not be a symbolic link"

name="$(read_env_value NAME)"
[[ -n "$name" ]] || fail "NAME is required"

theme="$(read_env_value THEME)"
[[ "$theme" == Dark || "$theme" == Light ]] || fail "THEME must be Dark or Light"

for key in AVATAR_URL GITHUB; do
  value="$(read_env_value "$key")"
  [[ -z "$value" || "$value" =~ ^https?://[^[:space:]\<\>\"\']+$ ]] || fail "$key must be empty or an HTTP(S) URL"
done

email="$(read_env_value EMAIL)"
[[ -z "$email" || "$email" =~ ^[^[:space:]@]+@[^[:space:]@]+$ ]] || fail "EMAIL must be empty or a valid email address"
