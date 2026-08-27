#!/usr/bin/env bash
set -euo pipefail

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

ensure_dir() {
  local key="$1"
  local raw
  local path
  raw="$(configured_value "$key" "$2")"
  path="$(resolve_app_path "$key" "$raw")"
  mkdir -p -- "$path"
  [[ "$(resolve_app_path "$key" "$raw")" == "$path" ]] || { echo "unsafe ${key} path" >&2; return 1; }
}

ensure_dir "APP_DATA_DIR_1" "./data/workspace"
ensure_dir "APP_DATA_DIR_2" "./data/home-config"
ensure_dir "APP_DATA_DIR_3" "./data/home-share"
ensure_dir "APP_DATA_DIR_4" "./data/home-agents"
ensure_dir "APP_DATA_DIR_5" "./data/home-claude"
ensure_dir "APP_DATA_DIR_6" "./data/home-opencode"

CUSTOM_ENV_FILE_RAW="$(configured_value "CUSTOM_ENV_FILE" "./data/custom.env")"
CUSTOM_ENV_FILE_ABS="$(resolve_app_path "CUSTOM_ENV_FILE" "$CUSTOM_ENV_FILE_RAW")"
mkdir -p -- "$(dirname -- "$CUSTOM_ENV_FILE_ABS")"
touch -- "$CUSTOM_ENV_FILE_ABS"

echo '[opencode-workstation:init] initialized persistent directories:'
echo "  $(resolve_app_path APP_DATA_DIR_1 "$(configured_value APP_DATA_DIR_1 "./data/workspace")") -> /workspace"
echo "  $(resolve_app_path APP_DATA_DIR_2 "$(configured_value APP_DATA_DIR_2 "./data/home-config")") -> /home/opencode/.config"
echo "  $(resolve_app_path APP_DATA_DIR_3 "$(configured_value APP_DATA_DIR_3 "./data/home-share")") -> /home/opencode/.local/share"
echo "  $(resolve_app_path APP_DATA_DIR_4 "$(configured_value APP_DATA_DIR_4 "./data/home-agents")") -> /home/opencode/.agents"
echo "  $(resolve_app_path APP_DATA_DIR_5 "$(configured_value APP_DATA_DIR_5 "./data/home-claude")") -> /home/opencode/.claude"
echo "  $(resolve_app_path APP_DATA_DIR_6 "$(configured_value APP_DATA_DIR_6 "./data/home-opencode")") -> /home/opencode/.opencode"
echo "  ${CUSTOM_ENV_FILE_ABS} -> custom env_file"
echo '[opencode-workstation:init] default serve address: http://0.0.0.0:4096'
echo '[opencode-workstation:init] ACP port: 8765'
