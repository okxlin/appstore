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

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.pulse-env.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { written = 0 }
    $0 ~ "^" key "=" {
      if (!written) {
        print key "=" value
        written = 1
      }
      next
    }
    { print }
    END { if (!written) print key "=" value }
  ' "$ENV_FILE" > "$temp_file"
  chmod 0600 "$temp_file"
  mv -- "$temp_file" "$ENV_FILE"
}

validate_port() {
  local value="$1"
  [[ "$value" =~ ^[0-9]+$ ]] || fail "PANEL_APP_PORT_HTTP must be an integer"
  ((10#$value >= 1 && 10#$value <= 65535)) || fail "PANEL_APP_PORT_HTTP must be between 1 and 65535"
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must be a regular file"

validate_port "$(configured_value PANEL_APP_PORT_HTTP)"

admin_user="$(configured_value PULSE_AUTH_USER)"
[[ "$admin_user" =~ ^[A-Za-z0-9._@-]{1,64}$ ]] || fail "PULSE_AUTH_USER contains unsupported characters"

admin_password="$(configured_value PULSE_AUTH_PASS)"
if [[ -z "$admin_password" || "$admin_password" == "generate" ]]; then
  command -v base64 >/dev/null 2>&1 || fail "base64 is required to generate PULSE_AUTH_PASS"
  random_material="$(head -c 48 /dev/urandom | base64 | tr -dc A-Za-z0-9)"
  admin_password="${random_material:0:32}"
fi
[[ "$admin_password" =~ ^[A-Za-z0-9._~!%^+=:@,-]{12,128}$ ]] || fail "PULSE_AUTH_PASS must contain 12 to 128 dotenv-safe characters"

timezone="$(configured_value PULSE_TIMEZONE)"
[[ "$timezone" =~ ^[A-Za-z0-9_+/-]{1,64}$ && "$timezone" != *..* ]] || fail "PULSE_TIMEZONE contains unsupported characters"

telemetry="$(configured_value PULSE_TELEMETRY)"
[[ "$telemetry" == "true" || "$telemetry" == "false" ]] || fail "PULSE_TELEMETRY must be true or false"

data_raw="$(configured_value APP_DATA_DIR)"
[[ "$data_raw" =~ ^\.?/?[A-Za-z0-9._/-]+$ ]] || fail "APP_DATA_DIR must be a relative path using safe characters"
[[ "$data_raw" != /* ]] || fail "APP_DATA_DIR must be relative to the application version directory"
data_dir="$(realpath -m -- "${ROOT_DIR}/${data_raw#./}")"
case "$data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR must stay inside the application version directory" ;;
esac
[[ ! -L "$data_dir" ]] || fail "APP_DATA_DIR must not be a symbolic link"
[[ ! -e "$data_dir" || -d "$data_dir" ]] || fail "APP_DATA_DIR must be a directory"

install -d -m 0750 -- "$data_dir"
resolved_data_dir="$(realpath -e -- "$data_dir")"
case "$resolved_data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
unexpected_symlink="$(find "$resolved_data_dir" -xdev -type l -print -quit)" || fail "Unable to inspect APP_DATA_DIR links"
[[ -z "$unexpected_symlink" ]] || fail "APP_DATA_DIR must not contain symbolic links"

if [[ "$(id -u)" -eq 0 ]]; then
  chown -R --no-dereference 1000:1000 "$resolved_data_dir"
else
  [[ "$(stat -c '%u:%g' "$resolved_data_dir")" == "1000:1000" ]] || fail "APP_DATA_DIR must be owned by 1000:1000"
fi
chmod 0750 "$resolved_data_dir"

set_env_value PULSE_AUTH_PASS "$admin_password"
chmod 0600 "$ENV_FILE"
