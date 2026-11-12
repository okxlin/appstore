#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

resolve_app_path() {
  local raw="$1"
  local clean candidate resolved current part
  local -a parts=()
  case "$raw" in
    ""|/*|.|..|../*|*/../*|*/..) fail 'unsafe CONFIG_PATH' ;;
  esac
  [[ ! "$raw" =~ [[:cntrl:]] ]] || fail 'unsafe CONFIG_PATH'
  clean="${raw#./}"
  [[ -n "$clean" ]] || fail 'unsafe CONFIG_PATH'
  command -v realpath >/dev/null 2>&1 || fail 'realpath is required'
  candidate="$ROOT_DIR/$clean"
  resolved="$(realpath -m -- "$candidate")" || fail 'unsafe CONFIG_PATH'
  case "$resolved" in
    "$ROOT_DIR"/*) ;;
    *) fail 'CONFIG_PATH must stay inside the application directory' ;;
  esac
  current="$ROOT_DIR"
  IFS='/' read -r -a parts <<< "$clean"
  for part in "${parts[@]}"; do
    [[ -z "$part" || "$part" == '.' ]] && continue
    current="$current/$part"
    [[ ! -L "$current" ]] || fail 'CONFIG_PATH must not traverse symbolic links'
  done
  printf '%s\n' "$resolved"
}

CONFIG_PATH_RAW="${CONFIG_PATH-}"
if [[ -z "$CONFIG_PATH_RAW" && -f "$ENV_FILE" ]]; then
  CONFIG_PATH_RAW="$(sed -n -E \
    -e 's/^[[:space:]]*export[[:space:]]+CONFIG_PATH[[:space:]]*=[[:space:]]*//p' \
    -e 's/^[[:space:]]*CONFIG_PATH[[:space:]]*=[[:space:]]*//p' \
    "$ENV_FILE" | tail -n 1)"
fi
case "$CONFIG_PATH_RAW" in
  \"*\") CONFIG_PATH_RAW="${CONFIG_PATH_RAW#\"}"; CONFIG_PATH_RAW="${CONFIG_PATH_RAW%\"}" ;;
  \'*\') CONFIG_PATH_RAW="${CONFIG_PATH_RAW#\'}"; CONFIG_PATH_RAW="${CONFIG_PATH_RAW%\'}" ;;
esac
CONFIG_PATH_RAW="${CONFIG_PATH_RAW:-./data/config}"
if printf '%s' "$CONFIG_PATH_RAW" | LC_ALL=C grep -q '[[:cntrl:]]'; then
  fail 'unsafe CONFIG_PATH'
fi
if [[ "$CONFIG_PATH_RAW" =~ $'\n' ]]; then
  fail 'unsafe CONFIG_PATH'
fi
if printf '%s' "$CONFIG_PATH_RAW" | grep -Eq '(^|/)\.\.(/|$)'; then
  fail 'CONFIG_PATH cannot contain parent path segments'
fi
command -v realpath >/dev/null 2>&1 || fail 'realpath is required'

if [[ "${CONFIG_PATH_RAW:0:1}" == '/' ]]; then
  [[ "$CONFIG_PATH_RAW" != '/' ]] || fail 'CONFIG_PATH cannot be /'
  [[ -d "$CONFIG_PATH_RAW" ]] || fail 'absolute CONFIG_PATH must be an existing directory'
  CONFIG_PATH_EXTERNAL="$(realpath -e -- "$CONFIG_PATH_RAW")" || fail 'invalid absolute CONFIG_PATH'
  [[ "$CONFIG_PATH_EXTERNAL" != '/' ]] || fail 'CONFIG_PATH cannot resolve to /'
  exit 0
fi

CONFIG_PATH_RESOLVED="$(resolve_app_path "$CONFIG_PATH_RAW")"
mkdir -p -- "$CONFIG_PATH_RESOLVED"
CONFIG_PATH_RESOLVED="$(resolve_app_path "$CONFIG_PATH_RAW")"
if [[ "${CONFIG_PATH_RAW:0:2}" == './' ]]; then
  chown -R 1000:1000 -- "$CONFIG_PATH_RESOLVED" 2>/dev/null || true
fi
