#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  [ -f "$ENV_FILE" ] || return 0
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  value="${value%\"}"
  value="${value#\"}"
  value="${value%\'}"
  value="${value#\'}"
  printf '%s\n' "$value"
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

APP_DATA_DIR_RAW="${APP_DATA_DIR:-$(read_env_value APP_DATA_DIR)}"
APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW:-./data}"
bash "$SCRIPT_DIR/init.sh"

# MDCz 0.14.0 replays the migration that creates this index. The 0.12.0
# database already contains the same uniquely-defined index, so remove only
# that redundant schema object before the image migration recreates it.
DB_PATH_RAW="${APP_DATA_DIR_RAW%/}/data/mdcz.sqlite"
DB_PATH="$(resolve_app_path DB_PATH "$DB_PATH_RAW")"

if [[ -e "$DB_PATH" ]]; then
  [[ -f "$DB_PATH" ]] || fail "database path is not a regular file"
  if command -v sqlite3 >/dev/null 2>&1; then
    sqlite3 "$DB_PATH" 'DROP INDEX IF EXISTS "scan_results_task_root_path_idx";'
  fi
fi
