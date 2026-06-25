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
  ensure_env_default "PIPER_LENGTH" "1.0"
  ensure_env_default "PIPER_NOISE" "0.667"
  ensure_env_default "PIPER_NOISEW" "0.333"
  ensure_env_default "PIPER_SPEAKER" "0"
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
