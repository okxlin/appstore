#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
DOKKU_DATA_DIR=/var/lib/dokku

read_legacy_data_dir() {
  [[ -f "$ENV_FILE" ]] || return 0

  local line value=''
  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      APP_DATA_DIR=*) value="${line#APP_DATA_DIR=}" ;;
    esac
  done < "$ENV_FILE"
  [[ "$value" != *$'\n'* && "$value" != *$'\r'* ]] || {
    echo "Invalid APP_DATA_DIR value in $ENV_FILE" >&2
    return 1
  }
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

legacy_data_dir="${APP_DATA_DIR:-$(read_legacy_data_dir)}"
if [[ -n "$legacy_data_dir" && "$legacy_data_dir" != "$DOKKU_DATA_DIR" ]]; then
  cat >&2 <<EOF
Dokku upgrade stopped: this installation uses legacy APP_DATA_DIR=$legacy_data_dir.
Dokku's official container contract requires the host path $DOKKU_DATA_DIR.
Back up and migrate the complete legacy directory to $DOKKU_DATA_DIR, then set the current 1Panel app's Data Directory to $DOKKU_DATA_DIR before retrying the upgrade.
No application data was moved automatically.
EOF
  exit 1
fi

if [[ -L "$DOKKU_DATA_DIR" ]]; then
  echo "Refusing to use symbolic link as Dokku data directory: $DOKKU_DATA_DIR" >&2
  exit 1
fi

mkdir -p -- "$DOKKU_DATA_DIR"
