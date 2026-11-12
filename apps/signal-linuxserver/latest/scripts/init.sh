#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd -P)"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
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


CONFIG_PATH_RAW="${CONFIG_PATH:-./data/config}"
if printf '%s' "$CONFIG_PATH_RAW" | LC_ALL=C grep -q '[[:cntrl:]]'; then
  fail "unsafe CONFIG_PATH"
fi
if test "$(printf '%s' "$CONFIG_PATH_RAW" | wc -l)" -ne 0; then
  fail "unsafe CONFIG_PATH"
fi
if printf '%s' "$CONFIG_PATH_RAW" | grep -Eq '(^|/)\.\.(/|$)'; then
  fail "CONFIG_PATH cannot contain parent path segments"
fi
command -v realpath >/dev/null 2>&1 || fail "realpath is required"

if test "${CONFIG_PATH_RAW:0:1}" = "/"; then
  test "$CONFIG_PATH_RAW" != "/" || fail "CONFIG_PATH cannot be /"
  test -d "$CONFIG_PATH_RAW" || fail "absolute CONFIG_PATH must be an existing directory"
  CONFIG_PATH_EXTERNAL="$(realpath -e -- "$CONFIG_PATH_RAW")" || fail "invalid absolute CONFIG_PATH"
  test "$CONFIG_PATH_EXTERNAL" != "/" || fail "CONFIG_PATH cannot resolve to /"
  exit 0
fi

CONFIG_PATH_RESOLVED="$(resolve_app_path CONFIG_PATH "$CONFIG_PATH_RAW")"
mkdir -p -- "$CONFIG_PATH_RESOLVED"
CONFIG_PATH_RESOLVED="$(resolve_app_path CONFIG_PATH "$CONFIG_PATH_RAW")"
if test "${CONFIG_PATH_RAW:0:2}" = "./"; then
  chown -R 1000:1000 -- "$CONFIG_PATH_RESOLVED" 2>/dev/null || true
fi
