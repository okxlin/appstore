#!/usr/bin/env bash
# upgrade.sh - opencode-workstation 1Panel upgrade helper
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

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

get_env_value() {
  local key="$1"
  local default="$2"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
  fi

  if [[ -n "$value" ]]; then
    printf '%s\n' "$value"
  else
    printf '%s\n' "$default"
  fi
}

ensure_env_default() {
  local key="$1"
  local value="$2"

  if grep -qE "^${key}=" "$ENV_FILE"; then
    echo "${key} already exists"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added ${key}=${value}"
}

if [[ -f "$ENV_FILE" ]]; then
  ensure_env_default "CUSTOM_ENV_FILE" "./data/custom.env"
else
  echo "${ENV_FILE} not found; skipped environment migration"
fi

custom_env_file_raw="$(get_env_value "CUSTOM_ENV_FILE" "./data/custom.env")"
custom_env_file="$(resolve_app_path "CUSTOM_ENV_FILE" "$custom_env_file_raw")"
mkdir -p -- "$(dirname -- "$custom_env_file")"
touch -- "$custom_env_file"
echo "Ensured custom env file: ${custom_env_file}"

echo "OpenCode Workstation upgrade migration completed."
