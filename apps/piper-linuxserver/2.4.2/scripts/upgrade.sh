#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
if [[ "$ENV_FILE" != /* ]]; then
  ENV_FILE="$ROOT_DIR/${ENV_FILE#./}"
fi

read_env_value() {
  local key="$1" line value
  line="$(grep -E "^[[:space:]]*${key}[[:space:]]*=" "$ENV_FILE" | tail -n 1 || true)"
  [[ -n "$line" ]] || return 0
  value="${line#*=}"
  value="${value#\"}"
  value="${value%\"}"
  value="${value#\'}"
  value="${value%\'}"
  value="${value#${value%%[![:space:]]*}}"
  value="${value%${value##*[![:space:]]}}"
  printf '%s' "$value"
}

set_env_value() {
  local key="$1" value="$2" temp_file
  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  if ! awk -v key="$key" -v value="$value" '
    BEGIN { written = 0; pattern = "^[[:space:]]*" key "[[:space:]]*=" }
    $0 ~ pattern {
      if (!written) {
        print key "=" value
        written = 1
      }
      next
    }
    { print }
    END { if (!written) print key "=" value }
  ' "$ENV_FILE" > "$temp_file"; then
    rm -f -- "$temp_file"
    return 1
  fi
  chmod --reference="$ENV_FILE" "$temp_file" 2>/dev/null || true
  mv -- "$temp_file" "$ENV_FILE"
}

ensure_env_default() {
  local key="$1"
  local value="$2"

  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped $key migration"
    return
  fi

  if grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$ENV_FILE"; then
    echo "$key already exists"
    return
  fi

  set_env_value "$key" "$value"
  echo "Added $key"
}

ensure_env_nonempty_default() {
  local key="$1"
  local value="$2"
  local current

  current="$(read_env_value "$key")"
  if [[ -n "$current" ]]; then
    echo "$key preserved"
    return
  fi

  set_env_value "$key" "$value"
  echo "Set default $key=$value"
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_nonempty_default "CONFIG_PATH" "./data/config"
  ensure_env_default "LOCAL_ONLY" ""
  ensure_env_default "PIPER_LENGTH" "1.0"
  ensure_env_default "PIPER_NOISE" "0.667"
  ensure_env_default "PIPER_NOISEW" "0.333"
  ensure_env_default "PIPER_SPEAKER" "0"
  ensure_env_default "NO_STREAMING" ""
else
  echo "$ENV_FILE not found; skipped LinuxServer environment migration"
fi
