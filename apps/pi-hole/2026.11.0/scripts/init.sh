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
bind_address="$(configured_value DNS_BIND_ADDRESS 0.0.0.0)"
admin_password="$(configured_value ADMIN_PASSWORD '')"
timezone="$(configured_value TZ Etc/UTC)"

[[ -n "$data_raw" && "$data_raw" != /* ]] || {
  printf '%s\n' 'APP_DATA_DIR must be a non-empty relative path' >&2
  exit 1
}
data_dir="$(resolve_app_path APP_DATA_DIR "$data_raw")"

IFS=. read -r octet1 octet2 octet3 octet4 extra <<<"$bind_address"
[[ -z "${extra:-}" && -n "${octet4:-}" ]] || {
  printf '%s\n' 'DNS_BIND_ADDRESS must be a complete IPv4 address' >&2
  exit 1
}
for octet in "$octet1" "$octet2" "$octet3" "$octet4"; do
  [[ "$octet" =~ ^[0-9]{1,3}$ ]] || {
    printf '%s\n' 'DNS_BIND_ADDRESS must be a valid IPv4 address' >&2
    exit 1
  }
  ((10#$octet <= 255)) || {
    printf '%s\n' 'DNS_BIND_ADDRESS must be a valid IPv4 address' >&2
    exit 1
  }
done

[[ "$admin_password" =~ ^[[:graph:]]{16,256}$ ]] || {
  printf '%s\n' 'ADMIN_PASSWORD must contain 16 to 256 printable ASCII characters without spaces' >&2
  exit 1
}
[[ "$timezone" =~ ^[A-Za-z0-9_+.-]+(/[A-Za-z0-9_+.-]+)*$ ]] || {
  printf '%s\n' 'TZ contains unsupported characters' >&2
  exit 1
}

install -d -m 0750 "$data_dir"
data_dir="$(realpath -e -- "$data_dir")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *)
    printf '%s\n' 'APP_DATA_DIR resolves outside the application version directory' >&2
    exit 1
    ;;
esac
