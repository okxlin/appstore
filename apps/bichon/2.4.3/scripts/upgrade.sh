#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
APP_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
ADMIN_IMAGE="rustmailer/bichon:2.3.0"

read_env_value() {
  local key="$1"
  local value
  [[ -f "$ENV_FILE" ]] || return 0
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  value="${value%$'\r'}"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

"$SCRIPT_DIR/init.sh"

APP_DATA_DIR="${APP_DATA_DIR:-$(read_env_value APP_DATA_DIR)}"
APP_DATA_DIR="${APP_DATA_DIR:-./data}"
if [[ "$APP_DATA_DIR" = /* ]]; then
  RESOLVED_DATA_DIR="$(realpath -m -- "$APP_DATA_DIR")"
else
  RESOLVED_DATA_DIR="$(realpath -m -- "$APP_DIR/${APP_DATA_DIR#./}")"
  case "$RESOLVED_DATA_DIR" in
    "$APP_DIR"/*) ;;
    *)
      printf 'Relative APP_DATA_DIR must remain inside the application directory\n' >&2
      exit 1
      ;;
  esac
fi
[[ -d "$RESOLVED_DATA_DIR" ]] || {
  printf 'APP_DATA_DIR does not exist: %s\n' "$RESOLVED_DATA_DIR" >&2
  exit 1
}

docker_args=(docker run --rm --network none --user 1000:1000 --mount "type=bind,source=$RESOLVED_DATA_DIR,target=/data" --env BICHON_ROOT_DIR=/data)
if [[ -n "${BICHON_INDEX_DIR:-$(read_env_value BICHON_INDEX_DIR)}" ]]; then
  docker_args+=(--env "BICHON_INDEX_DIR=${BICHON_INDEX_DIR:-$(read_env_value BICHON_INDEX_DIR)}")
fi

storage_state() {
  "${docker_args[@]}" --entrypoint sh "$ADMIN_IMAGE" -c '
    set -eu
    root=/data
    storage="$root/bichon-storage"
    version=0
    if [ -f "$root/STORAGE_VERSION" ]; then
      version="$(cat "$root/STORAGE_VERSION")"
    fi
    case "$version" in
      ""|*[!0-9]*) echo INVALID; exit 0 ;;
    esac
    if [ -d "$storage/blobs" ]; then
      if [ "$version" -ge 2 ]; then echo CURRENT; else echo PARTIAL; fi
    elif [ -d "$storage" ]; then
      if [ "$version" -lt 2 ]; then echo LEGACY; else echo INVALID; fi
    elif [ "$version" -eq 0 ]; then
      echo CLEAN
    else
      echo INVALID
    fi
  '
}

state="$(storage_state)"
case "$state" in
  CLEAN|CURRENT)
    ;;
  LEGACY)
    if ! command -v script >/dev/null 2>&1; then
      printf 'The util-linux script command is required for the Bichon v1 storage migration\n' >&2
      exit 1
    fi

    printf -v admin_command '%q ' "${docker_args[@]}" --interactive --tty --entrypoint bichon-admin "$ADMIN_IMAGE"
    {
      sleep 0.2
      printf '\033[B\033[B\r'
      sleep 0.2
      printf '/data\r'
      sleep 0.2
      printf '\r'
      sleep 0.2
      printf '\r'
      sleep 0.2
      printf '\r'
    } | script -qefc "$admin_command" /dev/null

    state="$(storage_state)"
    if [[ "$state" != CURRENT ]]; then
      printf 'Bichon v1 storage migration did not reach storage version 2 (state: %s)\n' "$state" >&2
      exit 1
    fi
    ;;
  *)
    printf 'Unrecognized or incomplete Bichon storage layout (state: %s); refusing to start the upgraded app\n' "$state" >&2
    exit 1
    ;;
esac
