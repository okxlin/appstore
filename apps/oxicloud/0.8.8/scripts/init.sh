#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

data_dir_raw="./data"
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
