#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
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
MEDIA_DIR_RAW="${MEDIA_DIR:-$(read_env_value MEDIA_DIR)}"
APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW:-./data}"
MEDIA_DIR_RAW="${MEDIA_DIR_RAW:-./data/media}"

DATA_DIR="$(resolve_app_path APP_DATA_DIR "$APP_DATA_DIR_RAW")"

mkdir -p -- "$DATA_DIR"
DATA_DIR="$(resolve_app_path APP_DATA_DIR "$APP_DATA_DIR_RAW")"
chown 1000:1000 "$DATA_DIR"
chmod 755 "$DATA_DIR"

if test "${MEDIA_DIR_RAW:0:1}" = "/"; then
  test "$MEDIA_DIR_RAW" != "/" && test -d "$MEDIA_DIR_RAW" || fail "MEDIA_DIR must be an existing non-root directory"
  realpath -e -- "$MEDIA_DIR_RAW" >/dev/null || fail "MEDIA_DIR must be an existing directory"
else
  MEDIA_DIR_RESOLVED="$(resolve_app_path MEDIA_DIR "$MEDIA_DIR_RAW")"
  mkdir -p -- "$MEDIA_DIR_RESOLVED"
  MEDIA_DIR_RESOLVED="$(resolve_app_path MEDIA_DIR "$MEDIA_DIR_RAW")"
  chown 1000:1000 "$MEDIA_DIR_RESOLVED"
  chmod 755 "$MEDIA_DIR_RESOLVED"
fi
