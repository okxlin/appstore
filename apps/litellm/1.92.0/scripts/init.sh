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

path_is_dotenv_safe() {
  local value="$1"

  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) return 1 ;;
    *) return 0 ;;
  esac
}

secret_is_acceptable() {
  local value="$1"

  [[ ${#value} -ge 35 && ${#value} -le 100 ]] || return 1
  [[ "$value" =~ ^sk-[A-Za-z0-9_-]+$ ]]
}

generate_secret() {
  local hex

  hex="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  [[ "$hex" =~ ^[0-9a-f]{64}$ ]] || fail "Unable to generate LiteLLM secret"
  printf 'sk-%s\n' "$hex"
}

write_env_value() {
  local key="$1"
  local value="$2"
  local line
  local found=0
  local tmp_file

  tmp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  chmod 600 -- "$tmp_file"
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == "${key}="* ]]; then
      if [[ $found -eq 0 ]]; then
        printf '%s=%s\n' "$key" "$value" >>"$tmp_file"
        found=1
      fi
    else
      printf '%s\n' "$line" >>"$tmp_file"
    fi
  done <"$ENV_FILE"
  if [[ $found -eq 0 ]]; then
    printf '%s=%s\n' "$key" "$value" >>"$tmp_file"
  fi
  mv -f -- "$tmp_file" "$ENV_FILE"
}

resolve_secret() {
  local key="$1"
  local file="$2"
  local candidate

  [[ ! -L "$file" ]] || fail "$file must not be a symbolic link"
  if [[ -e "$file" ]]; then
    [[ -f "$file" ]] || fail "$file must be a regular file"
    candidate="$(<"$file")"
    secret_is_acceptable "$candidate" || fail "$file contains an invalid secret"
  else
    candidate="$(read_env_value "$key")"
    if ! secret_is_acceptable "$candidate"; then
      candidate="$(generate_secret)"
    fi
  fi
  printf '%s\n' "$candidate"
}

persist_secret() {
  local file="$1"
  local value="$2"
  local tmp_file

  tmp_file="$(mktemp "${file}.tmp.XXXXXX")"
  chmod 600 -- "$tmp_file"
  printf '%s\n' "$value" >"$tmp_file"
  mv -f -- "$tmp_file" "$file"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

if [[ ${APP_DATA_DIR+x} ]]; then
  APP_DATA_DIR_RAW="$APP_DATA_DIR"
else
  APP_DATA_DIR_RAW="$(read_env_value APP_DATA_DIR)"
fi
APP_DATA_DIR_RAW="$(strip_matching_quotes "${APP_DATA_DIR_RAW:-./data}")"

[[ -n "$APP_DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be empty"
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
[[ ! -L "$APP_DATA_DIR_ABS" ]] || fail "APP_DATA_DIR must not be a symbolic link"
if [[ -e "$APP_DATA_DIR_ABS" && ! -d "$APP_DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi
mkdir -p -- "$APP_DATA_DIR_ABS"
chmod 700 -- "$APP_DATA_DIR_ABS"

MASTER_FILE="${APP_DATA_DIR_ABS}/.litellm-master-key"
SALT_FILE="${APP_DATA_DIR_ABS}/.litellm-salt-key"
MASTER_FINAL="$(resolve_secret LITELLM_MASTER_KEY "$MASTER_FILE")"
SALT_FINAL="$(resolve_secret LITELLM_SALT_KEY "$SALT_FILE")"

[[ "$MASTER_FINAL" != "$SALT_FINAL" ]] || fail "LITELLM_MASTER_KEY and LITELLM_SALT_KEY must be different"

persist_secret "$MASTER_FILE" "$MASTER_FINAL"
persist_secret "$SALT_FILE" "$SALT_FINAL"
write_env_value LITELLM_MASTER_KEY "$MASTER_FINAL"
write_env_value LITELLM_SALT_KEY "$SALT_FINAL"
chmod 600 -- "$ENV_FILE" "$MASTER_FILE" "$SALT_FILE"
