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

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.flagsmith-env.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { written = 0 }
    $0 ~ "^" key "=" {
      if (!written) {
        print key "=" value
        written = 1
      }
      next
    }
    { print }
    END {
      if (!written) print key "=" value
    }
  ' "$ENV_FILE" > "$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

domain="$(read_env_value FLAGSMITH_DOMAIN)"
[[ "$domain" =~ ^[A-Za-z0-9._:-]+$ ]] || fail "FLAGSMITH_DOMAIN must be a host with an optional port and no scheme or path"

allowed_hosts="$(read_env_value FLAGSMITH_ALLOWED_HOSTS)"
[[ "$allowed_hosts" =~ ^[A-Za-z0-9.*_:-]+(,[A-Za-z0-9.*_:-]+)*$ ]] || fail "FLAGSMITH_ALLOWED_HOSTS must be a comma-separated host list"

prevent_signup="$(read_env_value PREVENT_SIGNUP)"
[[ "$prevent_signup" == "true" || "$prevent_signup" == "false" ]] || fail "PREVENT_SIGNUP must be true or false"

secret="$(read_env_value DJANGO_SECRET_KEY)"
if [[ -z "$secret" || "$secret" == "generate" ]]; then
  command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate DJANGO_SECRET_KEY"
  secret="$(openssl rand -hex 32)"
fi
[[ ${#secret} -ge 50 ]] || fail "DJANGO_SECRET_KEY must contain at least 50 characters"
[[ "$secret" =~ ^[A-Za-z0-9._~!@%+=:,/-]+$ ]] || fail "DJANGO_SECRET_KEY contains unsupported dotenv characters"

chmod 600 "$ENV_FILE"
set_env_value DJANGO_SECRET_KEY "$secret"
