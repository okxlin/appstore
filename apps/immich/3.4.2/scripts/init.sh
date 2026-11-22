#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

resolve_env_file() {
  local raw="$1" candidate resolved
  case "$raw" in
    /*) candidate="$raw" ;;
    *) candidate="$ROOT_DIR/${raw#./}" ;;
  esac
  resolved="$(realpath -m -- "$candidate")"
  case "$resolved" in
    "$ROOT_DIR"/*) ;;
    *) echo "unsafe ENV_FILE path" >&2; return 1 ;;
  esac
  if [[ -e "$resolved" || -L "$resolved" ]]; then
    [[ -f "$resolved" && ! -L "$resolved" ]] || { echo "unsafe ENV_FILE path" >&2; return 1; }
  fi
  printf '%s\n' "$resolved"
}

ENV_FILE="$(resolve_env_file "$ENV_FILE")"

read_env_value() {
  local key="$1"
  local value="${!key:-}"
  if [[ -z "$value" && -f "$ENV_FILE" ]]; then
    value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
    case "$value" in
      \"*\") value="${value#\"}"; value="${value%\"}" ;;
      \'*\') value="${value#\'}"; value="${value%\'}" ;;
    esac
  fi
  printf '%s\n' "$value"
}

resolve_app_path() {
  local key="$1" raw="$2" clean candidate resolved current part
  local -a parts=()
  case "$raw" in
    ""|/*|.|..|../*|*/../*|*/..) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  [[ ! "$raw" =~ [[:cntrl:]] ]] || { echo "unsafe ${key} path" >&2; return 1; }
  clean="${raw#./}"
  [[ -n "$clean" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  candidate="$ROOT_DIR/$clean"
  resolved="$(realpath -m -- "$candidate")"
  case "$resolved" in
    "$ROOT_DIR"/*) ;;
    *) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  current="$ROOT_DIR"
  IFS='/' read -r -a parts <<< "$clean"
  for part in "${parts[@]}"; do
    [[ -z "$part" || "$part" == "." ]] && continue
    current="$current/$part"
    [[ ! -L "$current" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  done
  printf '%s\n' "$resolved"
}

configured_value() {
  local key="$1" default_value="$2" value
  value="$(read_env_value "$key")"
  printf '%s\n' "${value:-$default_value}"
}

ensure_dir() {
  local key="$1" default_value="$2" raw path
  raw="$(configured_value "$key" "$default_value")"
  path="$(resolve_app_path "$key" "$raw")"
  mkdir -p -- "$path"
  [[ "$(resolve_app_path "$key" "$raw")" == "$path" ]] || { echo "unsafe ${key} path" >&2; return 1; }
}

ensure_dir UPLOAD_LOCATION ./data/upload
ensure_dir CACHE_PATH ./data/cache
ensure_dir DB_PATH ./data/data
