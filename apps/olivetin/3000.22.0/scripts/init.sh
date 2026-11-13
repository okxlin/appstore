#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
TEMPLATE_FILE="${ROOT_DIR}/templates/config.yaml"
OLIVETIN_UID=1000
OLIVETIN_GID=999

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

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"
[[ -f "$TEMPLATE_FILE" && ! -L "$TEMPLATE_FILE" ]] || fail "$TEMPLATE_FILE not found or unsafe"
[[ "$(id -u)" -eq 0 ]] || fail "OliveTin init must run as root to prepare configuration ownership"

raw="$(read_env_value APP_CONFIG_DIR)"
[[ -n "$raw" ]] || fail "APP_CONFIG_DIR must not be empty"
[[ "$raw" =~ ^[A-Za-z0-9._/\ -]+$ ]] || fail "APP_CONFIG_DIR contains unsupported characters"

if [[ "$raw" == /* ]]; then
  candidate="$raw"
  scope="absolute"
else
  candidate="${ROOT_DIR}/${raw#./}"
  scope="application"
fi

reject_symlink_components "$candidate"
resolved="$(realpath -m -- "$candidate")" || fail "Unable to resolve APP_CONFIG_DIR"
[[ "$resolved" != "/" ]] || fail "APP_CONFIG_DIR must not be the filesystem root"
if [[ "$scope" == "application" ]]; then
  case "$resolved" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_CONFIG_DIR must stay inside the application version directory" ;;
  esac
fi
[[ ! -e "$resolved" || -d "$resolved" ]] || fail "APP_CONFIG_DIR must be a directory"

existed=false
[[ -d "$resolved" ]] && existed=true
if [[ "$scope" == "absolute" && "$existed" == "true" ]]; then
  incompatible_owner="$(find "$resolved" -xdev \( ! -uid "$OLIVETIN_UID" -o ! -gid "$OLIVETIN_GID" \) -print -quit)" || \
    fail "Unable to inspect APP_CONFIG_DIR ownership"
  [[ -z "$incompatible_owner" ]] || fail "Existing absolute APP_CONFIG_DIR tree must be owned by ${OLIVETIN_UID}:${OLIVETIN_GID}"
fi

install -d -m 0750 -- "$resolved" || fail "Unable to prepare APP_CONFIG_DIR"
verified="$(realpath -e -- "$resolved")" || fail "Unable to verify APP_CONFIG_DIR"
[[ "$verified" == "$resolved" ]] || fail "APP_CONFIG_DIR changed while it was being prepared"
unexpected_symlink="$(find "$verified" -xdev -type l -print -quit)" || fail "Unable to inspect APP_CONFIG_DIR links"
[[ -z "$unexpected_symlink" ]] || fail "APP_CONFIG_DIR must not contain symbolic links"
if [[ "$scope" == "application" ]]; then
  case "$verified" in
    "${ROOT_DIR}"/*) ;;
    *) fail "APP_CONFIG_DIR resolves outside the application version directory" ;;
  esac
  chown -R --no-dereference "$OLIVETIN_UID:$OLIVETIN_GID" "$verified" || fail "Unable to set APP_CONFIG_DIR ownership"
fi
chown "$OLIVETIN_UID:$OLIVETIN_GID" "$verified" || fail "Unable to set APP_CONFIG_DIR ownership"

config_file="${verified}/config.yaml"
[[ ! -L "$config_file" ]] || fail "$config_file must not be a symbolic link"
if [[ ! -e "$config_file" ]]; then
  install -m 0640 -- "$TEMPLATE_FILE" "$config_file" || \
    fail "Unable to install the starter configuration"
  chown "$OLIVETIN_UID:$OLIVETIN_GID" "$config_file" || fail "Unable to set configuration ownership"
else
  [[ -f "$config_file" ]] || fail "$config_file must be a regular file"
  [[ "$(stat -c '%u:%g' "$config_file")" == "${OLIVETIN_UID}:${OLIVETIN_GID}" ]] || \
    fail "$config_file must be owned by ${OLIVETIN_UID}:${OLIVETIN_GID}"
fi
chmod 0640 "$config_file" || fail "Unable to set configuration permissions"

install -d -m 0750 -- \
  "${verified}/logs/results" "${verified}/logs/output" || fail "Unable to prepare log directories"
chown "$OLIVETIN_UID:$OLIVETIN_GID" "${verified}/logs" \
  "${verified}/logs/results" "${verified}/logs/output" || fail "Unable to set log-directory ownership"
