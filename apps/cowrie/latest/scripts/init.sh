#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

DATA_DIR="${APP_DATA_DIR:-./data}"

# Strip matching single or double quotes from .env values if present
if [[ -f "$ENV_FILE" ]]; then
  while IFS='=' read -r key value; do
    [[ -z "$key" || "$key" =~ ^# ]] && continue
    value="${value#\"}"
    value="${value%\"}"
    value="${value#\'}"
    value="${value%\'}"
    case "$key" in
      APP_DATA_DIR) DATA_DIR="$value" ;;
    esac
  done < "$ENV_FILE"
fi

# Resolve relative path against app version root
if [[ ! "$DATA_DIR" = /* ]]; then
  DATA_DIR="$ROOT_DIR/$DATA_DIR"
fi

mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/lib/cowrie/downloads" \
  "$DATA_DIR/lib/cowrie/snapshots" \
  "$DATA_DIR/lib/cowrie/tty" \
  "$DATA_DIR/log/cowrie" \
  "$DATA_DIR/run"
chown -R 999:999 "$DATA_DIR"
