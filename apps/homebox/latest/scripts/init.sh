#!/usr/bin/env bash
set -euo pipefail
umask 077

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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
  local raw="$1"
  if [[ "$raw" = /* ]]; then
    printf '%s\n' "$raw"
  else
    printf '%s\n' "$ROOT_DIR/${raw#./}"
  fi
}

ensure_dir() {
  local path
  path="$(resolve_app_path "$(configured_value "$1" "$2")")"
  mkdir -p "$path"
}

DATA_DIR="$(resolve_app_path "$(configured_value "APP_DATA_DIR" "./data")")"
ensure_dir "APP_DATA_DIR" "./data"
chown -R 65532:65532 "$DATA_DIR"

# HomeBox requires a stable API-key pepper of at least 32 bytes. The panel's
# generic random field can be shorter, so normalize it once and persist it.
PEPPER_FILE="$DATA_DIR/.hbox-auth-api-key-pepper"
PEPPER=""
if [[ -f "$PEPPER_FILE" ]]; then
  PEPPER="$(head -n 1 "$PEPPER_FILE")"
fi
if [[ ! "$PEPPER" =~ ^[A-Za-z0-9+/=]{32,}$ ]]; then
  PEPPER="$(openssl rand -base64 48 | tr -d '\n')"
  printf '%s\n' "$PEPPER" > "$PEPPER_FILE"
fi
chmod 600 "$PEPPER_FILE"

if [[ -f "$ENV_FILE" ]]; then
  ENV_TMP="${ENV_FILE}.tmp.$$"
  : > "$ENV_TMP"
  ENV_FOUND=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      HBOX_AUTH_API_KEY_PEPPER=*)
        printf 'HBOX_AUTH_API_KEY_PEPPER="%s"\n' "$PEPPER" >> "$ENV_TMP"
        ENV_FOUND=1
        ;;
      *) printf '%s\n' "$line" >> "$ENV_TMP" ;;
    esac
  done < "$ENV_FILE"
  if [[ "$ENV_FOUND" -eq 0 ]]; then
    printf 'HBOX_AUTH_API_KEY_PEPPER="%s"\n' "$PEPPER" >> "$ENV_TMP"
  fi
  mv "$ENV_TMP" "$ENV_FILE"
else
  printf 'HBOX_AUTH_API_KEY_PEPPER="%s"\n' "$PEPPER" > "$ENV_FILE"
fi
