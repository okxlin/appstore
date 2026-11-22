#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

strip_matching_quotes() {
  local value="$1"

  if [[ ${#value} -ge 2 ]]; then
    if [[ "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
      value="${value:1:${#value}-2}"
    elif [[ "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
      value="${value:1:${#value}-2}"
    fi
  fi
  printf '%s\n' "$value"
}

if [[ ${SAFELINE_DIR+x} ]]; then
  DATA_DIR_RAW="$SAFELINE_DIR"
elif [[ -f "$ENV_FILE" ]]; then
  DATA_DIR_RAW="$(sed -n 's/^SAFELINE_DIR=//p' "$ENV_FILE" | tail -n 1)"
else
  DATA_DIR_RAW="./data"
fi
DATA_DIR_RAW="$(strip_matching_quotes "${DATA_DIR_RAW:-./data}")"

[[ "$DATA_DIR_RAW" != *$'\n'* && "$DATA_DIR_RAW" != *$'\r'* ]] || {
  echo "SAFELINE_DIR must be a single-line path" >&2
  exit 1
}

if [[ "$DATA_DIR_RAW" = /* ]]; then
  DATA_DIR="$(realpath -m -- "$DATA_DIR_RAW")"
else
  DATA_DIR="$(realpath -m -- "${ROOT_DIR}/${DATA_DIR_RAW#./}")"
fi
[[ "$DATA_DIR" != "/" ]] || {
  echo "SAFELINE_DIR must not be the filesystem root" >&2
  exit 1
}

mkdir -p -- \
  "$DATA_DIR/resources/mgt" \
  "$DATA_DIR/resources/sock" \
  "$DATA_DIR/resources/detector" \
  "$DATA_DIR/resources/nginx" \
  "$DATA_DIR/resources/chaos" \
  "$DATA_DIR/resources/cache" \
  "$DATA_DIR/resources/luigi" \
  "$DATA_DIR/resources/postgres/data" \
  "$DATA_DIR/logs/nginx" \
  "$DATA_DIR/logs/detector"
