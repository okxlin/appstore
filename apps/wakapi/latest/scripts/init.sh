#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
APP_DATA_DIR_RAW="${APP_DATA_DIR:-}"
WAKAPI_UID=65532
WAKAPI_GID=65532

if [[ -z "$APP_DATA_DIR_RAW" && -f "$ENV_FILE" ]]; then
  APP_DATA_DIR_RAW="$(grep '^APP_DATA_DIR=' "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
fi
APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW:-./data}"

case "$APP_DATA_DIR_RAW" in
  \"*\")
    APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW#\"}"
    APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW%\"}"
    ;;
  \'*\')
    APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW#\'}"
    APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW%\'}"
    ;;
esac

if [[ -z "$APP_DATA_DIR_RAW" ]]; then
  echo "APP_DATA_DIR must not be empty" >&2
  exit 1
fi

case "$APP_DATA_DIR_RAW" in
  /*)
    APP_DATA_DIR_ABS="$(realpath -m -- "$APP_DATA_DIR_RAW")"
    APP_DATA_DIR_SCOPE="absolute"
    ;;
  *)
    APP_DATA_DIR_ABS="$(realpath -m -- "$ROOT_DIR/${APP_DATA_DIR_RAW#./}")"
    case "$APP_DATA_DIR_ABS" in
      "$ROOT_DIR"/*) ;;
      *)
        echo "Relative APP_DATA_DIR must stay inside the application directory" >&2
        exit 1
        ;;
    esac
    APP_DATA_DIR_SCOPE="application"
    ;;
esac

DATA_DIR_EXISTED=false
[[ -d "$APP_DATA_DIR_ABS" ]] && DATA_DIR_EXISTED=true
mkdir -p "$APP_DATA_DIR_ABS"

if [[ "$APP_DATA_DIR_SCOPE" == "application" || "$DATA_DIR_EXISTED" == "false" ]]; then
  chown -R "$WAKAPI_UID:$WAKAPI_GID" "$APP_DATA_DIR_ABS"
else
  CURRENT_UID="$(stat -c '%u' "$APP_DATA_DIR_ABS")"
  CURRENT_GID="$(stat -c '%g' "$APP_DATA_DIR_ABS")"
  if [[ "$CURRENT_UID" != "$WAKAPI_UID" || "$CURRENT_GID" != "$WAKAPI_GID" ]]; then
    echo "Existing absolute APP_DATA_DIR must be owned by ${WAKAPI_UID}:${WAKAPI_GID}" >&2
    exit 1
  fi
fi
