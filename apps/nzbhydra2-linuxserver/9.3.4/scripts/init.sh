#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"

resolve_path() {
  local value="$1"
  local candidate=""
  local resolved=""
  [[ "$value" != *$'\n'* && "$value" != *$'\r'* && "$value" != *$'\t'* ]] || {
    printf '%s\n' 'Path values must not contain control characters' >&2
    return 1
  }
  if [[ "$value" == /* ]]; then
    candidate="$value"
  else
    candidate="$ROOT_DIR/${value#./}"
  fi
  resolved="$(realpath -m -- "$candidate")"
  [[ "$resolved" != / && "$resolved" != "$ROOT_DIR" ]] || {
    printf '%s\n' 'Path must not resolve to a filesystem or application root' >&2
    return 1
  }
  printf '%s\n' "$resolved"
}

paths=(
  "${CONFIG_PATH:-./data/config}"
  "${DOWNLOAD_PATH:-./data/downloads}"
)

for path in "${paths[@]}"; do
  resolved_path="$(resolve_path "$path")"
  mkdir -p -- "$resolved_path"
done
