#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
legacy_data_dir="${APP_DATA_DIR:-}"
if [[ -z "$legacy_data_dir" && -f "$ENV_FILE" ]]; then
  legacy_data_dir="$(sed -n 's/^APP_DATA_DIR=//p' "$ENV_FILE" | tail -n 1)"
fi
case "$legacy_data_dir" in
  \"*\") legacy_data_dir="${legacy_data_dir#\"}"; legacy_data_dir="${legacy_data_dir%\"}" ;;
  \'*\') legacy_data_dir="${legacy_data_dir#\'}"; legacy_data_dir="${legacy_data_dir%\'}" ;;
esac
case "$legacy_data_dir" in
  ""|data|./data) ;;
  /*)
    legacy_data_path="$(realpath -m -- "$legacy_data_dir")"
    if [[ "$legacy_data_path" != "$ROOT_DIR/data" ]]; then
      echo "APP_DATA_DIR is no longer configurable; move the existing data into $ROOT_DIR/data before upgrading" >&2
      exit 1
    fi
    ;;
  *)
    echo "APP_DATA_DIR is no longer configurable; move the existing data into $ROOT_DIR/data before upgrading" >&2
    exit 1
    ;;
esac

"$(dirname "$0")/init.sh"
