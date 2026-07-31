#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
LIBRARR_UID=1000
LIBRARR_GID=1000

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  local value=""
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

reject_symlink_components() {
  local path="$1"
  local current=""
  local component
  IFS='/' read -r -a components <<< "${path#/}"
  for component in "${components[@]}"; do
    [[ -n "$component" ]] || continue
    current="${current}/${component}"
    [[ ! -L "$current" ]] || fail "$path must not contain symbolic-link components"
  done
}

prepare_media_dir() {
  local key="$1"
  local raw=""
  local candidate=""
  local resolved=""
  local scope=""
  local existed=false

  raw="$(read_env_value "$key")"
  [[ -n "$raw" ]] || fail "$key must not be empty"
  [[ "$raw" =~ ^[A-Za-z0-9._/\ -]+$ ]] || fail "$key contains unsupported characters"

  if [[ "$raw" == /* ]]; then
    candidate="$raw"
    scope="absolute"
  else
    candidate="${ROOT_DIR}/${raw#./}"
    scope="application"
  fi

  reject_symlink_components "$candidate"
  resolved="$(realpath -m -- "$candidate")" || fail "Unable to resolve $key"
  [[ "$resolved" != "/" ]] || fail "$key must not be the filesystem root"
  if [[ "$scope" == "application" ]]; then
    case "$resolved" in
      "${ROOT_DIR}"/*) ;;
      *) fail "Relative $key must stay inside the application version directory" ;;
    esac
  fi
  [[ ! -e "$resolved" || -d "$resolved" ]] || fail "$key must be a directory"
  [[ -d "$resolved" ]] && existed=true

  if [[ "$scope" == "absolute" && "$existed" == "true" ]]; then
    local incompatible_owner=""
    incompatible_owner="$(find "$resolved" -xdev \( ! -uid "$LIBRARR_UID" -o ! -gid "$LIBRARR_GID" \) -print -quit)" || \
      fail "Unable to inspect $key ownership"
    [[ -z "$incompatible_owner" ]] || fail "Existing absolute $key tree must be owned by ${LIBRARR_UID}:${LIBRARR_GID}"
  fi

  install -d -m 0750 -o "$LIBRARR_UID" -g "$LIBRARR_GID" -- "$resolved" || \
    fail "Unable to prepare $key"
  local verified=""
  verified="$(realpath -e -- "$resolved")" || fail "Unable to verify $key"
  [[ "$verified" == "$resolved" ]] || fail "$key changed while it was being prepared"
  if [[ "$scope" == "application" ]]; then
    case "$verified" in
      "${ROOT_DIR}"/*) ;;
      *) fail "$key resolves outside the application version directory" ;;
    esac
    chown -R --no-dereference "$LIBRARR_UID:$LIBRARR_GID" "$verified" || \
      fail "Unable to set $key ownership"
  elif [[ "$existed" == "false" ]]; then
    chown "$LIBRARR_UID:$LIBRARR_GID" "$verified" || fail "Unable to set $key ownership"
  fi
  chmod 0750 "$verified" || fail "Unable to set $key permissions"
  printf '%s\n' "$verified"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"
[[ "$(id -u)" -eq 0 ]] || fail "Librarr init must run as root to prepare media-directory ownership"

data_dir="$(prepare_media_dir APP_DATA_DIR)"
ebook_dir="$(prepare_media_dir APP_EBOOK_DIR)"
audiobook_dir="$(prepare_media_dir APP_AUDIOBOOK_DIR)"
manga_dir="$(prepare_media_dir APP_MANGA_DIR)"

[[ "$data_dir" != "$ebook_dir" && "$data_dir" != "$audiobook_dir" && "$data_dir" != "$manga_dir" && \
   "$ebook_dir" != "$audiobook_dir" && "$ebook_dir" != "$manga_dir" && "$audiobook_dir" != "$manga_dir" ]] || \
  fail "Librarr data and media directories must be distinct"
