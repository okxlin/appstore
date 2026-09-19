#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

DATA_DIR="${APP_DATA_DIR:-./data}"
PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

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
      PUID) PUID="$value" ;;
      PGID) PGID="$value" ;;
    esac
  done < "$ENV_FILE"
fi

# Resolve relative path against app version root
if [[ ! "$DATA_DIR" = /* ]]; then
  DATA_DIR="$ROOT_DIR/$DATA_DIR"
fi

mkdir -p "$DATA_DIR"
chown -R "${PUID}:${PGID}" "$DATA_DIR"
