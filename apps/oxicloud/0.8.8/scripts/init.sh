#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

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

resolve_direct_child() {
  local key="$1"
  local raw="$2"
  local clean path
  clean="${raw#./}"
  if [[ -z "$clean" || "$clean" == */* ]]; then
    echo "unsafe ${key} path: lifecycle directories must be direct children of the version root" >&2
    return 1
  fi
  path="$(resolve_app_path "$key" "$raw")"
  [[ "$path" == "$ROOT_DIR/$clean" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  printf '%s\n' "$path"
}

verify_trusted_root_chain() {
  local current owner mode
  [[ "$(id -u)" == "0" ]] || { echo "directory ownership initialization must run as root" >&2; return 1; }
  command -v stat >/dev/null 2>&1 || { echo "stat is required" >&2; return 1; }
  current="$ROOT_DIR"
  while [[ "$current" != "/" ]]; do
    [[ -d "$current" && ! -L "$current" ]] || { echo "unsafe version root chain: $current" >&2; return 1; }
    IFS=':' read -r owner mode < <(stat -c '%u:%a' -- "$current")
    [[ "$owner" == "0" ]] || { echo "unsafe version root chain owner: $current" >&2; return 1; }
    [[ "$mode" =~ ^[0-7]{3,4}$ ]] || { echo "unsafe version root chain mode: $current" >&2; return 1; }
    (( (8#$mode & 0022) == 0 )) || { echo "unsafe version root chain permissions: $current" >&2; return 1; }
    current="$(dirname -- "$current")"
  done
}

ensure_dir() {
  local key="$1"
  local raw
  local path
  raw="$(configured_value "$key" "$2")"
  path="$(resolve_app_path "$key" "$raw")"
  mkdir -p -- "$path"
  [[ "$(resolve_app_path "$key" "$raw")" == "$path" ]] || { echo "unsafe ${key} path" >&2; return 1; }
}

ensure_dir "APP_DATA_DIR" "./data"
