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
  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi
  if [[ ${#value} -ge 2 && "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
    value="${value:1:${#value}-2}"
  elif [[ ${#value} -ge 2 && "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "$value"
}

configured_value() {
  local key="$1"
  if [[ -v "$key" ]]; then
    printf '%s\n' "${!key}"
  else
    read_env_value "$key"
  fi
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

data_dir_raw="$(configured_value APP_DATA_DIR)"
[[ -n "$data_dir_raw" ]] || data_dir_raw="./data"
case "$data_dir_raw" in
  *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'") fail "APP_DATA_DIR contains unsupported dotenv characters" ;;
esac

case "$data_dir_raw" in
  /*) data_dir_abs="$(realpath -m -- "$data_dir_raw")" ;;
  *)
    data_dir_abs="$(realpath -m -- "${ROOT_DIR}/${data_dir_raw#./}")"
    case "$data_dir_abs" in
      "${ROOT_DIR}" | "${ROOT_DIR}"/*) ;;
      *) fail "Relative APP_DATA_DIR must stay inside the application directory" ;;
    esac
    ;;
esac

[[ "$data_dir_abs" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
if [[ -e "$data_dir_abs" && ! -d "$data_dir_abs" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi

session_key="$(configured_value COMMAFEED_SESSION_ENCRYPTION_KEY)"
[[ ${#session_key} -ge 16 ]] || fail "COMMAFEED_SESSION_ENCRYPTION_KEY must contain at least 16 characters"
case "$session_key" in
  *$'\n'* | *$'\r'*) fail "COMMAFEED_SESSION_ENCRYPTION_KEY must be a single line" ;;
esac

mkdir -p -- "$data_dir_abs"
