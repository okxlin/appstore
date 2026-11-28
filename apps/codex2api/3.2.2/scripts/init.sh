#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

read_env() {
  local value

  value="$(sed -n "s/^${1}=//p" "$ENV_FILE" | tail -n 1)"
  if [[ ${#value} -ge 2 && "${value:0:1}" == "${value: -1}" && "${value:0:1}" =~ [\"\'] ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "$value"
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || {
  printf '%s\n' "$ENV_FILE must be a regular file" >&2
  exit 1
}

DATA_DIR="$(read_env APP_DATA_DIR)"
DATA_DIR="${DATA_DIR:-./data}"
case "$DATA_DIR" in
  /*) DATA_DIR="$(realpath -m -- "$DATA_DIR")" ;;
  *)
    DATA_DIR="$(realpath -m -- "${ROOT_DIR}/${DATA_DIR#./}")"
    [[ "$DATA_DIR" == "$ROOT_DIR" || "$DATA_DIR" == "$ROOT_DIR/"* ]] || {
      printf '%s\n' "Relative APP_DATA_DIR must stay inside the application directory" >&2
      exit 1
    }
    ;;
esac

[[ "$DATA_DIR" != / ]] || {
  printf '%s\n' "APP_DATA_DIR must not be the filesystem root" >&2
  exit 1
}

mkdir -p "$DATA_DIR/data" "$DATA_DIR/logs"
