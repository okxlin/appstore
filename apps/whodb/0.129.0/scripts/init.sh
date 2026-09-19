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

read_env_value() {
  local key="$1"
  local value=""
  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
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

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.whodb-env.tmp.XXXXXX")"
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
  chmod --reference="$ENV_FILE" "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
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

generate_key() {
  local value=""
  if command -v openssl >/dev/null 2>&1; then
    value="$(openssl rand -hex 32)"
  elif [[ -r /dev/urandom ]] && command -v od >/dev/null 2>&1; then
    value="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  fi
  [[ "$value" =~ ^[0-9a-f]{64}$ ]] || fail "Unable to generate a secure WhoDB encryption key"
  printf '%s\n' "$value"
}

write_key_cache() {
  local cache_file="$1"
  local value="$2"
  local temp_file
  umask 077
  temp_file="$(mktemp "${cache_file}.tmp.XXXXXX")"
  printf '%s\n' "$value" > "$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$cache_file"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

data_dir_raw="$(read_effective_value APP_DATA_DIR)"
[[ -n "$data_dir_raw" ]] || data_dir_raw="./data"
data_dir_abs="$(resolve_app_path "APP_DATA_DIR" "$data_dir_raw")"

[[ "$data_dir_abs" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
if [[ -e "$data_dir_abs" && ! -d "$data_dir_abs" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi
mkdir -p -- "$data_dir_abs"

db_data_dir_raw="$(read_effective_value DB_DATA_DIR)"
[[ -n "$db_data_dir_raw" ]] || db_data_dir_raw="./db-data"
db_data_dir_abs="$(resolve_app_path "DB_DATA_DIR" "$db_data_dir_raw")"

[[ "$db_data_dir_abs" != "/" ]] || fail "DB_DATA_DIR must not be the filesystem root"
[[ "$db_data_dir_abs" != "$data_dir_abs" ]] || fail "DB_DATA_DIR must differ from APP_DATA_DIR"
if [[ -e "$db_data_dir_abs" && ! -d "$db_data_dir_abs" ]]; then
  fail "DB_DATA_DIR must be a directory"
fi
mkdir -p -- "$db_data_dir_abs"

cache_file="${data_dir_abs}/.whodb_encryption_key"
[[ ! -L "$cache_file" ]] || fail "WhoDB encryption key cache must not be a symbolic link"
if [[ -e "$cache_file" && ! -f "$cache_file" ]]; then
  fail "WhoDB encryption key cache must be a regular file"
fi

cached_key=""
if [[ -s "$cache_file" ]]; then
  cached_key="$(sed -n '1p' "$cache_file")"
  [[ "$cached_key" =~ ^[0-9a-f]{64}$ ]] || fail "Persisted WhoDB encryption key is invalid"
fi

requested_key="$(read_effective_value WHODB_ENCRYPTION_KEY)"
if [[ -z "$requested_key" || "$requested_key" == "generate" ]]; then
  encryption_key="${cached_key:-$(generate_key)}"
else
  [[ "$requested_key" =~ ^[0-9a-fA-F]{64}$ ]] || fail "WHODB_ENCRYPTION_KEY must be generate or exactly 64 hexadecimal characters"
  encryption_key="${requested_key,,}"
fi

secure_cookie="$(read_effective_value WHODB_SECURE)"
[[ -n "$secure_cookie" ]] || secure_cookie=false
[[ "$secure_cookie" == "true" || "$secure_cookie" == "false" ]] || fail "WHODB_SECURE must be true or false"

write_key_cache "$cache_file" "$encryption_key"
set_env_value APP_DATA_DIR "$data_dir_abs"
set_env_value DB_DATA_DIR "$db_data_dir_abs"
set_env_value WHODB_ENCRYPTION_KEY "$encryption_key"
set_env_value WHODB_SECURE "$secure_cookie"
