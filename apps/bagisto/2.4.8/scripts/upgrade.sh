#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

read_env_value() {
  local key="$1"
  local value

  [[ -f "$ENV_FILE" ]] || return
  value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  value="${value%\"}"
  value="${value#\"}"
  value="${value%\'}"
  value="${value#\'}"
  printf '%s\n' "$value"
}

DATA_DIR="${APP_DATA_DIR:-$(read_env_value APP_DATA_DIR || true)}"
DATA_DIR="${DATA_DIR:-./data/storage}"
[[ "$DATA_DIR" = /* ]] || DATA_DIR="$ROOT_DIR/$DATA_DIR"

mkdir -p \
  "$DATA_DIR/app/public" \
  "$DATA_DIR/framework/cache/data" \
  "$DATA_DIR/framework/sessions" \
  "$DATA_DIR/framework/views" \
  "$DATA_DIR/logs"
