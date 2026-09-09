#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

read_env_value() {
  local value=""
  [[ -f "$ENV_FILE" ]] || return 0
  value="$(sed -n "s/^APP_DATA_DIR=//p" "$ENV_FILE" | tail -n 1)"
  value="${value#\"}"
  value="${value%\"}"
  value="${value#\'}"
  value="${value%\'}"
  printf '%s\n' "$value"
}

data_dir_value="${APP_DATA_DIR:-$(read_env_value)}"
data_dir_value="${data_dir_value:-./data}"
data_dir_is_absolute=false
case "$data_dir_value" in
  /) echo "refusing to use / as APP_DATA_DIR" >&2; exit 1 ;;
  /*) data_dir="$data_dir_value"; data_dir_is_absolute=true ;;
  *) data_dir="$ROOT_DIR/${data_dir_value#./}" ;;
esac

data_dir="$(readlink -f -- "$data_dir")"
case "$data_dir" in
  /) echo "refusing to use / as APP_DATA_DIR" >&2; exit 1 ;;
esac
if [[ "$data_dir_is_absolute" == false && "$data_dir" != "$ROOT_DIR/"* ]]; then
  echo "refusing relative APP_DATA_DIR outside the app directory" >&2
  exit 1
fi

mkdir -p -- "$data_dir"
chown -R 1000:1000 -- "$data_dir"
