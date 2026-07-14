#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
VIKUNJA_UID=1000
VIKUNJA_GID=1000

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
  [[ "$value" =~ ^[0-9a-f]{64}$ ]] || fail "Unable to generate a secure Vikunja service secret"
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
    APP_DATA_DIR_SCOPE="absolute"
    ;;
  *)
    APP_DATA_DIR_ABS="$(realpath -m -- "${ROOT_DIR}/${APP_DATA_DIR_RAW#./}")"
    case "$APP_DATA_DIR_ABS" in
      "${ROOT_DIR}"/*) ;;
      *) fail "Relative APP_DATA_DIR must stay inside the application directory" ;;
    esac
    APP_DATA_DIR_SCOPE="application"
    ;;
esac

[[ "$APP_DATA_DIR_ABS" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
if [[ -e "$APP_DATA_DIR_ABS" && ! -d "$APP_DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi
mkdir -p -- "$APP_DATA_DIR_ABS"

SECRET_CACHE="${APP_DATA_DIR_ABS}/.vikunja_service_secret"
[[ ! -L "$SECRET_CACHE" ]] || fail "Vikunja secret cache must not be a symbolic link"
if [[ -e "$SECRET_CACHE" && ! -f "$SECRET_CACHE" ]]; then
  fail "Vikunja secret cache must be a regular file"
fi

data_paths=("${APP_DATA_DIR_ABS}/db" "${APP_DATA_DIR_ABS}/files")
for path in "${data_paths[@]}"; do
  [[ ! -L "$path" ]] || fail "Vikunja data directories must not be symbolic links"
  if [[ -e "$path" && ! -d "$path" ]]; then
    fail "Vikunja data paths must be directories"
  fi
  if [[ "$APP_DATA_DIR_SCOPE" == "absolute" && -d "$path" ]]; then
    current_uid="$(stat -c '%u' "$path")"
    current_gid="$(stat -c '%g' "$path")"
    if [[ "$current_uid" != "$VIKUNJA_UID" || "$current_gid" != "$VIKUNJA_GID" ]]; then
      fail "Existing absolute data directory must be owned by 1000:1000"
    fi
  fi
done

for path in "${data_paths[@]}"; do
  path_existed=false
  [[ -d "$path" ]] && path_existed=true
  mkdir -p -- "$path"
  path_needs_chown=false
  if [[ "$path_existed" == "false" ]]; then
    path_needs_chown=true
  elif [[ "$APP_DATA_DIR_SCOPE" == "application" ]]; then
    current_uid="$(stat -c '%u' "$path")"
    current_gid="$(stat -c '%g' "$path")"
    if [[ "$current_uid" != "$VIKUNJA_UID" || "$current_gid" != "$VIKUNJA_GID" ]]; then
      path_needs_chown=true
    fi
  fi
  if [[ "$path_needs_chown" == "true" ]]; then
    chown -R "${VIKUNJA_UID}:${VIKUNJA_GID}" "$path"
  fi
done

if [[ ${VIKUNJA_SERVICE_SECRET+x} ]]; then
  service_secret="$(strip_matching_quotes "$VIKUNJA_SERVICE_SECRET")"
else
  service_secret="$(read_env_value VIKUNJA_SERVICE_SECRET)"
fi

cached_secret=""
if [[ -s "$SECRET_CACHE" ]]; then
  cached_secret="$(cat "$SECRET_CACHE")"
  secret_is_safe "$cached_secret" || fail "Persisted Vikunja service secret is invalid"
fi

if [[ -z "$service_secret" || "$service_secret" == "generate" ]]; then
  if [[ -n "$cached_secret" ]]; then
    service_secret="$cached_secret"
  else
    service_secret="$(generate_secret)"
  fi
else
  secret_is_safe "$service_secret" || fail "VIKUNJA_SERVICE_SECRET must contain at least 32 safe characters"
fi

write_secret_cache "$SECRET_CACHE" "$service_secret"
set_env_value VIKUNJA_SERVICE_SECRET "$service_secret"
