#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
CONFIG_PATH_VALUE="${CONFIG_PATH:-./data/config}"

fail() {
  echo "$1" >&2
  exit 1
}

[[ -n "$CONFIG_PATH_VALUE" ]] || fail "CONFIG_PATH must not be empty"
[[ ! "$CONFIG_PATH_VALUE" =~ [[:cntrl:]] ]] || fail "unsafe CONFIG_PATH: control characters are not allowed"

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

if grep -q '^/' <<< "$CONFIG_PATH_VALUE"; then
  ABSOLUTE_CONFIG_PATH="$(realpath -e -- "$CONFIG_PATH_VALUE")" || fail "unsafe CONFIG_PATH: absolute paths must already exist"
  test -d "$ABSOLUTE_CONFIG_PATH" || fail "unsafe CONFIG_PATH: absolute path must be a directory"
  test "$ABSOLUTE_CONFIG_PATH" != / || fail "unsafe CONFIG_PATH: absolute path must be a non-root directory"
  exit 0
fi

CONFIG_PATH="$(resolve_app_path "CONFIG_PATH" "$CONFIG_PATH_VALUE")"
mkdir -p -- "$CONFIG_PATH"
[[ -d "$CONFIG_PATH" && ! -L "$CONFIG_PATH" ]] || fail "unsafe CONFIG_PATH: expected a real directory"
[[ "$(resolve_app_path "CONFIG_PATH" "$CONFIG_PATH_VALUE")" == "$CONFIG_PATH" ]] || fail "unsafe CONFIG_PATH: path changed during initialization"
chown -R --no-dereference 1000:1000 -- "$CONFIG_PATH"
