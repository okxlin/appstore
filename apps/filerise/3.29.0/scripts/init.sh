#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
FILERISE_UID=1000
FILERISE_GID=1000

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
    [[ ! -L "$current" ]] || fail "APP_DATA_DIR must not contain symbolic-link components"
  done
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

bind_address="$(read_env_value PANEL_APP_BIND_ADDRESS)"
[[ "$bind_address" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address"
IFS=. read -r octet1 octet2 octet3 octet4 <<< "$bind_address"
for octet in "$octet1" "$octet2" "$octet3" "$octet4"; do
  ((10#$octet <= 255)) || fail "PANEL_APP_BIND_ADDRESS contains an invalid IPv4 octet"
done

port="$(read_env_value PANEL_APP_PORT_HTTP)"
[[ "$port" =~ ^[0-9]+$ ]] || fail "PANEL_APP_PORT_HTTP must be numeric"
((10#$port >= 1 && 10#$port <= 65535)) || fail "PANEL_APP_PORT_HTTP must be between 1 and 65535"

timezone="$(read_env_value FILERISE_TIMEZONE)"
[[ "$timezone" =~ ^[A-Za-z0-9_+/-]+$ ]] || fail "FILERISE_TIMEZONE is invalid"

upload_size="$(read_env_value FILERISE_TOTAL_UPLOAD_SIZE)"
[[ "$upload_size" =~ ^[1-9][0-9]*[KMGkmg]?$ ]] || fail "FILERISE_TOTAL_UPLOAD_SIZE must be a positive integer with an optional K, M, or G suffix"

secure="$(read_env_value FILERISE_SECURE)"
[[ "$secure" == "true" || "$secure" == "false" ]] || fail "FILERISE_SECURE must be true or false"

data_raw="${APP_DATA_DIR:-$(read_env_value APP_DATA_DIR)}"
[[ -n "$data_raw" ]] || fail "APP_DATA_DIR must not be empty"
case "$data_raw" in
  \"*\") data_raw="${data_raw#\"}"; data_raw="${data_raw%\"}" ;;
  \'*\') data_raw="${data_raw#\'}"; data_raw="${data_raw%\'}" ;;
esac
[[ -n "$data_raw" ]] || fail "APP_DATA_DIR must not be empty"
[[ "$data_raw" =~ ^[A-Za-z0-9._/\ -]+$ ]] || fail "APP_DATA_DIR contains unsupported characters"

if [[ "$data_raw" == /* ]]; then
  data_candidate="$data_raw"
  data_scope="absolute"
else
  data_candidate="${ROOT_DIR}/${data_raw#./}"
  data_scope="application"
fi

reject_symlink_components "$data_candidate"
data_dir="$(realpath -m -- "$data_candidate")"
[[ "$data_dir" != "/" ]] || fail "APP_DATA_DIR must not be the filesystem root"
if [[ "$data_scope" == "application" ]]; then
  case "$data_dir" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_DATA_DIR must stay inside the application version directory" ;;
  esac
fi
[[ ! -e "$data_dir" || -d "$data_dir" ]] || fail "APP_DATA_DIR must be a directory"

data_existed=false
[[ -d "$data_dir" ]] && data_existed=true

if [[ "$data_scope" == "absolute" && "$data_existed" == "true" ]]; then
  unexpected_owner="$(find "$data_dir" -xdev \( ! -uid "$FILERISE_UID" -o ! -gid "$FILERISE_GID" \) -print -quit)"
  [[ -z "$unexpected_owner" ]] || fail "Existing absolute APP_DATA_DIR tree must be owned by ${FILERISE_UID}:${FILERISE_GID}"
fi

for path in "$data_dir" "$data_dir/uploads" "$data_dir/users" "$data_dir/metadata"; do
  [[ ! -L "$path" ]] || fail "$path must not be a symbolic link"
  [[ ! -e "$path" || -d "$path" ]] || fail "$path must be a directory"
done

install -d -m 0750 -o "$FILERISE_UID" -g "$FILERISE_GID" -- \
  "$data_dir" "$data_dir/uploads" "$data_dir/users" "$data_dir/metadata"

resolved_data_dir="$(realpath -e -- "$data_dir")"
[[ "$resolved_data_dir" == "$data_dir" ]] || fail "APP_DATA_DIR changed while it was being prepared"
if [[ "$data_scope" == "application" ]]; then
  case "$resolved_data_dir" in
    "${ROOT_DIR}"/*) ;;
    *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
  esac
fi

if [[ "$data_scope" == "application" || "$data_existed" == "false" ]]; then
  chown -R "$FILERISE_UID:$FILERISE_GID" -- "$data_dir"
fi
chmod 0750 -- "$data_dir"
chmod 0770 -- "$data_dir/uploads" "$data_dir/users" "$data_dir/metadata"
