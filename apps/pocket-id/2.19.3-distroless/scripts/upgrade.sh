#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local content="$1"
  local key="$2"
  local value=""
  value="$(printf '%s\n' "$content" | awk -F '=' -v key="$key" '$1 == key { sub(/^[^=]*=/, ""); value = $0 } END { print value }')"
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
  if ! awk -v key="$key" -v value="$value" '
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
  ' "$ENV_FILE" > "$temp_file"; then
    rm -f -- "$temp_file"
    fail "Unable to prepare the Pocket ID environment file"
  fi
  if ! chmod 600 "$temp_file" || ! mv -f -- "$temp_file" "$ENV_FILE"; then
    rm -f -- "$temp_file"
    fail "Unable to update the Pocket ID encryption key"
  fi
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"

app_key="$(basename "$(dirname "$ROOT_DIR")")"
install_name="$(basename "$ROOT_DIR")"
[[ "$app_key" == "pocket-id" ]] || fail "Unexpected Pocket ID install path"
[[ -n "$install_name" && "$install_name" != "." && "$install_name" != ".." && "$install_name" != *$'\n'* && "$install_name" != *$'\r'* ]] || fail "Invalid Pocket ID install name"

onepanel_root="$(cd "${ROOT_DIR}/../../../.." && pwd -P)" || fail "Cannot resolve the 1Panel root from the Pocket ID install path"
backup_dir="${onepanel_root}/backup/app/local${app_key}/${install_name}"
[[ -d "$backup_dir" && ! -L "$backup_dir" ]] || fail "Cannot find the pre-upgrade 1Panel backup for this Pocket ID installation; refusing to replace its encryption key"

latest_backup="$(find "$backup_dir" -mindepth 1 -maxdepth 1 -type f -name "upgrade_backup_${install_name}_*.tar.gz" -printf '%T@ %f\n' | sort -nr | awk 'NR == 1 { print }')"
[[ -n "$latest_backup" ]] || fail "Cannot find the pre-upgrade 1Panel backup archive; refusing to replace the Pocket ID encryption key"
backup_file="${latest_backup#* }"
backup_archive="${backup_dir}/${backup_file}"
[[ -f "$backup_archive" && ! -L "$backup_archive" ]] || fail "The pre-upgrade 1Panel backup archive is unavailable; refusing to replace the Pocket ID encryption key"

backup_name="${backup_file%.tar.gz}"
app_archive="${backup_name}/app.tar.gz"
if ! tar -tzf "$backup_archive" | grep -Fx "$app_archive" > /dev/null; then
  fail "The pre-upgrade 1Panel backup does not contain the Pocket ID app archive; refusing to replace its encryption key"
fi

env_members="$(tar -xOzf "$backup_archive" "$app_archive" | tar -tzf - | awk -v install="$install_name" '$0 == install "/.env" || $0 == "./" install "/.env" { print }')"
env_member_count="$(printf '%s\n' "$env_members" | awk 'NF { count++ } END { print count + 0 }')"
[[ "$env_member_count" == "1" ]] || fail "The pre-upgrade 1Panel backup has no unique Pocket ID .env file; refusing to replace its encryption key"
env_member="$(printf '%s\n' "$env_members" | head -n 1)"
previous_env="$(tar -xOzf "$backup_archive" "$app_archive" | tar -xOzf - -- "$env_member")" || fail "Cannot read the pre-upgrade Pocket ID .env file; refusing to replace its encryption key"
previous_key="$(read_env_value "$previous_env" POCKET_ID_ENCRYPTION_KEY)"
[[ "$previous_key" =~ ^[A-Za-z0-9+/]{43}=$ ]] || fail "The pre-upgrade Pocket ID encryption key is missing or invalid; refusing to replace it"

requested_key="$(read_env_value "$(cat "$ENV_FILE")" POCKET_ID_ENCRYPTION_KEY)"
if [[ -z "$requested_key" || "$requested_key" == "generate" ]]; then
  set_env_value POCKET_ID_ENCRYPTION_KEY "$previous_key"
elif [[ "$requested_key" != "$previous_key" ]]; then
  fail "POCKET_ID_ENCRYPTION_KEY changed during upgrade; restore the previous value or use Pocket ID's supported key-rotation procedure"
fi

exec "${SCRIPT_DIR}/init.sh"
