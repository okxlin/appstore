#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
CONFIG_PATH_VALUE="${CONFIG_PATH-./data/config}"
PICTURES_PATH_VALUE="${PICTURES_PATH-./data/pictures}"

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

[[ -n "$CONFIG_PATH_VALUE" ]] || fail "CONFIG_PATH must not be empty"
[[ ! "$CONFIG_PATH_VALUE" =~ [[:cntrl:]] ]] || fail "unsafe CONFIG_PATH"
[[ -n "$PICTURES_PATH_VALUE" ]] || fail "PICTURES_PATH must not be empty"
[[ ! "$PICTURES_PATH_VALUE" =~ [[:cntrl:]] ]] || fail "unsafe PICTURES_PATH"
command -v realpath >/dev/null 2>&1 || fail "realpath is required"

CONFIG_PATH_INTERNAL=0
if test "${CONFIG_PATH_VALUE#/}" != "$CONFIG_PATH_VALUE"; then
  CONFIG_PATH="$(realpath -e -- "$CONFIG_PATH_VALUE")" || fail "absolute CONFIG_PATH must already exist"
  [[ -d "$CONFIG_PATH" && "$CONFIG_PATH" != / && "$CONFIG_PATH" != "$ROOT_DIR" ]] || fail "absolute CONFIG_PATH must be an existing non-root directory"
else
  CONFIG_PATH_CANDIDATE="$ROOT_DIR/$CONFIG_PATH_VALUE"
  CONFIG_PATH_RESOLVED="$(realpath -e -- "$CONFIG_PATH_CANDIDATE" 2>/dev/null || true)"
  if test -z "$CONFIG_PATH_RESOLVED"; then
    CONFIG_PATH_INTERNAL=1
  else
    if test "$CONFIG_PATH_RESOLVED" = "$ROOT_DIR"; then
      fail "CONFIG_PATH must not point to the app directory"
    else
      if test "${CONFIG_PATH_RESOLVED#"$ROOT_DIR"/}" != "$CONFIG_PATH_RESOLVED"; then
        CONFIG_PATH_INTERNAL=1
      else
        CONFIG_PATH="$CONFIG_PATH_RESOLVED"
        [[ -d "$CONFIG_PATH" && "$CONFIG_PATH" != / ]] || fail "external CONFIG_PATH must be an existing non-root directory"
      fi
    fi
  fi
fi

PICTURES_PATH_INTERNAL=0
if test "${PICTURES_PATH_VALUE#/}" != "$PICTURES_PATH_VALUE"; then
  PICTURES_PATH="$(realpath -e -- "$PICTURES_PATH_VALUE")" || fail "absolute PICTURES_PATH must already exist"
  [[ -d "$PICTURES_PATH" && "$PICTURES_PATH" != / && "$PICTURES_PATH" != "$ROOT_DIR" ]] || fail "absolute PICTURES_PATH must be an existing non-root directory"
else
  PICTURES_PATH_CANDIDATE="$ROOT_DIR/$PICTURES_PATH_VALUE"
  PICTURES_PATH_RESOLVED="$(realpath -e -- "$PICTURES_PATH_CANDIDATE" 2>/dev/null || true)"
  if test -z "$PICTURES_PATH_RESOLVED"; then
    PICTURES_PATH_INTERNAL=1
  else
    if test "$PICTURES_PATH_RESOLVED" = "$ROOT_DIR"; then
      fail "PICTURES_PATH must not point to the app directory"
    else
      if test "${PICTURES_PATH_RESOLVED#"$ROOT_DIR"/}" != "$PICTURES_PATH_RESOLVED"; then
        PICTURES_PATH_INTERNAL=1
      else
        PICTURES_PATH="$PICTURES_PATH_RESOLVED"
        [[ -d "$PICTURES_PATH" && "$PICTURES_PATH" != / ]] || fail "external PICTURES_PATH must be an existing non-root directory"
      fi
    fi
  fi
fi

if [[ "$CONFIG_PATH_INTERNAL" == 1 ]]; then
  CONFIG_PATH="$(resolve_app_path "CONFIG_PATH" "$CONFIG_PATH_VALUE")"
  mkdir -p -- "$CONFIG_PATH"
  CONFIG_PATH_ACTUAL="$(realpath -e -- "$CONFIG_PATH")" || fail "unsafe CONFIG_PATH"
  [[ "$CONFIG_PATH_ACTUAL" == "$CONFIG_PATH" && -d "$CONFIG_PATH" && ! -L "$CONFIG_PATH" ]] || fail "CONFIG_PATH must resolve to a real directory"
  chown --no-dereference 1000:1000 -- "$CONFIG_PATH"
fi

if [[ "$PICTURES_PATH_INTERNAL" == 1 ]]; then
  PICTURES_PATH="$(resolve_app_path "PICTURES_PATH" "$PICTURES_PATH_VALUE")"
  mkdir -p -- "$PICTURES_PATH"
  PICTURES_PATH_ACTUAL="$(realpath -e -- "$PICTURES_PATH")" || fail "unsafe PICTURES_PATH"
  [[ "$PICTURES_PATH_ACTUAL" == "$PICTURES_PATH" && -d "$PICTURES_PATH" && ! -L "$PICTURES_PATH" ]] || fail "PICTURES_PATH must resolve to a real directory"
  chown --no-dereference 1000:1000 -- "$PICTURES_PATH"
fi
