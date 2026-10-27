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
  value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  if [[ ${#value} -ge 2 && "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
    value="${value:1:${#value}-2}"
  elif [[ ${#value} -ge 2 && "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.pocket-id-env.tmp.XXXXXX")"
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
    END {
      if (!written) print key "=" value
    }
  ' "$ENV_FILE" > "$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

generate_key() {
  local value=""
  if command -v openssl >/dev/null 2>&1; then
    value="$(openssl rand -base64 32 | tr -d '\n')"
  elif [[ -r /dev/urandom ]] && command -v base64 >/dev/null 2>&1; then
    value="$(head -c 32 /dev/urandom | base64 | tr -d '\n')"
  fi
  [[ "$value" =~ ^[A-Za-z0-9+/]{43}=$ ]] || fail "Unable to generate a secure Pocket ID encryption key"
  printf '%s\n' "$value"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

app_url="$(read_env_value POCKET_ID_APP_URL)"
[[ -n "$app_url" ]] || fail "POCKET_ID_APP_URL is required"
case "$app_url" in
  *$'\n'* | *$'\r'* | *\\* | *'$'* | *'#'* | *'"'* | *"'") fail "POCKET_ID_APP_URL contains unsupported dotenv characters" ;;
esac

trust_proxy="$(read_env_value POCKET_ID_TRUST_PROXY)"
[[ -n "$trust_proxy" ]] || trust_proxy=false
[[ "$trust_proxy" =~ ^(false|[0-9A-Fa-f:.,/[:space:]-]+)$ ]] || fail "POCKET_ID_TRUST_PROXY must be false or a comma-separated IP/CIDR list"

requested_key="$(read_env_value POCKET_ID_ENCRYPTION_KEY)"
if [[ -z "$requested_key" || "$requested_key" == "generate" ]]; then
  encryption_key="$(generate_key)"
else
  [[ "$requested_key" =~ ^[A-Za-z0-9+/]{43}=$ ]] || fail "POCKET_ID_ENCRYPTION_KEY must be generate or a base64-encoded 32-byte key"
  encryption_key="$requested_key"
fi

data_dir="${ROOT_DIR}/data"
[[ ! -L "$data_dir" ]] || fail "Pocket ID data directory must not be a symbolic link"
mkdir -p -- "$data_dir"
if [[ "$(id -u)" -eq 0 ]]; then
  chown 65532:65532 "$data_dir"
  chmod 700 "$data_dir"
else
  [[ "$(stat -c '%u:%g' "$data_dir")" == "65532:65532" ]] || fail "Pocket ID init must run as root to prepare the non-root data directory"
  [[ "$(stat -c '%a' "$data_dir")" == "700" ]] || fail "Pocket ID data directory must have mode 700"
fi

set_env_value POCKET_ID_APP_URL "$app_url"
set_env_value POCKET_ID_ENCRYPTION_KEY "$encryption_key"
set_env_value POCKET_ID_TRUST_PROXY "$trust_proxy"
