#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
DOCKER_BIN="${DOCKER_BIN:-docker}"
IMAGE='ghcr.io/tinyauthapp/tinyauth:v5'

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

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must be a regular file"
command -v "$DOCKER_BIN" >/dev/null 2>&1 || fail 'Docker is required to generate the Tinyauth password hash'

username="${TINYAUTH_ADMIN_USERNAME:-$(read_env_value TINYAUTH_ADMIN_USERNAME)}"
password="${TINYAUTH_ADMIN_PASSWORD:-$(read_env_value TINYAUTH_ADMIN_PASSWORD)}"
app_url="${TINYAUTH_APP_URL:-$(read_env_value TINYAUTH_APP_URL)}"
secure_cookie="${TINYAUTH_SECURE_COOKIE:-$(read_env_value TINYAUTH_SECURE_COOKIE)}"

data_dir="$(realpath -m -- "$ROOT_DIR/data")"
case "$data_dir" in
  "$ROOT_DIR"/*) ;;
  *) fail 'Tinyauth data directory must remain inside the application version directory' ;;
esac
for path in "$data_dir" "$data_dir/resources" "$data_dir/oidc"; do
  [[ ! -L "$path" ]] || fail "$path must not be a symbolic link"
  [[ ! -e "$path" || -d "$path" ]] || fail "$path must be a directory"
done
users_file="$data_dir/users"
[[ ! -L "$users_file" ]] || fail 'Tinyauth users file must not be a symbolic link'
[[ ! -e "$users_file" || -f "$users_file" ]] || fail 'Tinyauth users path must be a regular file'

[[ "$username" =~ ^[A-Za-z0-9._-]{1,64}$ ]] || fail 'TINYAUTH_ADMIN_USERNAME must contain only letters, digits, dot, underscore, or hyphen'
[[ ${#password} -ge 12 && ${#password} -le 256 ]] || fail 'TINYAUTH_ADMIN_PASSWORD must contain 12 to 256 characters'
[[ "$password" != *$'\n'* && "$password" != *$'\r'* ]] || fail 'TINYAUTH_ADMIN_PASSWORD must not contain line breaks'
[[ "$app_url" =~ ^https?://[^[:space:]]+$ ]] || fail 'TINYAUTH_APP_URL must be an absolute HTTP or HTTPS URL without whitespace'
app_host="${app_url#*://}"
app_host="${app_host%%/*}"
app_host="${app_host%%:*}"
[[ "$app_host" == *.* && "$app_host" =~ ^[A-Za-z0-9][A-Za-z0-9.-]*[A-Za-z0-9]$ ]] || fail 'TINYAUTH_APP_URL must use a domain name with at least two labels'
[[ ! "$app_host" =~ ^[0-9.]+$ ]] || fail 'TINYAUTH_APP_URL must not use an IP address'
[[ "$secure_cookie" == false || "$secure_cookie" == true ]] || fail 'TINYAUTH_SECURE_COOKIE must be true or false'

install -d -m 0750 -o 1000 -g 1000 -- "$data_dir" "$data_dir/resources" "$data_dir/oidc"

# Variables in this command are expanded by the shell inside the generator container.
# shellcheck disable=SC2016
generator_command='IFS= read -r password; exec tinyauth user create --username "$1" --password "$password"'
generator_output="$(
  printf '%s\n' "$password" |
    "$DOCKER_BIN" run --rm -i --network none --read-only --user 1000:1000 \
      --cap-drop ALL --security-opt no-new-privileges --env NO_COLOR=1 \
      --entrypoint /bin/sh "$IMAGE" -ec \
      "$generator_command" \
      sh "$username"
)"
user_entry="$(printf '%s\n' "$generator_output" | sed -n 's/^TINYAUTH_AUTH_USERS=//p' | head -n 1)"
[[ "$user_entry" =~ ^[A-Za-z0-9._-]{1,64}:\$2[aby]\$[0-9]{2}\$[./A-Za-z0-9]{53}$ ]] || fail 'Failed to generate a valid bcrypt user entry'

umask 077
temporary="$(mktemp "$data_dir/.users.tmp.XXXXXX")"
trap 'rm -f -- "${temporary:-}"' EXIT
printf '%s\n' "$user_entry" >"$temporary"
chmod 0600 "$temporary"
chown 1000:1000 "$temporary"
mv -f -- "$temporary" "$users_file"
trap - EXIT

chown 1000:1000 "$data_dir" "$data_dir/resources" "$data_dir/oidc" "$users_file"
chmod 0750 "$data_dir" "$data_dir/resources" "$data_dir/oidc"
chmod 0600 "$users_file"
