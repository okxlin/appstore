#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
if [[ "$ENV_FILE" != /* ]]; then
  ENV_FILE="$ROOT_DIR/${ENV_FILE#./}"
fi

if [[ ! -e "$ENV_FILE" ]]; then
  echo "$ENV_FILE not found; skipped port variable migration"
  exit 0
fi
[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || {
  echo "unsafe ENV_FILE path" >&2
  exit 1
}

trim_env_value() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  if [[ "$value" == \"*\" && "$value" == *\" ]]; then
    value="${value:1:${#value}-2}"
  elif [[ "$value" == \'*\' && "$value" == *\' ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s' "$value"
}

env_key_present() {
  local key="$1"
  grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$ENV_FILE"
}

read_env_value() {
  local key="$1" line
  line="$(grep -E "^[[:space:]]*${key}[[:space:]]*=" "$ENV_FILE" | tail -n 1 || true)"
  [[ -n "$line" ]] || return 0
  trim_env_value "${line#*=}"
}

set_env_value() {
  local key="$1" value="$2" temp_file
  if env_key_present "$key"; then
    temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
    if ! awk -v key="$key" -v value="$value" '
      BEGIN { pattern = "^[[:space:]]*" key "[[:space:]]*=" }
      $0 ~ pattern { print key "=" value; next }
      { print }
    ' "$ENV_FILE" > "$temp_file"; then
      rm -f -- "$temp_file"
      return 1
    fi
    chmod --reference="$ENV_FILE" "$temp_file" 2>/dev/null || true
    mv -- "$temp_file" "$ENV_FILE"
  else
    printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  fi
}

valid_port() {
  local value="$1" port
  [[ "$value" =~ ^[0-9]+$ ]] || return 1
  port=$((10#$value))
  (( port >= 1 && port <= 65535 ))
}

migrate_port() {
  local old_key="$1" new_key="$2" default_value="$3"
  local old_value new_value selected
  old_value="$(read_env_value "$old_key")"
  new_value="$(read_env_value "$new_key")"

  if [[ -n "$new_value" ]]; then
    valid_port "$new_value" || {
      echo "$new_key must be a valid TCP port" >&2
      exit 1
    }
    echo "$new_key preserved"
    return
  fi

  if [[ -n "$old_value" ]]; then
    valid_port "$old_value" || {
      echo "$old_key must be a valid TCP port before migration" >&2
      exit 1
    }
    selected="$old_value"
    echo "Migrating $old_key to $new_key"
  else
    selected="$default_value"
    echo "Setting default $new_key"
  fi
  set_env_value "$new_key" "$selected"
}

migrate_port CLI_PROXY_PORT_8085 PANEL_APP_PORT_8085 8085
migrate_port CLI_PROXY_PORT_1455 PANEL_APP_PORT_1455 1455
migrate_port CLI_PROXY_PORT_54545 PANEL_APP_PORT_54545 54545
migrate_port CLI_PROXY_PORT_51121 PANEL_APP_PORT_51121 51121
migrate_port CLI_PROXY_PORT_11451 PANEL_APP_PORT_11451 11451
