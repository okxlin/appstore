#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

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

configured_value() {
  local key="$1"
  if [[ -v "$key" ]]; then
    printf '%s\n' "${!key}"
  else
    read_env_value "$key"
  fi
}

resolve_safe_path() {
  local key="$1"
  local value="$2"
  local resolved

  [[ -n "$value" ]] || fail "$key must not be empty"
  case "$value" in
    *$'\n'* | *$'\r'* | *"\$"* | *"\`"*) fail "$key contains unsupported characters" ;;
  esac

  if [[ "$value" = /* ]]; then
    resolved="$(realpath -m -- "$value")"
    [[ "$resolved" != "/" ]] || fail "$key must not be the filesystem root"
  else
    resolved="$(realpath -m -- "${ROOT_DIR}/${value#./}")"
    case "$resolved" in
      "${ROOT_DIR}"/*) ;;
      *) fail "$key must remain inside the application version directory when relative" ;;
    esac
  fi

  [[ ! -L "$resolved" ]] || fail "$key must not be a symbolic link"
  printf '%s\n' "$resolved"
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must be a regular file"

port="$(configured_value PANEL_APP_PORT_HTTP)"
[[ "$port" =~ ^[0-9]+$ ]] || fail "PANEL_APP_PORT_HTTP must be an integer"
((10#$port >= 1 && 10#$port <= 65535)) || fail "PANEL_APP_PORT_HTTP must be between 1 and 65535"

bind_address="$(configured_value PANEL_APP_BIND_ADDRESS)"
[[ "$bind_address" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ || "$bind_address" == "::1" ]] || \
  fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address or ::1"

timezone="$(configured_value TZ)"
[[ "$timezone" =~ ^[A-Za-z0-9_+./-]+$ && "$timezone" != *..* ]] || fail "TZ contains unsupported characters"

data_dir="$(resolve_safe_path APP_DATA_DIR "$(configured_value APP_DATA_DIR)")"
photo_dir="$(resolve_safe_path PHOTO_LIBRARY_DIR "$(configured_value PHOTO_LIBRARY_DIR)")"

[[ ! -e "$data_dir" || -d "$data_dir" ]] || fail "APP_DATA_DIR must be a directory"
[[ ! -e "$photo_dir" || -d "$photo_dir" ]] || fail "PHOTO_LIBRARY_DIR must be a directory"
install -d -m 0750 -- "$data_dir"
install -d -m 0750 -- "$photo_dir"

config_file="${data_dir}/configuration.yaml"
[[ ! -L "$config_file" ]] || fail "configuration.yaml must not be a symbolic link"
[[ ! -e "$config_file" || -f "$config_file" ]] || fail "configuration.yaml must be a regular file"
if [[ ! -e "$config_file" ]]; then
  config_tmp="$(mktemp "${data_dir}/.photofield-config.XXXXXX")"
  cat > "$config_tmp" <<'YAML'
collections:
  - name: Photos
    dirs:
      - /app/photos
YAML
  chmod 0640 "$config_tmp"
  mv -- "$config_tmp" "$config_file"
fi
