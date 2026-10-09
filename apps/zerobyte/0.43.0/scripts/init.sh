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
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.zerobyte-env.tmp.XXXXXX")"
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
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

validate_dotenv_path() {
  local key="$1"
  local value="$2"
  [[ -n "$value" ]] || fail "$key must not be empty"
  case "$value" in
    *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *':'* | *'"'* | *"'") fail "$key contains unsupported characters" ;;
  esac
}

reject_symlink_components() {
  local key="$1"
  local candidate="$2"
  local normalized
  local current=""
  local component
  local -a components=()
  normalized="$(realpath -ms -- "$candidate")"
  IFS=/ read -ra components <<< "${normalized#/}"
  for component in "${components[@]}"; do
    current="${current}/${component}"
    [[ ! -L "$current" ]] || fail "$key must not contain symbolic-link path components"
  done
}

resolve_path() {
  local key="$1"
  local value="$2"
  if [[ "$value" = /* ]]; then
    realpath -m -- "$value"
  else
    local resolved
    resolved="$(realpath -m -- "${ROOT_DIR}/${value#./}")"
    case "$resolved" in
      "${ROOT_DIR}"/*) ;;
      *) fail "$key must stay inside the application version directory when relative" ;;
    esac
    printf '%s\n' "$resolved"
  fi
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

bind_address="$(read_env_value PANEL_APP_BIND_ADDRESS)"
[[ "$bind_address" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address"
IFS=. read -r octet1 octet2 octet3 octet4 <<< "$bind_address"
for octet in "$octet1" "$octet2" "$octet3" "$octet4"; do
  ((10#$octet <= 255)) || fail "PANEL_APP_BIND_ADDRESS contains an invalid IPv4 octet"
done

base_url="$(read_env_value BASE_URL)"
[[ "$base_url" =~ ^https?://[^[:space:]]+$ ]] || fail "BASE_URL must be an absolute HTTP or HTTPS URL"

app_secret="$(read_env_value APP_SECRET)"
if [[ -z "$app_secret" || "$app_secret" == "generate" ]]; then
  command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate APP_SECRET"
  app_secret="$(openssl rand -hex 32)"
fi
[[ "$app_secret" =~ ^[A-Fa-f0-9]{64}$ ]] || fail "APP_SECRET must contain exactly 64 hexadecimal characters"

data_raw="$(read_env_value APP_DATA_DIR)"
source_raw="$(read_env_value SOURCE_PATH)"
validate_dotenv_path APP_DATA_DIR "$data_raw"
validate_dotenv_path SOURCE_PATH "$source_raw"

[[ "$data_raw" != /* ]] || fail "APP_DATA_DIR must be relative to the application version directory"
data_candidate="${ROOT_DIR}/${data_raw#./}"
if [[ "$source_raw" = /* ]]; then
  source_candidate="$source_raw"
else
  source_candidate="${ROOT_DIR}/${source_raw#./}"
fi
reject_symlink_components APP_DATA_DIR "$data_candidate"
reject_symlink_components SOURCE_PATH "$source_candidate"
data_dir="$(resolve_path APP_DATA_DIR "$data_raw")"
source_dir="$(resolve_path SOURCE_PATH "$source_raw")"

case "$source_dir" in
  / | /boot | /boot/* | /dev | /dev/* | /etc | /etc/* | /proc | /proc/* | /run | /run/* | /sys | /sys/* | /usr | /usr/*)
    fail "SOURCE_PATH must not expose a filesystem root or system directory"
    ;;
  /home | /root | /var)
    fail "SOURCE_PATH must be a dedicated subdirectory, not $source_dir"
    ;;
esac
[[ "$source_dir" != "$ROOT_DIR" ]] || fail "SOURCE_PATH must not be the application version directory"
[[ ! -e "$data_dir" || -d "$data_dir" ]] || fail "APP_DATA_DIR must be a directory"
[[ ! -e "$source_dir" || -d "$source_dir" ]] || fail "SOURCE_PATH must be a directory"

install -d -m 0750 -- "$data_dir" "$source_dir"
data_dir="$(realpath -e -- "$data_dir")"
source_dir="$(realpath -e -- "$source_dir")"
case "$data_dir" in
  "${ROOT_DIR}"/*) ;;
  *) fail "APP_DATA_DIR resolves outside the application version directory" ;;
esac
if [[ "$source_dir" == "$data_dir" || "$source_dir" == "$data_dir"/* || "$data_dir" == "$source_dir"/* ]]; then
  fail "SOURCE_PATH and APP_DATA_DIR must be separate and must not contain one another"
fi

set_env_value APP_SECRET "$app_secret"
