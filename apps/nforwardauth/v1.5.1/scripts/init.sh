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

effective_value() {
  local key="$1"
  if [[ -v "$key" ]]; then
    printf '%s\n' "${!key}"
  else
    read_env_value "$key"
  fi
}

resolve_data_dir() {
  local raw="$1"
  if [[ "$raw" == /* ]]; then
    realpath -m -- "$raw"
  else
    realpath -m -- "${ROOT_DIR}/${raw#./}"
  fi
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must be a regular file"
command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate the passwd file"

username="$(effective_value AUTH_USERNAME)"
password="$(effective_value AUTH_PASSWORD)"
auth_host="$(effective_value AUTH_HOST)"
token_secret="$(effective_value TOKEN_SECRET)"
cookie_secure="$(effective_value COOKIE_SECURE)"
pass_user_header="$(effective_value PASS_USER_HEADER)"
data_raw="$(effective_value APP_DATA_DIR)"

[[ "$username" =~ ^[A-Za-z0-9._-]{1,64}$ ]] || fail "AUTH_USERNAME contains unsupported characters"
[[ ${#password} -ge 12 && ${#password} -le 256 ]] || fail "AUTH_PASSWORD must contain 12 to 256 characters"
[[ ! "$password" =~ [[:cntrl:]] ]] || fail "AUTH_PASSWORD must not contain control characters"
[[ "$auth_host" =~ ^[A-Za-z0-9][A-Za-z0-9.-]*(:[0-9]{1,5})?$ ]] || fail "AUTH_HOST must be a hostname with an optional port and no URL scheme"
[[ ${#token_secret} -ge 32 && ${#token_secret} -le 512 ]] || fail "TOKEN_SECRET must contain 32 to 512 characters"
[[ ! "$token_secret" =~ [[:cntrl:]] ]] || fail "TOKEN_SECRET must not contain control characters"
[[ "$cookie_secure" == true || "$cookie_secure" == false ]] || fail "COOKIE_SECURE must be true or false"
[[ "$pass_user_header" == true || "$pass_user_header" == false ]] || fail "PASS_USER_HEADER must be true or false"
[[ -n "$data_raw" && ! "$data_raw" =~ [[:cntrl:]\`\$] ]] || fail "APP_DATA_DIR is invalid"

data_dir="$(resolve_data_dir "$data_raw")"
case "$data_dir" in
  / | /bin | /boot | /dev | /etc | /home | /lib | /lib64 | /opt | /proc | /root | /run | /sbin | /srv | /sys | /tmp | /usr | /var | /workspace)
    fail "APP_DATA_DIR must be a dedicated subdirectory"
    ;;
esac
if [[ "$data_raw" != /* ]]; then
  case "$data_dir" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_DATA_DIR must stay inside the application version directory" ;;
  esac
fi
[[ ! -L "$data_dir" ]] || fail "APP_DATA_DIR must not be a symbolic link"
[[ ! -e "$data_dir" || -d "$data_dir" ]] || fail "APP_DATA_DIR must be a directory"
install -d -m 0750 -- "$data_dir"

passwd_file="${data_dir}/passwd"
[[ ! -L "$passwd_file" ]] || fail "passwd must not be a symbolic link"
[[ ! -e "$passwd_file" || -f "$passwd_file" ]] || fail "passwd must be a regular file"

salt="$(openssl rand -hex 8)"
[[ "$salt" =~ ^[0-9a-f]{16}$ ]] || fail "failed to generate a password salt"
password_hash="$(printf '%s\n' "$password" | openssl passwd -6 -stdin -salt "rounds=200000\$${salt}")"
[[ "$password_hash" == "\$6\$rounds=200000\$"* ]] || fail "failed to generate a SHA-512 password hash"

umask 077
temporary="$(mktemp "${data_dir}/.passwd.tmp.XXXXXX")"
trap 'rm -f -- "${temporary:-}"' EXIT
printf '%s:%s\n' "$username" "$password_hash" >"$temporary"
chmod 0600 -- "$temporary"
mv -f -- "$temporary" "$passwd_file"
trap - EXIT
