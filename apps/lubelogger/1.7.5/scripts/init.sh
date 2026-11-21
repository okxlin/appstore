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
  local value="${!key:-}"
  if [[ -z "$value" ]]; then
    value="$(read_env_value "$key")"
  fi
  printf '%s\n' "${value:-$default_value}"
}

reject_control_characters() {
  local name="$1"
  local value="$2"
  if [[ "$value" == *$'\n'* || "$value" == *$'\r'* ]]; then
    printf '%s must not contain line breaks\n' "$name" >&2
    exit 1
  fi
}

prepare_lubelogger() {
  local raw path username password username_hash password_hash auth_file temp_file

  raw="$(configured_value APP_DATA_DIR ./data)"
  username="$(configured_value LUBELOGGER_ROOT_USERNAME admin)"
  password="$(configured_value LUBELOGGER_ROOT_PASSWORD '')"

  [[ -n "$raw" ]] || {
    printf '%s\n' 'APP_DATA_DIR must not be empty' >&2
    exit 1
  }
  if [[ "$raw" = /* ]]; then
    printf '%s\n' 'APP_DATA_DIR must be relative to the application version directory' >&2
    exit 1
  fi

  path="$(realpath -m -- "$ROOT_DIR/${raw#./}")"
  case "$path" in
    "$ROOT_DIR"/*) ;;
    *)
      printf '%s\n' 'APP_DATA_DIR must remain inside the application version directory' >&2
      exit 1
      ;;
  esac

  install -d -m 0750 "$path"
  path="$(realpath -e -- "$path")"
  case "$path" in
    "$ROOT_DIR"/*) ;;
    *)
      printf '%s\n' 'APP_DATA_DIR resolves outside the application version directory' >&2
      exit 1
      ;;
  esac

  [[ -n "$username" && ${#username} -le 128 ]] || {
    printf '%s\n' 'LUBELOGGER_ROOT_USERNAME must contain 1 to 128 characters' >&2
    exit 1
  }
  [[ ${#password} -ge 12 && ${#password} -le 256 ]] || {
    printf '%s\n' 'LUBELOGGER_ROOT_PASSWORD must contain 12 to 256 characters' >&2
    exit 1
  }
  reject_control_characters LUBELOGGER_ROOT_USERNAME "$username"
  reject_control_characters LUBELOGGER_ROOT_PASSWORD "$password"

  username_hash="$(printf '%s' "$username" | sha256sum | cut -d ' ' -f 1)"
  password_hash="$(printf '%s' "$password" | sha256sum | cut -d ' ' -f 1)"
  [[ "$username_hash" =~ ^[0-9a-f]{64}$ && "$password_hash" =~ ^[0-9a-f]{64}$ ]] || {
    printf '%s\n' 'Failed to generate LubeLogger credential hashes' >&2
    exit 1
  }

  auth_file="$path/.lubelogger-auth.env"
  if [[ -L "$auth_file" ]]; then
    printf '%s\n' 'LubeLogger authentication file must not be a symbolic link' >&2
    exit 1
  fi
  if [[ -e "$auth_file" && ! -f "$auth_file" ]]; then
    printf '%s\n' 'LubeLogger authentication path must be a regular file' >&2
    exit 1
  fi

  umask 077
  temp_file="$(mktemp "$path/.lubelogger-auth.env.tmp.XXXXXX")"
  trap 'rm -f -- "${temp_file:-}"' EXIT
  printf '%s\n' \
    'EnableAuth=true' \
    "UserNameHash=$username_hash" \
    "UserPasswordHash=$password_hash" \
    'DisableRegistration=true' \
    'LUBELOGGER_OPEN_REGISTRATION=false' >"$temp_file"
  chmod 0600 "$temp_file"
  chown 1000:1000 "$temp_file"
  mv -f -- "$temp_file" "$auth_file"
  trap - EXIT

  chown 1000:1000 "$path"
  chmod 0750 "$path"
  [[ "$(stat -c '%a' -- "$auth_file")" = 600 ]] || {
    printf '%s\n' 'LubeLogger authentication file permissions must be 0600' >&2
    exit 1
  }
}

prepare_lubelogger
