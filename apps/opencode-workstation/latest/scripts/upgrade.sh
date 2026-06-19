#!/bin/bash
# upgrade.sh - opencode-workstation 1Panel upgrade helper
set -eo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
APP_ROOT="${APP_ROOT:-$ROOT_DIR}"

resolve_app_path() {
  local raw="$1"
  if [[ "$raw" = /* ]]; then
    printf '%s\n' "$raw"
  else
    printf '%s\n' "$APP_ROOT/${raw#./}"
  fi
}

get_env_value() {
  local key="$1"
  local default="$2"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
  fi

  if [[ -n "$value" ]]; then
    printf '%s\n' "$value"
  else
    printf '%s\n' "$default"
  fi
}

ensure_env_default() {
  local key="$1"
  local value="$2"

  if grep -qE "^${key}=" "$ENV_FILE"; then
    echo "${key} already exists"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added ${key}=${value}"
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_default "CUSTOM_ENV_FILE" "./data/custom.env"
else
  echo "${ENV_FILE} not found; skipped environment migration"
fi

custom_env_file="$(resolve_app_path "$(get_env_value "CUSTOM_ENV_FILE" "./data/custom.env")")"
mkdir -p "$(dirname "$custom_env_file")"
touch "$custom_env_file"
echo "Ensured custom env file: ${custom_env_file}"

echo "OpenCode Workstation upgrade migration completed."
