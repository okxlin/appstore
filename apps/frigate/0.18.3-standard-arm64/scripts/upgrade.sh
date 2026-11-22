#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"

read_env_value() {
  local key="$1"
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  value="${value%\"}"
  value="${value#\"}"
  value="${value%'}"
  value="${value#'}"
  printf '%s\n' "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  if grep -qE "^${key}=" "$ENV_FILE"; then
    sed -i -E "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
  else
    printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  fi
}

migrate_port() {
  local old_key="$1"
  local new_key="$2"
  local old_value

  if ! grep -qE "^${old_key}=" "$ENV_FILE"; then
    return
  fi
  old_value="$(read_env_value "$old_key")"
  if [[ -z "$old_value" ]]; then
    sed -i -E "/^${old_key}=/d" "$ENV_FILE"
    return
  fi
  if [[ ! "$old_value" =~ ^[0-9]{1,5}$ ]] || (( 10#$old_value < 1 || 10#$old_value > 65535 )); then
    printf 'Keeping legacy %s because it is not a valid port\n' "$old_key" >&2
    return
  fi
  # The old field is the only saved user choice under the previous form schema.
  set_env_value "$new_key" "$old_value"
  sed -i -E "/^${old_key}=/d" "$ENV_FILE"
}

if [[ ! -f "$ENV_FILE" ]]; then
  printf '%s not found; skipped legacy port migration\n' "$ENV_FILE"
  exit 0
fi

# 1Panel may write .env without a trailing newline. Keep appended migrated
# fields on their own lines so Compose reads each value independently.
if [[ -s "$ENV_FILE" ]] && [[ "$(tail -c 1 "$ENV_FILE" | wc -l)" -eq 0 ]]; then
  printf '\n' >> "$ENV_FILE"
fi

migrate_port RTSP_PORT PANEL_APP_PORT_RTSP
migrate_port WEBRTC_TCP_PORT PANEL_APP_PORT_WEBRTC_TCP
migrate_port WEBRTC_UDP_PORT PANEL_APP_PORT_WEBRTC_UDP
