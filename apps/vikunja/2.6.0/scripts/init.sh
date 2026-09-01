#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

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
  local value
  value="${!key:-}"
  if [[ -z "$value" ]]; then
    value="$(read_env_value "$key")"
  fi
  printf '%s\n' "${value:-$default_value}"
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

resolve_direct_child() {
  local key="$1"
  local raw="$2"
  local clean path
  clean="${raw#./}"
  if [[ -z "$clean" || "$clean" == */* ]]; then
    echo "unsafe ${key} path: lifecycle directories must be direct children of the version root" >&2
    return 1
  fi
  path="$(resolve_app_path "$key" "$raw")"
  [[ "$path" == "$ROOT_DIR/$clean" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  printf '%s\n' "$path"
}

verify_trusted_root_chain() {
  local current owner mode
  [[ "$(id -u)" == "0" ]] || { echo "directory ownership initialization must run as root" >&2; return 1; }
  command -v stat >/dev/null 2>&1 || { echo "stat is required" >&2; return 1; }
  current="$ROOT_DIR"
  while [[ "$current" != "/" ]]; do
    [[ -d "$current" && ! -L "$current" ]] || { echo "unsafe version root chain: $current" >&2; return 1; }
    IFS=':' read -r owner mode < <(stat -c '%u:%a' -- "$current")
    [[ "$owner" == "0" ]] || { echo "unsafe version root chain owner: $current" >&2; return 1; }
    [[ "$mode" =~ ^[0-7]{3,4}$ ]] || { echo "unsafe version root chain mode: $current" >&2; return 1; }
    (( (8#$mode & 0022) == 0 )) || { echo "unsafe version root chain permissions: $current" >&2; return 1; }
    current="$(dirname -- "$current")"
  done
}

ensure_dir() {
  local key="$1"
  local raw
  local path
  raw="$(configured_value "$key" "$2")"
  path="$(resolve_app_path "$key" "$raw")"
  mkdir -p -- "$path"
  [[ "$(resolve_app_path "$key" "$raw")" == "$path" ]] || { echo "unsafe ${key} path" >&2; return 1; }
}

declare -A OWNED_PATHS=()
declare -A OWNED_KEYS_BY_PATH=()

register_owned_dir() {
  local key="$1"
  local raw="$2"
  local path previous_key
  path="$(resolve_direct_child "$key" "$raw")"
  if [[ -n "${OWNED_KEYS_BY_PATH[$path]+x}" ]]; then
    previous_key="${OWNED_KEYS_BY_PATH[$path]}"
    echo "duplicate directory ownership target: $path ($previous_key and $key)" >&2
    return 1
  fi
  OWNED_KEYS_BY_PATH["$path"]="$key"
  OWNED_PATHS["$key"]="$path"
}

register_configured_owned_dir() {
  local key="$1"
  local default_value="$2"
  local raw
  raw="$(configured_value "$key" "$default_value")"
  register_owned_dir "$key" "$raw"
}

register_fixed_owned_dir() {
  local source="$1"
  register_owned_dir "fixed directory $source" "$source"
}

apply_owned_dir() {
  local key="$1"
  local uid="$2"
  local gid="$3"
  local mode="$4"
  local path actual expected_mode
  [[ -n "${OWNED_PATHS[$key]+x}" ]] || { echo "missing directory ownership preflight: $key" >&2; return 1; }
  path="${OWNED_PATHS[$key]}"
  verify_trusted_root_chain
  if [[ -e "$path" || -L "$path" ]]; then
    [[ -d "$path" && ! -L "$path" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  else
    mkdir -- "$path"
  fi
  chmod "$mode" -- "$path"
  [[ -d "$path" && ! -L "$path" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  chown --no-dereference "$uid:$gid" -- "$path"
  expected_mode="${mode#0}"
  actual="$(stat -c '%u:%g:%a' -- "$path")"
  [[ "$actual" == "$uid:$gid:$expected_mode" ]] || { echo "${key} ownership/mode mismatch: expected ${uid}:${gid}:${expected_mode}, got ${actual}" >&2; return 1; }
}

ensure_owned_dir() {
  local key="$1"
  local default_value="$2"
  [[ -n "$default_value" ]] || { echo "missing directory ownership default: $key" >&2; return 1; }
  apply_owned_dir "$key" "$3" "$4" "$5"
}

ensure_fixed_owned_dir() {
  local source="$1"
  apply_owned_dir "fixed directory $source" "$2" "$3" "$4"
}

register_configured_owned_dir "APP_DATA_DIR" "./data"
ensure_owned_dir "APP_DATA_DIR" "./data" "1000" "1000" "0750"

secret_is_safe() {
  local value="$1"
  [[ "$value" =~ ^[-A-Za-z0-9._~!@#%\^\&*+=:,/?]{32,}$ ]]
}

generate_secret() {
  local value=""

  if command -v openssl >/dev/null 2>&1; then
    value="$(openssl rand -hex 32)"
  elif [[ -r /dev/urandom ]] && command -v od >/dev/null 2>&1; then
    value="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  fi
  [[ "$value" =~ ^[0-9a-f]{64}$ ]] || { echo "Unable to generate a secure Vikunja service secret" >&2; exit 1; }
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

  [[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || { echo "$ENV_FILE must be a regular file" >&2; exit 1; }
  env_dir="$(dirname "$ENV_FILE")"
  temp_file="$(mktemp "${env_dir}/.vikunja-env.tmp.XXXXXX")"

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

APP_DATA_DIR_RAW="$(configured_value APP_DATA_DIR "./data")"
APP_DATA_DIR_ABS="$(resolve_app_path APP_DATA_DIR "$APP_DATA_DIR_RAW")"
[[ "$APP_DATA_DIR_ABS" == "${OWNED_PATHS[APP_DATA_DIR]}" ]] || { echo "APP_DATA_DIR changed during initialization" >&2; exit 1; }

SECRET_CACHE="${APP_DATA_DIR_ABS}/.vikunja_service_secret"
[[ ! -L "$SECRET_CACHE" ]] || { echo "Vikunja secret cache must not be a symbolic link" >&2; exit 1; }
if [[ -e "$SECRET_CACHE" && ! -f "$SECRET_CACHE" ]]; then
  echo "Vikunja secret cache must be a regular file" >&2
  exit 1
fi

data_paths=("${APP_DATA_DIR_ABS}/db" "${APP_DATA_DIR_ABS}/files")
for path in "${data_paths[@]}"; do
  [[ ! -L "$path" ]] || { echo "Vikunja data directories must not be symbolic links" >&2; exit 1; }
  if [[ -e "$path" && ! -d "$path" ]]; then
    echo "Vikunja data paths must be directories" >&2
    exit 1
  fi
done

for path in "${data_paths[@]}"; do
  path_existed=false
  [[ -d "$path" ]] && path_existed=true
  mkdir -p -- "$path"
  [[ ! -L "$path" && -d "$path" ]] || { echo "Vikunja data path changed during initialization" >&2; exit 1; }
  path_needs_chown=false
  if [[ "$path_existed" == "false" ]]; then
    path_needs_chown=true
  else
    current_uid="$(stat -c '%u' "$path")"
    current_gid="$(stat -c '%g' "$path")"
    if [[ "$current_uid" != "1000" || "$current_gid" != "1000" ]]; then
      path_needs_chown=true
    fi
  fi
  if [[ "$path_needs_chown" == "true" ]]; then
    chown --no-dereference -R 1000:1000 -- "$path"
  fi
done

if [[ ${VIKUNJA_SERVICE_SECRET+x} ]]; then
  service_secret="$VIKUNJA_SERVICE_SECRET"
else
  service_secret="$(read_env_value VIKUNJA_SERVICE_SECRET)"
fi
if [[ "$service_secret" == \"*\" && "$service_secret" == *\" ]]; then
  service_secret="${service_secret:1:${#service_secret}-2}"
elif [[ "$service_secret" == \'*\' && "$service_secret" == *\' ]]; then
  service_secret="${service_secret:1:${#service_secret}-2}"
fi

cached_secret=""
if [[ -s "$SECRET_CACHE" ]]; then
  cached_secret="$(< "$SECRET_CACHE")"
  secret_is_safe "$cached_secret" || { echo "Persisted Vikunja service secret is invalid" >&2; exit 1; }
fi

if [[ -z "$service_secret" || "$service_secret" == "generate" ]]; then
  if [[ -n "$cached_secret" ]]; then
    service_secret="$cached_secret"
  else
    service_secret="$(generate_secret)"
  fi
else
  secret_is_safe "$service_secret" || { echo "VIKUNJA_SERVICE_SECRET must contain at least 32 safe characters" >&2; exit 1; }
fi

write_secret_cache "$SECRET_CACHE" "$service_secret"
set_env_value VIKUNJA_SERVICE_SECRET "$service_secret"
