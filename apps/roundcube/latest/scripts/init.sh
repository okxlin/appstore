#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

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

DATA_DIR_RAW="${APP_DATA_DIR:-./data}"
DATA_DIR="$(resolve_app_path APP_DATA_DIR "$DATA_DIR_RAW")"
mkdir -p -- "$DATA_DIR"
DATA_DIR="$(resolve_app_path APP_DATA_DIR "$DATA_DIR_RAW")"

for SUBDIR in db config enigma; do
  TARGET_RAW="${DATA_DIR_RAW%/}/${SUBDIR}"
  TARGET_DIR="$(resolve_app_path APP_DATA_DIR "$TARGET_RAW")"
  mkdir -p -- "$TARGET_DIR"
  TARGET_DIR="$(resolve_app_path APP_DATA_DIR "$TARGET_RAW")"

  case "$SUBDIR" in
    db|enigma) chown -R 33:33 "$TARGET_DIR" 2>/dev/null || true ;;
    config) chmod 755 "$TARGET_DIR" 2>/dev/null || true ;;
  esac
done
