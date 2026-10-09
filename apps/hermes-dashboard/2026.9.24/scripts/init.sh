#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT_DIR/.env"
APP_DATA_DIR_RAW="${APP_DATA_DIR:-./data}"
DEFAULT_UID="10000"
DEFAULT_GID="10000"
TARGET_UID="${HERMES_UID:-$DEFAULT_UID}"
TARGET_GID="${HERMES_GID:-$DEFAULT_GID}"

if [[ "$APP_DATA_DIR_RAW" = /* ]]; then
  APP_DATA_DIR_ABS="$APP_DATA_DIR_RAW"
else
  APP_DATA_DIR_ABS="$ROOT_DIR/${APP_DATA_DIR_RAW#./}"
fi

mkdir -p "$APP_DATA_DIR_ABS"

upsert_env_if_missing() {
  local key="$1"
  local value="$2"

  if [[ ! -f "$ENV_FILE" ]]; then
    return 0
  fi

  if ! grep -q "^${key}=" "$ENV_FILE" 2>/dev/null; then
    printf '\n%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  fi
}

generate_random_value() {
  local length="$1"
  local value=""

  while [[ ${#value} -lt $length ]]; do
    value+="$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c "$((length - ${#value}))" || true)"
  done

  printf '%s' "$value"
}

ensure_env_value() {
  local key="$1"
  local value="$2"

  if [[ ! -f "$ENV_FILE" ]]; then
    return 0
  fi

  if ! grep -q "^${key}=" "$ENV_FILE" 2>/dev/null; then
    printf '\n%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  elif grep -Eq "^${key}=([[:space:]]*|\"\"|'')$" "$ENV_FILE"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
  fi
}

if [[ -f "$ENV_FILE" ]]; then
  EXISTING_UID=$(grep '^HERMES_UID=' "$ENV_FILE" 2>/dev/null | tail -n 1 | cut -d '=' -f 2- || true)
  EXISTING_GID=$(grep '^HERMES_GID=' "$ENV_FILE" 2>/dev/null | tail -n 1 | cut -d '=' -f 2- || true)
  [[ -n "$EXISTING_UID" ]] && TARGET_UID="$EXISTING_UID"
  [[ -n "$EXISTING_GID" ]] && TARGET_GID="$EXISTING_GID"
fi

upsert_env_if_missing "HERMES_UID" "$TARGET_UID"
upsert_env_if_missing "HERMES_GID" "$TARGET_GID"
ensure_env_value "DASHBOARD_USERNAME" "admin"
ensure_env_value "DASHBOARD_PASSWORD" "$(generate_random_value 32)"
ensure_env_value "DASHBOARD_SESSION_SECRET" "$(generate_random_value 48)"

CURRENT_UID=$(stat -c '%u' "$APP_DATA_DIR_ABS" 2>/dev/null || echo '')
CURRENT_GID=$(stat -c '%g' "$APP_DATA_DIR_ABS" 2>/dev/null || echo '')

if [[ "$CURRENT_UID" != "$TARGET_UID" || "$CURRENT_GID" != "$TARGET_GID" ]]; then
  chown -R "$TARGET_UID:$TARGET_GID" "$APP_DATA_DIR_ABS" 2>/dev/null || true
fi
