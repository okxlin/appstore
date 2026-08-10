#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
APP_ROOT_DIR="$(dirname "$ROOT_DIR")"
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
  value="${value%$'\r'}"
  strip_matching_quotes "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file

  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { updated = 0 }
    $0 ~ ("^" key "=") {
      if (!updated) {
        print key "=" value
        updated = 1
      }
      next
    }
    { print }
    END {
      if (!updated) print key "=" value
    }
  ' "$ENV_FILE" >"$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

path_is_dotenv_safe() {
  local value="$1"

  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) return 1 ;;
    *) return 0 ;;
  esac
}

seed_is_safe() {
  [[ ${#1} -ge 32 && "$1" =~ ^[A-Za-z0-9._~-]+$ ]]
}

generate_seed() {
  od -An -N 32 -tx1 /dev/urandom | tr -d ' \n'
}

[[ -f "$ENV_FILE" ]] || fail "Environment file not found: ${ENV_FILE}"
chmod 600 "$ENV_FILE"

if [[ ${APP_DATA_DIR+x} ]]; then
  DATA_DIR_RAW="$APP_DATA_DIR"
else
  DATA_DIR_RAW="$(read_env_value APP_DATA_DIR)"
fi
DATA_DIR_RAW="$(strip_matching_quotes "${DATA_DIR_RAW:-./data}")"

[[ -n "$DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be empty"
path_is_dotenv_safe "$DATA_DIR_RAW" || fail "APP_DATA_DIR contains unsupported dotenv characters"

if [[ "$DATA_DIR_RAW" = /* ]]; then
  [[ ! -L "$DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_RAW")"
  [[ "$DATA_DIR_ABS" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
else
  CONTAINER_NAME_VALUE="$(read_env_value CONTAINER_NAME)"
  [[ "$CONTAINER_NAME_VALUE" =~ ^[A-Za-z0-9._-]+$ ]] || \
    fail "CONTAINER_NAME contains unsupported characters"

  RETAINED_ROOT="${APP_ROOT_DIR}/retained-data"
  [[ ! -L "$RETAINED_ROOT" ]] || fail "The retained data root must not be a symbolic link"
  RETAINED_INSTANCE_ROOT="${RETAINED_ROOT}/${CONTAINER_NAME_VALUE}"
  DATA_DIR_PATH="${RETAINED_INSTANCE_ROOT}/${DATA_DIR_RAW#./}"
  [[ ! -L "$DATA_DIR_PATH" ]] || fail "APP_DATA_DIR must not be a symbolic link"
  RETAINED_INSTANCE_ABS="$(realpath -m -- "$RETAINED_INSTANCE_ROOT")"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_PATH")"
  case "$DATA_DIR_ABS" in
    "${RETAINED_INSTANCE_ABS}"/*) ;;
    *) fail "Relative APP_DATA_DIR must remain inside the isolated retained-data directory" ;;
  esac

  set_env_value APP_DATA_DIR "\"${DATA_DIR_ABS}\""
fi

if [[ -e "$DATA_DIR_ABS" && ! -d "$DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi
if [[ ! -e "$DATA_DIR_ABS" ]]; then
  install -d -m 0750 -- "$DATA_DIR_ABS"
fi

PUBLIC_URL="$(read_env_value NOTE_MARK_PUBLIC_URL)"
[[ "$PUBLIC_URL" =~ ^https?://[A-Za-z0-9._~:/?%\&=+@-]+$ ]] || \
  fail "NOTE_MARK_PUBLIC_URL must be a complete HTTP or HTTPS URL"
[[ "$PUBLIC_URL" != */ ]] || fail "NOTE_MARK_PUBLIC_URL must not end in a trailing slash"

for key in ENABLE_INTERNAL_SIGNUP ENABLE_INTERNAL_LOGIN ENABLE_ANONYMOUS_USER_SEARCH; do
  value="$(read_env_value "$key")"
  [[ "$value" == "true" || "$value" == "false" ]] || fail "${key} must be true or false"
done

FILE_LIMIT="$(read_env_value FILE_SIZE_LIMIT)"
[[ "$FILE_LIMIT" =~ ^[1-9][0-9]*(B|K|KB|M|MB|G|GB)?$ ]] || \
  fail "FILE_SIZE_LIMIT must be a positive byte-size value such as 12M"

LOG_LEVEL="$(read_env_value LOGGING_LEVEL)"
case "$LOG_LEVEL" in
  debug | info | warn | warning | error) ;;
  *) fail "LOGGING_LEVEL must be debug, info, warn, warning, or error" ;;
esac

TIME_ZONE="$(read_env_value TZ)"
[[ "$TIME_ZONE" =~ ^[A-Za-z0-9_+./-]+$ ]] || fail "TZ contains unsupported characters"

SECRET_SEED="$(read_env_value NOTE_MARK_SECRET_SEED)"
if ! seed_is_safe "$SECRET_SEED"; then
  printf '%s\n' 'NOTE_MARK_SECRET_SEED is missing, too short, or not dotenv-safe; replacing it with a generated value.' >&2
  SECRET_SEED="$(generate_seed)"
  set_env_value NOTE_MARK_SECRET_SEED "$SECRET_SEED"
fi

SECRET_DIGEST="$(printf '%s' "$SECRET_SEED" | sha256sum | awk '{print $1}')"
AUTH_SECRET="$(printf '%s' "$SECRET_DIGEST" | base64 | tr -d '\n')"
[[ "$(printf '%s' "$AUTH_SECRET" | base64 -d | wc -c)" -ge 32 ]] || \
  fail "Failed to derive a valid authentication secret"
set_env_value NOTE_MARK_AUTH_SECRET "$AUTH_SECRET"
