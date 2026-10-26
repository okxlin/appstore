#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

ensure_env_default() {
  local key="$1"
  local value="$2"

  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped $key migration"
    return
  fi

  if grep -qE "^${key}=" "$ENV_FILE"; then
    echo "$key already exists"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added $key"
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_default "ALLOW_START" "0"
  ensure_env_default "ALLOW_STOP" "0"
  ensure_env_default "ALLOW_RESTARTS" "0"
  ensure_env_default "ALLOW_PAUSE" "0"
  ensure_env_default "ALLOW_UNPAUSE" "0"
  ensure_env_default "AUTH" "0"
  ensure_env_default "BUILD" "0"
  ensure_env_default "COMMIT" "0"
  ensure_env_default "CONFIGS" "0"
  ensure_env_default "DISABLE_IPV6" "0"
  ensure_env_default "DISTRIBUTION" "0"
  ensure_env_default "EVENTS" "1"
  ensure_env_default "EXEC" "0"
  ensure_env_default "INFO" "0"
  ensure_env_default "NODES" "0"
  ensure_env_default "PING" "1"
  ensure_env_default "PLUGINS" "0"
  ensure_env_default "SECRETS" "0"
  ensure_env_default "SERVICES" "0"
  ensure_env_default "SESSION" "0"
  ensure_env_default "SWARM" "0"
  ensure_env_default "SYSTEM" "0"
  ensure_env_default "TASKS" "0"
  ensure_env_default "VERSION" "1"
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
