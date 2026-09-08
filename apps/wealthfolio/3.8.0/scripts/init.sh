#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
DOCKER_BIN="${DOCKER_BIN:-docker}"
IMAGE='wealthfolio/wealthfolio:3.6.2@sha256:f24c607692c1b494a477382aa3dfedc11ede1b433768b66546940c8f6b8a474f'

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

replace_env_value() {
  local key="$1"
  local value="$2"
  local temporary
  [[ "$value" != *"'"* && "$value" != *$'\n'* && "$value" != *$'\r'* ]] || {
    printf 'Cannot safely store %s in the environment file\n' "$key" >&2
    exit 1
  }
  temporary="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  awk -v prefix="${key}=" 'index($0, prefix) != 1 { print }' "$ENV_FILE" >"$temporary"
  printf "%s='%s'\n" "$key" "$value" >>"$temporary"
  chmod --reference="$ENV_FILE" "$temporary"
  mv -f -- "$temporary" "$ENV_FILE"
}

data_raw="$(configured_value APP_DATA_DIR ./data)"
admin_password="$(configured_value ADMIN_PASSWORD '')"
secret_input="$(configured_value WF_SECRET_KEY '')"

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

[[ ${#admin_password} -ge 16 && ${#admin_password} -le 256 ]] || {
  printf '%s\n' 'ADMIN_PASSWORD must contain 16 to 256 characters' >&2
  exit 1
}
if [[ "$admin_password" == *$'\n'* || "$admin_password" == *$'\r'* ]]; then
  printf '%s\n' 'ADMIN_PASSWORD must not contain line breaks' >&2
  exit 1
fi

[[ ${#secret_input} -ge 16 && ${#secret_input} -le 256 ]] || {
  printf '%s\n' 'WF_SECRET_KEY must contain 16 to 256 characters' >&2
  exit 1
}
if decoded_length="$(printf '%s' "$secret_input" | base64 -d 2>/dev/null | wc -c)" &&
     [[ "$decoded_length" -eq 32 && "$secret_input" != *"'"* ]]; then
  secret_key="$secret_input"
elif [[ "$secret_input" =~ ^[A-Za-z0-9._~-]{32}$ && "$secret_input" =~ [._~-] ]]; then
  secret_key="$secret_input"
else
  secret_key="wf_$(printf '%s' "$secret_input" | sha256sum | cut -c1-29)"
fi

command -v "$DOCKER_BIN" >/dev/null 2>&1 || {
  printf '%s\n' 'Docker is required to generate the Wealthfolio Argon2id password hash' >&2
  exit 1
}
salt="$(printf '%s' "$secret_key" | sha256sum | cut -c1-16)"
# shellcheck disable=SC2016
auth_hash="$(
  printf '%s' "$admin_password" |
    "$DOCKER_BIN" run --rm -i --user 0:0 --entrypoint /bin/sh "$IMAGE" -ec \
      'apk add --no-cache argon2 >/dev/null; exec argon2 "$1" -id -e -t 3 -m 16 -p 1' \
      sh "$salt"
)"
[[ "$auth_hash" =~ ^\$argon2id\$v=19\$m=65536,t=3,p=1\$[A-Za-z0-9+/]+={0,2}\$[A-Za-z0-9+/]+={0,2}$ ]] || {
  printf '%s\n' 'Failed to generate a valid Argon2id password hash' >&2
  exit 1
}

replace_env_value WF_SECRET_KEY "$secret_key"

install -d -m 0750 "$data_dir"
data_dir="$(realpath -e -- "$data_dir")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *)
    printf '%s\n' 'APP_DATA_DIR resolves outside the application version directory' >&2
    exit 1
    ;;
esac
chmod 0750 "$data_dir"

runtime_env="$data_dir/.runtime-env"
runtime_temporary="$(mktemp "$data_dir/.runtime-env.tmp.XXXXXX")"
umask 077
{
  printf "WF_SECRET_KEY='%s'\n" "$secret_key"
  printf "WF_AUTH_PASSWORD_HASH='%s'\n" "$auth_hash"
} >"$runtime_temporary"
chmod 0600 "$runtime_temporary"
mv -f -- "$runtime_temporary" "$runtime_env"
