#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  local value=""
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

effective_value() {
  local key="$1"
  if [[ -v "$key" ]]; then
    printf '%s\n' "${!key}"
  else
    read_env_value "$key"
  fi
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must be a regular file"

password_hash="$(effective_value SIMON_PASSWORD_HASH)"
data_raw="$(effective_value APP_DATA_DIR)"

[[ "$password_hash" =~ ^\$2[aby]\$[0-9]{2}\$[./A-Za-z0-9]{53}$ ]] || fail "SIMON_PASSWORD_HASH must be a valid bcrypt hash"
[[ -n "$data_raw" && ! "$data_raw" =~ [[:cntrl:]\`\$] ]] || fail "APP_DATA_DIR is invalid"

if [[ "$data_raw" == /* ]]; then
  data_dir="$(realpath -m -- "$data_raw")"
else
  data_dir="$(realpath -m -- "${ROOT_DIR}/${data_raw#./}")"
  case "$data_dir" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_DATA_DIR must stay inside the application version directory" ;;
  esac
fi
case "$data_dir" in
  / | /bin | /boot | /dev | /etc | /home | /lib | /lib64 | /opt | /proc | /root | /run | /sbin | /srv | /sys | /tmp | /usr | /var | /workspace)
    fail "APP_DATA_DIR must be a dedicated subdirectory"
    ;;
esac
[[ ! -L "$data_dir" ]] || fail "APP_DATA_DIR must not be a symbolic link"
[[ ! -e "$data_dir" || -d "$data_dir" ]] || fail "APP_DATA_DIR must be a directory"
install -d -m 0750 -- "$data_dir"

[[ -d /sys ]] || fail "/sys is required for host metrics"
[[ -S /var/run/docker.sock ]] || fail "/var/run/docker.sock is required for Docker monitoring"
