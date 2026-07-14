#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

strip_matching_quotes() {
  local value="$1"

  if [[ ${#value} -ge 2 ]]; then
    if [[ "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
      value="${value:1:${#value}-2}"
    elif [[ "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
      value="${value:1:${#value}-2}"
    fi
  fi
  printf '%s\n' "$value"
}

env_has_key() {
  local key="$1"
  [[ -f "$ENV_FILE" ]] && grep -qE "^${key}=" "$ENV_FILE"
}

read_env_value() {
  local key="$1"
  local value=""

  if env_has_key "$key"; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2-)"
  fi
  strip_matching_quotes "$value"
}

read_effective_value() {
  local key="$1"

  if [[ -v "$key" ]]; then
    strip_matching_quotes "${!key}"
  else
    read_env_value "$key"
  fi
}

username_is_safe() {
  local value="$1"
  [[ "$value" =~ ^[A-Za-z_][A-Za-z0-9_.-]{0,62}$ ]]
}

secret_is_safe() {
  local value="$1"
  [[ "$value" =~ ^[-A-Za-z0-9._~!@#%^\&*+=:,/?]{32,}$ ]]
}

generate_secret() {
  local value=""

  if command -v openssl >/dev/null 2>&1; then
    value="$(openssl rand -hex 32)"
  elif [[ -r /dev/urandom ]] && command -v od >/dev/null 2>&1; then
    value="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  fi
  [[ "$value" =~ ^[0-9a-f]{64}$ ]] || fail "Unable to generate a secure QuestDB password"
  printf '%s\n' "$value"
}

write_secret_cache() {
  local cache_file="$1"
  local value="$2"
  local temp_file

  umask 077
  temp_file="$(mktemp "${cache_file}.tmp.XXXXXX")"
  printf '%s\n' "$value" > "$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$cache_file"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local env_dir
  local temp_file

  [[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
  [[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"
  env_dir="$(dirname "$ENV_FILE")"
  temp_file="$(mktemp "${env_dir}/.questdb-env.tmp.XXXXXX")"

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
      if (!written) {
        print key "=" value
      }
    }
  ' "$ENV_FILE" > "$temp_file"
  chmod --reference="$ENV_FILE" "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

resolve_secret() {
  local env_key="$1"
  local cache_file="$2"
  local value
  local cached_value=""

  [[ ! -L "$cache_file" ]] || fail "QuestDB password cache must not be a symbolic link"
  if [[ -e "$cache_file" && ! -f "$cache_file" ]]; then
    fail "QuestDB password cache must be a regular file"
  fi
  if [[ -s "$cache_file" ]]; then
    cached_value="$(sed -n '1p' "$cache_file")"
    secret_is_safe "$cached_value" || fail "Persisted QuestDB password is invalid"
  fi

  value="$(read_effective_value "$env_key")"
  if [[ -z "$value" || "$value" == "generate" ]]; then
    if [[ -n "$cached_value" ]]; then
      value="$cached_value"
    else
      value="$(generate_secret)"
    fi
  else
    secret_is_safe "$value" || fail "${env_key} must contain at least 32 safe characters"
  fi

  write_secret_cache "$cache_file" "$value"
  set_env_value "$env_key" "$value"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

app_data_dir_explicit=false
if [[ ${APP_DATA_DIR+x} ]]; then
  APP_DATA_DIR_RAW="$APP_DATA_DIR"
  app_data_dir_explicit=true
elif env_has_key APP_DATA_DIR; then
  APP_DATA_DIR_RAW="$(read_env_value APP_DATA_DIR)"
  app_data_dir_explicit=true
else
  APP_DATA_DIR_RAW="./data"
fi
APP_DATA_DIR_RAW="$(strip_matching_quotes "$APP_DATA_DIR_RAW")"

if [[ "$app_data_dir_explicit" == "true" && -z "$APP_DATA_DIR_RAW" ]]; then
  fail "APP_DATA_DIR must not be empty"
fi

case "$APP_DATA_DIR_RAW" in
  /*)
    APP_DATA_DIR_ABS="$(realpath -m -- "$APP_DATA_DIR_RAW")"
    ;;
  *)
    APP_DATA_DIR_ABS="$(realpath -m -- "${ROOT_DIR}/${APP_DATA_DIR_RAW#./}")"
    case "$APP_DATA_DIR_ABS" in
      "${ROOT_DIR}" | "${ROOT_DIR}"/*) ;;
      *) fail "Relative APP_DATA_DIR must stay inside the application directory" ;;
    esac
    ;;
esac

[[ "$APP_DATA_DIR_ABS" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
if [[ -e "$APP_DATA_DIR_ABS" && ! -d "$APP_DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi
mkdir -p -- "$APP_DATA_DIR_ABS"

http_user="$(read_effective_value QUESTDB_HTTP_USER)"
pg_user="$(read_effective_value QUESTDB_PG_USER)"
username_is_safe "$http_user" || fail "QUESTDB_HTTP_USER contains unsupported characters"
username_is_safe "$pg_user" || fail "QUESTDB_PG_USER contains unsupported characters"

resolve_secret QUESTDB_HTTP_PASSWORD "${APP_DATA_DIR_ABS}/.questdb_http_password"
resolve_secret QUESTDB_PG_PASSWORD "${APP_DATA_DIR_ABS}/.questdb_pg_password"
