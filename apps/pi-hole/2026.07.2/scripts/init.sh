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

data_raw="$(configured_value APP_DATA_DIR ./data)"
bind_address="$(configured_value DNS_BIND_ADDRESS 0.0.0.0)"
admin_password="$(configured_value ADMIN_PASSWORD '')"
timezone="$(configured_value TZ Etc/UTC)"

[[ -n "$data_raw" && "$data_raw" != /* ]] || {
  printf '%s\n' 'APP_DATA_DIR must be a non-empty relative path' >&2
  exit 1
}
data_dir="$(realpath -m -- "$ROOT_DIR/${data_raw#./}")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *)
    printf '%s\n' 'APP_DATA_DIR must remain inside the application version directory' >&2
    exit 1
    ;;
esac

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
