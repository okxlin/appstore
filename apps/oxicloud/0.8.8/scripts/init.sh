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
  [[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

data_dir_raw="${APP_DATA_DIR:-$(read_env_value APP_DATA_DIR)}"
[[ -n "$data_dir_raw" ]] || data_dir_raw="./data"
case "$data_dir_raw" in
  *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'")
    fail "APP_DATA_DIR contains unsupported characters"
    ;;
esac

case "$data_dir_raw" in
  /*) fail "APP_DATA_DIR must be relative to the application version directory" ;;
esac

data_dir_abs="$(realpath -m -- "${ROOT_DIR}/${data_dir_raw#./}")"
case "$data_dir_abs" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR must stay inside the application version directory" ;;
esac

[[ "$data_dir_abs" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
if [[ -e "$data_dir_abs" && ! -d "$data_dir_abs" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi
install -d -m 0750 -- "$data_dir_abs"

resolved_data_dir="$(realpath -e -- "$data_dir_abs")"
case "$resolved_data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
