#!/bin/bash
set -euo pipefail

mkdir -p "${APP_DATA_DIR_1:-./data}"
touch .env
chmod 600 .env

generate_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
  else
    od -An -N32 -tx1 /dev/urandom | tr -d ' \n'
  fi
}

read_env_value() {
  key="$1"
  [ -f .env ] || return 0
  sed -n "s/^${key}=//p" .env | tail -n 1 | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//"
}

write_env_value() {
  key="$1"
  value="$2"
  touch .env
  tmp_file="$(mktemp .env.XXXXXX)"
  awk -v key="$key" -v value="$value" '
    BEGIN { updated = 0 }
    $0 ~ "^" key "=" { print key "=" value; updated = 1; next }
    { print }
    END { if (!updated) print key "=" value }
  ' .env >"$tmp_file"
  chmod 600 "$tmp_file"
  mv "$tmp_file" .env
}

jwt_secret="${JWT_SECRET:-$(read_env_value JWT_SECRET)}"
if [ "${#jwt_secret}" -lt 32 ]; then
  write_env_value JWT_SECRET "$(generate_secret)"
fi

totp_key="${TOTP_ENCRYPTION_KEY:-$(read_env_value TOTP_ENCRYPTION_KEY)}"
if [ -z "$totp_key" ]; then
  write_env_value TOTP_ENCRYPTION_KEY "$(generate_secret)"
fi
