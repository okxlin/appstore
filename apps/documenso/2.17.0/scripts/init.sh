#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
DATA_DIR="${ROOT_DIR}/data"
CERT_FILE="${DATA_DIR}/cert.p12"

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

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.documenso-env.tmp.XXXXXX")"
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

generate_secret() {
  local key="$1"
  local value
  value="$(read_env_value "$key")"
  if [[ -z "$value" || "$value" == generate ]]; then
    value="$(openssl rand -hex 32)"
    set_env_value "$key" "$value"
  fi
  [[ ${#value} -ge 32 ]] || fail "$key must contain at least 32 characters"
}

urlencode() {
  local LC_ALL=C
  local input="$1"
  local output=""
  local character encoded
  local index
  for ((index = 0; index < ${#input}; index++)); do
    character="${input:index:1}"
    case "$character" in
      [A-Za-z0-9.~_-]) output+="$character" ;;
      *) printf -v encoded '%%%02X' "'$character"; output+="$encoded" ;;
    esac
  done
  printf '%s' "$output"
}

secure_certificate_file() {
  local current_uid owner_uid
  current_uid="$(id -u)"
  if [[ "$current_uid" == 0 ]]; then
    chown 1001:65533 -- "$CERT_FILE"
  elif [[ "$current_uid" == 1001 ]]; then
    owner_uid="$(stat -c %u -- "$CERT_FILE")"
    [[ "$owner_uid" == 1001 ]] || fail "the signing certificate must be owned by UID 1001"
    [[ -r "$CERT_FILE" ]] || fail "the signing certificate is not readable by UID 1001"
  else
    fail "init.sh must run as root or UID 1001"
  fi
  chmod 0400 -- "$CERT_FILE"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"
command -v openssl >/dev/null 2>&1 || fail "openssl is required"

db_host="$(read_env_value PANEL_DB_HOST)"
db_port="$(read_env_value PANEL_DB_PORT)"
db_name="$(read_env_value PANEL_DB_NAME)"
db_user="$(read_env_value PANEL_DB_USER)"
db_password="$(read_env_value PANEL_DB_USER_PASSWORD)"
[[ "$db_host" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || fail "PANEL_DB_HOST is invalid"
if [[ ! "$db_port" =~ ^[0-9]+$ ]] || ((db_port < 1 || db_port > 65535)); then
  fail "PANEL_DB_PORT is invalid"
fi
[[ "$db_name" =~ ^[A-Za-z0-9_][A-Za-z0-9_-]*$ ]] || fail "PANEL_DB_NAME is invalid"
[[ "$db_user" =~ ^[A-Za-z0-9_][A-Za-z0-9_.-]*$ ]] || fail "PANEL_DB_USER is invalid"
[[ -n "$db_password" && "$db_password" != change-me ]] || fail "PANEL_DB_USER_PASSWORD must be configured"

public_url="$(read_env_value NEXT_PUBLIC_WEBAPP_URL)"
public_url_pattern='^https?://[A-Za-z0-9._~:/?&=%+-]+$'
[[ "$public_url" =~ $public_url_pattern ]] || fail "NEXT_PUBLIC_WEBAPP_URL must be a complete HTTP(S) URL"
smtp_host="$(read_env_value SMTP_HOST)"
smtp_port="$(read_env_value SMTP_PORT)"
smtp_secure="$(read_env_value SMTP_SECURE)"
smtp_from_address="$(read_env_value SMTP_FROM_ADDRESS)"
[[ "$smtp_host" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ && "$smtp_host" != smtp.example.com ]] || fail "SMTP_HOST must name a working SMTP service"
if [[ ! "$smtp_port" =~ ^[0-9]+$ ]] || ((smtp_port < 1 || smtp_port > 65535)); then
  fail "SMTP_PORT is invalid"
fi
[[ "$smtp_secure" == true || "$smtp_secure" == false ]] || fail "SMTP_SECURE must be true or false"
[[ "$smtp_from_address" =~ ^[^[:space:]@]+@[^[:space:]@]+$ ]] || fail "SMTP_FROM_ADDRESS is invalid"

chmod 600 "$ENV_FILE"
generate_secret NEXTAUTH_SECRET
generate_secret NEXT_PRIVATE_ENCRYPTION_KEY
generate_secret NEXT_PRIVATE_ENCRYPTION_SECONDARY_KEY

encoded_user="$(urlencode "$db_user")"
encoded_password="$(urlencode "$db_password")"
set_env_value NEXT_PRIVATE_DATABASE_URL "postgresql://${encoded_user}:${encoded_password}@${db_host}:${db_port}/${db_name}"

install -d -m 0700 "$DATA_DIR"
passphrase="$(read_env_value SIGNING_PASSPHRASE)"
[[ ! -L "$CERT_FILE" ]] || fail "$CERT_FILE must not be a symbolic link"
if [[ -s "$CERT_FILE" ]]; then
  [[ -n "$passphrase" && "$passphrase" != generate ]] || fail "SIGNING_PASSPHRASE is missing for the existing certificate"
  CERT_PASS="$passphrase" openssl pkcs12 -in "$CERT_FILE" -passin env:CERT_PASS -noout >/dev/null 2>&1 || fail "the existing signing certificate or passphrase is invalid"
  secure_certificate_file
else
  if [[ -z "$passphrase" || "$passphrase" == generate ]]; then
    passphrase="$(openssl rand -hex 32)"
    set_env_value SIGNING_PASSPHRASE "$passphrase"
  fi
  temp_dir="$(mktemp -d "${ROOT_DIR}/.documenso-cert.tmp.XXXXXX")"
  trap 'rm -rf -- "$temp_dir"' EXIT
  openssl req -new -newkey rsa:3072 -x509 -sha256 -nodes -days 3650 \
    -subj "/CN=Documenso 1Panel Signing" \
    -keyout "${temp_dir}/private.key" -out "${temp_dir}/certificate.crt" >/dev/null 2>&1
  CERT_PASS="$passphrase" openssl pkcs12 -export \
    -inkey "${temp_dir}/private.key" -in "${temp_dir}/certificate.crt" \
    -out "${temp_dir}/cert.p12" -passout env:CERT_PASS
  install -m 0400 "${temp_dir}/cert.p12" "$CERT_FILE"
  secure_certificate_file
  rm -rf -- "$temp_dir"
  trap - EXIT
fi
