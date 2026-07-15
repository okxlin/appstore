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

  [[ ${#value} -ge 32 ]] || return 1
  case "$value" in
    *[!A-Za-z0-9._~!@%+=:,-]*) return 1 ;;
    *) return 0 ;;
  esac
}

generate_secret() {
  local value

  value="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  [[ "$value" =~ ^[0-9a-f]{64}$ ]] || fail "Unable to generate DIRECTUS_SECRET"
  printf '%s\n' "$value"
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

persist_secret() {
  local value="$1"
  local tmp_file

  tmp_file="$(mktemp "${APP_DATA_DIR_ABS}/.directus-secret.tmp.XXXXXX")"
  chmod 600 -- "$tmp_file"
  printf '%s\n' "$value" >"$tmp_file"
  mv -f -- "$tmp_file" "$SECRET_FILE"
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

for directory in database uploads extensions; do
  target="${APP_DATA_DIR_ABS}/${directory}"
  [[ ! -L "$target" ]] || fail "$target must not be a symbolic link"
  if [[ -e "$target" && ! -d "$target" ]]; then
    fail "$target must be a directory"
  fi
  mkdir -p -- "$target"
  chown 1000:1000 -- "$target"
  chmod 700 -- "$target"
done

SECRET_FILE="${APP_DATA_DIR_ABS}/.directus-secret"
[[ ! -L "$SECRET_FILE" ]] || fail "$SECRET_FILE must not be a symbolic link"

if [[ -e "$SECRET_FILE" ]]; then
  [[ -f "$SECRET_FILE" ]] || fail "$SECRET_FILE must be a regular file"
  DIRECTUS_SECRET_FINAL="$(<"$SECRET_FILE")"
  secret_is_acceptable "$DIRECTUS_SECRET_FINAL" || fail "$SECRET_FILE contains an invalid secret"
else
  if [[ ${DIRECTUS_SECRET+x} ]]; then
    DIRECTUS_SECRET_CANDIDATE="$DIRECTUS_SECRET"
  else
    DIRECTUS_SECRET_CANDIDATE="$(read_env_value DIRECTUS_SECRET)"
  fi
  if secret_is_acceptable "$DIRECTUS_SECRET_CANDIDATE"; then
    DIRECTUS_SECRET_FINAL="$DIRECTUS_SECRET_CANDIDATE"
  else
    DIRECTUS_SECRET_FINAL="$(generate_secret)"
  fi
  persist_secret "$DIRECTUS_SECRET_FINAL"
fi

chmod 600 -- "$SECRET_FILE"
write_env_value DIRECTUS_SECRET "$DIRECTUS_SECRET_FINAL"
