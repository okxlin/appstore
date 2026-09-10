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
  temp_file="$(mktemp "${ROOT_DIR}/.yamtrack-env.tmp.XXXXXX")"
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

data_dir_raw="$(read_env_value APP_DATA_DIR)"
[[ -n "$data_dir_raw" ]] || data_dir_raw="./data"
case "$data_dir_raw" in
  /*) fail "APP_DATA_DIR must be relative to the application version directory" ;;
  *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'") fail "APP_DATA_DIR contains unsupported characters" ;;
esac

data_dir_abs="$(realpath -m -- "${ROOT_DIR}/${data_dir_raw#./}")"
case "$data_dir_abs" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR must stay inside the application version directory" ;;
esac
[[ "$data_dir_abs" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
[[ ! -e "$data_dir_abs" || -d "$data_dir_abs" ]] || fail "APP_DATA_DIR must be a directory"

timezone="$(read_env_value YAMTRACK_TIMEZONE)"
[[ "$timezone" =~ ^[A-Za-z0-9_+/-]+$ ]] || fail "YAMTRACK_TIMEZONE is invalid"

registration="$(read_env_value YAMTRACK_REGISTRATION)"
[[ "$registration" == "True" || "$registration" == "False" ]] || fail "YAMTRACK_REGISTRATION must be True or False"

secret="$(read_env_value YAMTRACK_SECRET)"
if [[ -z "$secret" || "$secret" == "generate" ]]; then
  command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate YAMTRACK_SECRET"
  secret="$(openssl rand -hex 32)"
fi
[[ ${#secret} -ge 50 ]] || fail "YAMTRACK_SECRET must contain at least 50 characters"
[[ "$secret" =~ ^[A-Za-z0-9._~!@%+=:,/-]+$ ]] || fail "YAMTRACK_SECRET contains unsupported dotenv characters"

install -d -m 0750 -- "$data_dir_abs" "$data_dir_abs/yamtrack" "$data_dir_abs/redis"
resolved_data_dir="$(realpath -e -- "$data_dir_abs")"
case "$resolved_data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac

if [[ "$(id -u)" -eq 0 ]]; then
  chown 1000:1000 "$data_dir_abs/yamtrack"
  chown 999:1000 "$data_dir_abs/redis"
else
  [[ "$(stat -c '%u:%g' "$data_dir_abs/yamtrack")" == "1000:1000" ]] || fail "Yamtrack init must run as root to prepare the data directory"
  [[ "$(stat -c '%u:%g' "$data_dir_abs/redis")" == "999:1000" ]] || fail "Yamtrack init must run as root to prepare the Redis directory"
fi
chmod 750 "$data_dir_abs/yamtrack" "$data_dir_abs/redis"
set_env_value YAMTRACK_SECRET "$secret"
