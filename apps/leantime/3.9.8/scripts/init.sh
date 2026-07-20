#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

read_env_value() {
  local value=""
  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n 's/^LEAN_DATA_DIR=//p' "$ENV_FILE" | tail -n 1)"
  fi
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

data_dir="${LEAN_DATA_DIR:-$(read_env_value)}"
data_dir="${data_dir:-./data}"
if [[ "$data_dir" != /* ]]; then
  data_dir="$ROOT_DIR/${data_dir#./}"
fi

require_managed_data_dir() {
  case "$data_dir" in
    "$managed_root"|"$managed_root"/*) ;;
    *)
      echo "LEAN_DATA_DIR must stay under ./data" >&2
      exit 1
      ;;
  esac
}

data_dir="$(readlink -m "$data_dir")"
managed_root="$(readlink -m "$ROOT_DIR/data")"
require_managed_data_dir
mkdir -p "$data_dir"
data_dir="$(readlink -f "$data_dir")"
managed_root="$(readlink -f "$ROOT_DIR/data")"
require_managed_data_dir
for required_dir in public_userfiles userfiles plugins logs; do
  path="$data_dir/$required_dir"
  mkdir -p "$path"
  if [[ -L "$path" || ! -d "$path" ]]; then
    echo "required data path must be a directory: $required_dir" >&2
    exit 1
  fi
done
chown -R --no-dereference 1000:1000 "$data_dir"
