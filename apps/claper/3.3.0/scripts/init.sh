#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

strip_matching_quotes() {
  local value="$1"
  if [[ ${#value} -ge 2 ]]; then
    if [[ "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
      value="${value:1:${#value}-2}"
    elif [[ "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
      value="${value:1:${#value}-2}"
    fi
  fi
  printf '%s\n' "$value"
}

read_env_value() {
  local key="$1"
  local value=""
  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi
  strip_matching_quotes "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { updated = 0 }
    $0 ~ ("^" key "=") {
      if (!updated) { print key "=" value; updated = 1 }
      next
    }
    { print }
    END { if (!updated) print key "=" value }
  ' "$ENV_FILE" > "$temp_file"
  chmod --reference="$ENV_FILE" "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

[[ -f "$ENV_FILE" ]] || { printf '%s\n' "Environment file not found: $ENV_FILE" >&2; exit 1; }

secret_key_base="$(read_env_value SECRET_KEY_BASE)"
if [[ ${#secret_key_base} -lt 64 ]]; then
  secret_key_base="$(od -An -N64 -tx1 /dev/urandom | tr -d ' \n')"
  set_env_value SECRET_KEY_BASE "$secret_key_base"
fi
