#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

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
  local value="${!key:-}"
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

data_raw="$(configured_value APP_DATA_DIR ./data)"
pairing_ttl="$(configured_value PAIRING_TTL_SECONDS 86400)"

[[ -n "$data_raw" && "$data_raw" != /* && "$data_raw" =~ ^[A-Za-z0-9._/-]+$ ]] || {
  printf '%s\n' 'APP_DATA_DIR must be a non-empty relative path using only letters, digits, dots, underscores, hyphens, and slashes' >&2
  exit 1
}
APP_DATA_DIR="$data_raw"
data_dir="$(resolve_app_path APP_DATA_DIR "$APP_DATA_DIR")"

if [[ ! "$pairing_ttl" =~ ^[0-9]+$ ]] || ((10#$pairing_ttl < 300 || 10#$pairing_ttl > 86400)); then
  printf '%s\n' 'PAIRING_TTL_SECONDS must be an integer from 300 through 86400' >&2
  exit 1
fi

install -d -m 0750 -- "$data_dir"
[[ "$(resolve_app_path APP_DATA_DIR "$APP_DATA_DIR")" == "$data_dir" ]] || {
  printf '%s\n' 'APP_DATA_DIR changed during initialization' >&2
  exit 1
}
data_dir="$(realpath -e -- "$data_dir")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *)
    printf '%s\n' 'APP_DATA_DIR resolves outside the application version directory' >&2
    exit 1
    ;;
esac
