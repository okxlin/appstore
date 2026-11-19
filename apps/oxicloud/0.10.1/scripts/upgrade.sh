#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
if [[ "$ENV_FILE" != /* ]]; then
  ENV_FILE="$ROOT_DIR/${ENV_FILE#./}"
fi

if [[ -e "$ENV_FILE" ]]; then
  [[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || {
    echo "unsafe ENV_FILE path" >&2
    exit 1
  }

  read_env_value() {
    local value
    value="$(grep -E '^[[:space:]]*APP_DATA_DIR[[:space:]]*=' "$ENV_FILE" | tail -n 1 | sed 's/^[^=]*=//' || true)"
    value="${value#\"}"
    value="${value%\"}"
    value="${value#\'}"
    value="${value%\'}"
    value="${value#${value%%[![:space:]]*}}"
    value="${value%${value##*[![:space:]]}}"
    printf '%s' "$value"
  }

  app_data_dir="$(read_env_value)"
  if [[ -z "$app_data_dir" ]]; then
    temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
    if ! awk '
      BEGIN { written = 0 }
      /^[[:space:]]*APP_DATA_DIR[[:space:]]*=/ {
        if (!written) {
          print "APP_DATA_DIR=./data"
          written = 1
        }
        next
      }
      { print }
      END {
        if (!written) print "APP_DATA_DIR=./data"
      }
    ' "$ENV_FILE" > "$temp_file"; then
      rm -f -- "$temp_file"
      exit 1
    fi
    chmod --reference="$ENV_FILE" "$temp_file" 2>/dev/null || true
    mv -- "$temp_file" "$ENV_FILE"
    echo "Set default APP_DATA_DIR=./data"
  else
    echo "APP_DATA_DIR preserved"
  fi
else
  echo "$ENV_FILE not found; skipped APP_DATA_DIR migration"
fi

export ENV_FILE
exec bash "${SCRIPT_DIR}/init.sh"
