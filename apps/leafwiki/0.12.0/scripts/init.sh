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

prepare_data_dir() {
  local raw path secrets_file temp_file jwt_secret totp_key
  raw="$(configured_value APP_DATA_DIR ./data)"

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
  chmod 0750 "$path"
  chown -R --no-dereference 1000:1000 "$path"

  secrets_file="$path/.leafwiki-secrets.env"
  if [[ -L "$secrets_file" ]]; then
    printf '%s\n' 'LeafWiki secrets file must not be a symbolic link' >&2
    exit 1
  fi
  if [[ ! -e "$secrets_file" ]]; then
    umask 077
    jwt_secret="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
    totp_key="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
    [[ ${#jwt_secret} -eq 64 && ${#totp_key} -eq 64 ]] || {
      printf '%s\n' 'Failed to generate LeafWiki secrets' >&2
      exit 1
    }
    temp_file="$(mktemp "$path/.leafwiki-secrets.env.tmp.XXXXXX")"
    trap 'rm -f -- "${temp_file:-}"' EXIT
    printf 'LEAFWIKI_JWT_SECRET=%s\nLEAFWIKI_TOTP_ENCRYPTION_KEY=%s\n' \
      "$jwt_secret" "$totp_key" >"$temp_file"
    chmod 0600 "$temp_file"
    chown 1000:1000 "$temp_file"
    mv -f -- "$temp_file" "$secrets_file"
    trap - EXIT
  fi
  [[ -f "$secrets_file" ]] || {
    printf '%s\n' 'LeafWiki secrets path must be a regular file' >&2
    exit 1
  }
  [[ "$(grep -c '^LEAFWIKI_JWT_SECRET=' "$secrets_file")" -eq 1 ]] || {
    printf '%s\n' 'LeafWiki secrets file must contain exactly one JWT secret' >&2
    exit 1
  }
  [[ "$(grep -c '^LEAFWIKI_TOTP_ENCRYPTION_KEY=' "$secrets_file")" -eq 1 ]] || {
    printf '%s\n' 'LeafWiki secrets file must contain exactly one TOTP encryption key' >&2
    exit 1
  }
  jwt_secret="$(sed -n 's/^LEAFWIKI_JWT_SECRET=//p' "$secrets_file")"
  totp_key="$(sed -n 's/^LEAFWIKI_TOTP_ENCRYPTION_KEY=//p' "$secrets_file")"
  [[ "$jwt_secret" =~ ^[0-9a-f]{64}$ ]] || {
    printf '%s\n' 'LeafWiki JWT secret must be a 256-bit hexadecimal value' >&2
    exit 1
  }
  [[ "$totp_key" =~ ^[0-9a-f]{64}$ ]] || {
    printf '%s\n' 'LeafWiki TOTP encryption key must be a 256-bit hexadecimal value' >&2
    exit 1
  }
  [[ "$(stat -c '%a' -- "$secrets_file")" = 600 ]] || {
    printf '%s\n' 'LeafWiki secrets file permissions must be 0600' >&2
    exit 1
  }
}

prepare_data_dir
