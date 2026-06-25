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
  ensure_env_default "ALLOWED_HOSTS" ""
  ensure_env_default "APPRISE_ENABLED" "False"
  ensure_env_default "CSRF_TRUSTED_ORIGINS" ""
  ensure_env_default "HEALTHCHECKS_DEBUG" "True"
  ensure_env_default "PING_EMAIL_DOMAIN" ""
  ensure_env_default "RP_ID" ""
  ensure_env_default "SITE_LOGO_URL" ""
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
