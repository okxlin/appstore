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

path_is_dotenv_safe() {
  local value="$1"

  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) return 1 ;;
    *) return 0 ;;
  esac
}

email_is_safe() {
  local value="$1"
  local local_part
  local domain
  local label
  local -a labels

  [[ ${#value} -le 254 ]] || return 1
  [[ "$value" == *@* ]] || return 1
  [[ "$value" != *..* ]] || return 1
  local_part="${value%@*}"
  domain="${value#*@}"
  [[ "$local_part" != "$value" && "$domain" != "$value" ]] || return 1
  [[ "$local_part" =~ ^[A-Za-z0-9]$ || "$local_part" =~ ^[A-Za-z0-9][A-Za-z0-9._%+-]{0,62}[A-Za-z0-9]$ ]] || return 1
  [[ "$domain" == *.* ]] || return 1
  IFS='.' read -r -a labels <<< "$domain"
  [[ ${#labels[@]} -ge 2 ]] || return 1
  for label in "${labels[@]}"; do
    [[ "$label" =~ ^[A-Za-z0-9]$ || "$label" =~ ^[A-Za-z0-9][A-Za-z0-9-]{0,61}[A-Za-z0-9]$ ]] || return 1
  done
}

password_is_safe() {
  local value="$1"
  local allowed_re='^[-A-Za-z0-9._~!@#%^&*+=:,/?]+$'
  local special_re='[-._~!@#%^&*+=:,/?]'

  [[ ${#value} -ge 8 && ${#value} -le 128 ]] || return 1
  [[ "$value" =~ $allowed_re ]] || return 1
  [[ "$value" =~ [a-z] ]] || return 1
  [[ "$value" =~ [A-Z] ]] || return 1
  [[ "$value" =~ [0-9] ]] || return 1
  [[ "$value" =~ $special_re ]] || return 1
}

generate_password() {
  local value=""

  if command -v openssl >/dev/null 2>&1; then
    value="$(openssl rand -hex 32)"
  elif [[ -r /dev/urandom ]] && command -v od >/dev/null 2>&1; then
    value="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  fi
  [[ "$value" =~ ^[0-9a-f]{64}$ ]] || fail "Unable to generate a secure OpenObserve password"
  printf 'Oo1!%s\n' "$value"
}

write_password_cache() {
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
  temp_file="$(mktemp "${env_dir}/.openobserve-env.tmp.XXXXXX")"

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

resolve_password() {
  local cache_file="$1"
  local value
  local cached_value=""

  [[ ! -L "$cache_file" ]] || fail "OpenObserve password cache must not be a symbolic link"
  if [[ -e "$cache_file" && ! -f "$cache_file" ]]; then
    fail "OpenObserve password cache must be a regular file"
  fi
  if [[ -s "$cache_file" ]]; then
    cached_value="$(sed -n '1p' "$cache_file")"
    password_is_safe "$cached_value" || fail "Persisted OpenObserve password is invalid"
  fi

  value="$(read_effective_value OPENOBSERVE_ROOT_PASSWORD)"
  if [[ -z "$value" || "$value" == "generate" ]]; then
    if [[ -n "$cached_value" ]]; then
      value="$cached_value"
    else
      value="$(generate_password)"
    fi
  else
    password_is_safe "$value" || fail "OPENOBSERVE_ROOT_PASSWORD must be 8-128 safe characters with lowercase, uppercase, number, and special character"
  fi

  write_password_cache "$cache_file" "$value"
  set_env_value OPENOBSERVE_ROOT_PASSWORD "$value"
}

resolve_boolean() {
  local key="$1"
  local default_value="$2"
  local value

  value="$(read_effective_value "$key")"
  [[ -n "$value" ]] || value="$default_value"
  [[ "$value" == "true" || "$value" == "false" ]] || fail "${key} must be true or false"
  set_env_value "$key" "$value"
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
path_is_dotenv_safe "$APP_DATA_DIR_RAW" || fail "APP_DATA_DIR contains unsupported dotenv characters"

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
set_env_value APP_DATA_DIR "$APP_DATA_DIR_RAW"

root_email="$(read_effective_value OPENOBSERVE_ROOT_EMAIL)"
email_is_safe "$root_email" || fail "OPENOBSERVE_ROOT_EMAIL must be a valid email address"
set_env_value OPENOBSERVE_ROOT_EMAIL "$root_email"

resolve_password "${APP_DATA_DIR_ABS}/.openobserve_root_password"
resolve_boolean OPENOBSERVE_TELEMETRY false
resolve_boolean OPENOBSERVE_COOKIE_SECURE_ONLY false
