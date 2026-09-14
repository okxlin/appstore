#!/usr/bin/env bash
set -euo pipefail

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  [[ -f "$ENV_FILE" ]] || return 0
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

configured_value() {
  local key="$1"
  local default_value="$2"
  local value
  value="${!key:-}"
  if [[ -z "$value" ]]; then
    value="$(read_env_value "$key")"
  fi
  printf '%s\n' "${value:-$default_value}"
}

resolve_app_path() {
  local key="$1"
  local raw="$2"
  local clean candidate resolved current part
  local -a parts=()
  case "$raw" in
    ""|/*|.|..|../*|*/../*|*/..) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  if [[ "$raw" =~ [[:cntrl:]] ]]; then
    echo "unsafe ${key} path" >&2
    return 1
  fi
  clean="${raw#./}"
  [[ -n "$clean" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  command -v realpath >/dev/null 2>&1 || { echo "realpath is required" >&2; return 1; }
  candidate="$ROOT_DIR/$clean"
  resolved="$(realpath -m -- "$candidate")" || { echo "unsafe ${key} path" >&2; return 1; }
  case "$resolved" in
    "$ROOT_DIR"/*) ;;
    *) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  current="$ROOT_DIR"
  IFS='/' read -r -a parts <<< "$clean"
  for part in "${parts[@]}"; do
    [[ -z "$part" || "$part" == "." ]] && continue
    current="$current/$part"
    if [[ -L "$current" ]]; then
      echo "unsafe ${key} path" >&2
      return 1
    fi
  done
  printf '%s\n' "$resolved"
}

APP_DATA_DIR_VALUE="$(configured_value APP_DATA_DIR './data/app')"
DATA_DIR="$(resolve_app_path APP_DATA_DIR "$APP_DATA_DIR_VALUE")"

cd -- "$DATA_DIR" || fail "unable to access application data directory"
[[ -f resources.db ]] || exit 0
command -v sqlite3 >/dev/null 2>&1 || fail "sqlite3 is required to upgrade the application database"

resource_table="$(sqlite3 -noheader resources.db "SELECT name FROM sqlite_master WHERE type='table' AND name='resources';")"
[[ "$resource_table" == "resources" ]] || exit 0

resource_columns="$(sqlite3 -noheader resources.db 'PRAGMA table_info(resources);')"
if ! printf '%s\n' "$resource_columns" | awk -F'|' '$2 == "taken" { found=1 } END { exit(found ? 0 : 1) }'; then
  sqlite3 resources.db <<'SQL'
.timeout 30000
BEGIN IMMEDIATE;
ALTER TABLE resources ADD COLUMN taken TEXT;
COMMIT;
SQL
fi
