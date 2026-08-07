#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
APP_ROOT_DIR="$(dirname "$ROOT_DIR")"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

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

read_env_value() {
  local key="$1"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi
  value="${value%$'\r'}"
  strip_matching_quotes "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file

  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { updated = 0 }
    $0 ~ ("^" key "=") {
      if (!updated) {
        print key "=" value
        updated = 1
      }
      next
    }
    { print }
    END {
      if (!updated) print key "=" value
    }
  ' "$ENV_FILE" >"$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

path_is_dotenv_safe() {
  local value="$1"

  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*) return 1 ;;
    *) return 0 ;;
  esac
}

[[ -f "$ENV_FILE" ]] || fail "Environment file not found: ${ENV_FILE}"
[[ ! -L "$ENV_FILE" ]] || fail "Environment file must not be a symbolic link"
[[ "$(id -u)" -eq 0 ]] || fail "HitKeep init must run as root"

if [[ ${HITKEEP_DATA_DIR+x} ]]; then
  DATA_DIR_RAW="$HITKEEP_DATA_DIR"
else
  DATA_DIR_RAW="$(read_env_value HITKEEP_DATA_DIR)"
fi
DATA_DIR_RAW="$(strip_matching_quotes "${DATA_DIR_RAW:-./data}")"

[[ -n "$DATA_DIR_RAW" ]] || fail "HITKEEP_DATA_DIR must not be empty"
path_is_dotenv_safe "$DATA_DIR_RAW" || fail "HITKEEP_DATA_DIR contains unsupported dotenv characters"

if [[ "$DATA_DIR_RAW" = /* ]]; then
  [[ ! -L "$DATA_DIR_RAW" ]] || fail "HITKEEP_DATA_DIR must not be a symbolic link"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_RAW")"
  [[ "$DATA_DIR_ABS" != "/" ]] || fail "HITKEEP_DATA_DIR must not be the filesystem root"
else
  CONTAINER_NAME_VALUE="$(read_env_value CONTAINER_NAME)"
  [[ "$CONTAINER_NAME_VALUE" =~ ^[A-Za-z0-9._-]+$ ]] || \
    fail "CONTAINER_NAME contains unsupported characters"

  RETAINED_ROOT="${APP_ROOT_DIR}/retained-data"
  [[ ! -L "$RETAINED_ROOT" ]] || fail "The retained data root must not be a symbolic link"
  RETAINED_INSTANCE_ROOT="${RETAINED_ROOT}/${CONTAINER_NAME_VALUE}"
  [[ ! -L "$RETAINED_INSTANCE_ROOT" ]] || fail "The retained instance root must not be a symbolic link"
  DATA_DIR_PATH="${RETAINED_INSTANCE_ROOT}/${DATA_DIR_RAW#./}"
  [[ ! -L "$DATA_DIR_PATH" ]] || fail "HITKEEP_DATA_DIR must not be a symbolic link"
  RETAINED_INSTANCE_ABS="$(realpath -m -- "$RETAINED_INSTANCE_ROOT")"
  DATA_DIR_ABS="$(realpath -m -- "$DATA_DIR_PATH")"
  case "$DATA_DIR_ABS" in
    "${RETAINED_INSTANCE_ABS}"/*) ;;
    *) fail "Relative HITKEEP_DATA_DIR must remain inside the isolated retained-data directory" ;;
  esac

  set_env_value HITKEEP_DATA_DIR "\"${DATA_DIR_ABS}\""
fi

if [[ -e "$DATA_DIR_ABS" && ! -d "$DATA_DIR_ABS" ]]; then
  fail "HITKEEP_DATA_DIR must be a directory"
fi
if [[ ! -e "$DATA_DIR_ABS" ]]; then
  install -d -m 0750 -- "$DATA_DIR_ABS"
  chown 65532:65532 -- "$DATA_DIR_ABS"
fi

[[ "$(stat -c '%u:%g' "$DATA_DIR_ABS")" == "65532:65532" ]] || \
  fail "HITKEEP_DATA_DIR must be owned by UID/GID 65532:65532"
