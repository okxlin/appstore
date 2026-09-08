#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
TEMPLATE_DIR="${ROOT_DIR}/site-template"

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

[[ -d "$TEMPLATE_DIR" ]] || fail "Starter template directory not found: ${TEMPLATE_DIR}"

DATA_DIR_RAW="$(configured_value APP_DATA_DIR ./data)"
DATA_DIR_ABS="$(resolve_app_path APP_DATA_DIR "$DATA_DIR_RAW")"
install -d -m 0750 -- "$DATA_DIR_ABS"
if [[ "$(id -u)" -eq 0 ]]; then
  chown 1000:1000 -- "$DATA_DIR_ABS"
fi
[[ "$(stat -c '%u:%g' "$DATA_DIR_ABS")" == "1000:1000" ]] || \
  fail "APP_DATA_DIR must be owned by UID/GID 1000:1000"

for source_file in "${TEMPLATE_DIR}"/*.sql; do
  target_file="${DATA_DIR_ABS}/${source_file##*/}"
  [[ ! -L "$target_file" ]] || fail "Starter target must not be a symbolic link: ${target_file}"
  if [[ -e "$target_file" ]]; then
    [[ -f "$target_file" ]] || fail "Starter target must be a regular file: ${target_file}"
    continue
  fi
  install -m 0644 -- "$source_file" "$target_file"
  if [[ "$(id -u)" -eq 0 ]]; then
    chown 1000:1000 -- "$target_file"
  fi
done
