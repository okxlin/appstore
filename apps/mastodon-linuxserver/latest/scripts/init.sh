#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${ENV_FILE:-./.env}"
MASTODON_IMAGE="lscr.io/linuxserver/mastodon:latest"
LEGACY_DB_PASSWORD="mastodon-change-me"
LEGACY_ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY="fGWkJDBwyRYhILyO7akZGLSSz0gAjPpo"
LEGACY_ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY="Z8BE3tc3XnmUr0MbRexRiPN7vcP52VX0"
LEGACY_ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT="3hRwOaLRCikUCsxd19cUcO5EgXCN6ig1"
LEGACY_SECRET_KEY_BASE="ae3ab77b9a041a4d760126dba8c4e24a33bdfcec7fdbadf3d973baf92017ee0d0b988d62c040aca882ee8030ea22adb04d9c26a9541c918a434029840c8719b0"
LEGACY_OTP_SECRET="b3d6069b87df718c733a1b17a9adcbd7705b76ba0b48dd3f3ce58870dd52bed0d32d947a43a4eadac4230d508e11df0cee6f59ed85e40670134a52545f1131ac"
LEGACY_VAPID_PRIVATE_KEY="1eF670mQsgs_-W_eb06ZZ46apD4qVDYNvFWu9eGWc7E="
LEGACY_VAPID_PUBLIC_KEY="BOOqXKvCVA9tb8Bas05sdez6fGavnA5SrDJe88s7FMeIu7txiQ5sOqOZqKIpTSS_xmm5Wkd_MKHqj2UCQIwl9_8="

read_env_value() {
  local key="$1"

  if [[ ! -f "$ENV_FILE" ]] || ! grep -qE "^${key}=" "$ENV_FILE"; then
    return
  fi

  local current
  current="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  current="${current%\"}"
  current="${current#\"}"
  current="${current%\'}"
  current="${current#\'}"
  printf '%s\n' "$current"
}

read_cache_value() {
  local cache_file="$1"
  if [[ ! -s "$cache_file" ]]; then
    return
  fi
  sed -n '1p' "$cache_file" | tr -d '\r\n'
}

write_cache_value() {
  local cache_file="$1"
  local value="$2"

  mkdir -p "$(dirname "$cache_file")"
  printf '%s\n' "$value" > "$cache_file"
  chmod 600 "$cache_file" 2>/dev/null || true
}

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\/&|]/\\&/g'
}

set_env_value() {
  local key="$1"
  local value="$2"

  if [[ ! -f "$ENV_FILE" ]]; then
    echo "$ENV_FILE not found; skipped $key generation"
    return
  fi

  local replacement
  replacement="$(escape_sed_replacement "$value")"
  if grep -qE "^${key}=" "$ENV_FILE"; then
    sed -i -E "s|^${key}=.*|${key}=${replacement}|" "$ENV_FILE"
    echo "Updated $key"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added $key"
}

generate_alnum_secret() {
  local secret=""
  local chunk=""
  while [[ ${#secret} -lt 32 ]]; do
    chunk="$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c $((32 - ${#secret})) || true)"
    secret="${secret}${chunk}"
  done
  printf '%s\n' "$secret"
}

run_mastodon_generator() {
  docker run --rm --entrypoint /bin/bash "$MASTODON_IMAGE" "$1"
}

extract_generator_value() {
  local output="$1"
  local key="$2"
  printf '%s\n' "$output" | sed -n -E "s/^${key}=//p" | tail -n 1
}

is_active_record_secret_valid() {
  local value="$1"
  [[ "$value" =~ ^[A-Za-z0-9]{32}$ ]]
}

is_hex_secret_valid() {
  local value="$1"
  [[ "$value" =~ ^[a-f0-9]{128}$ ]]
}

is_vapid_key_valid() {
  local value="$1"
  [[ ${#value} -ge 40 && "$value" =~ ^[A-Za-z0-9_-]+=*$ ]]
}

CONFIG_PATH_VALUE="${CONFIG_PATH:-$(read_env_value CONFIG_PATH || true)}"
CONFIG_PATH_VALUE="${CONFIG_PATH_VALUE:-./data/config}"
SECRET_CACHE_DIR="${SECRET_CACHE_DIR:-${CONFIG_PATH_VALUE}/.mastodon_secret_cache}"
DB_PASSWORD_CACHE="${DB_PASSWORD_CACHE:-${SECRET_CACHE_DIR}/db_password}"
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY_CACHE="${ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY_CACHE:-${SECRET_CACHE_DIR}/active_record_encryption_primary_key}"
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY_CACHE="${ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY_CACHE:-${SECRET_CACHE_DIR}/active_record_encryption_deterministic_key}"
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT_CACHE="${ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT_CACHE:-${SECRET_CACHE_DIR}/active_record_encryption_key_derivation_salt}"
SECRET_KEY_BASE_CACHE="${SECRET_KEY_BASE_CACHE:-${SECRET_CACHE_DIR}/secret_key_base}"
OTP_SECRET_CACHE="${OTP_SECRET_CACHE:-${SECRET_CACHE_DIR}/otp_secret}"
VAPID_PRIVATE_KEY_CACHE="${VAPID_PRIVATE_KEY_CACHE:-${SECRET_CACHE_DIR}/vapid_private_key}"
VAPID_PUBLIC_KEY_CACHE="${VAPID_PUBLIC_KEY_CACHE:-${SECRET_CACHE_DIR}/vapid_public_key}"

if [[ -f "$ENV_FILE" ]]; then
  db_password="$(read_env_value DB_PASSWORD || true)"
  cached_db_password="$(read_cache_value "$DB_PASSWORD_CACHE" || true)"
  if [[ -n "$db_password" && "$db_password" != "$LEGACY_DB_PASSWORD" ]]; then
    write_cache_value "$DB_PASSWORD_CACHE" "$db_password"
  elif [[ -n "$cached_db_password" ]]; then
    set_env_value "DB_PASSWORD" "$cached_db_password"
  else
    db_password="$(generate_alnum_secret)"
    set_env_value "DB_PASSWORD" "$db_password"
    write_cache_value "$DB_PASSWORD_CACHE" "$db_password"
  fi

  active_primary="$(read_env_value ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY || true)"
  active_deterministic="$(read_env_value ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY || true)"
  active_salt="$(read_env_value ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT || true)"
  cached_active_primary="$(read_cache_value "$ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY_CACHE" || true)"
  cached_active_deterministic="$(read_cache_value "$ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY_CACHE" || true)"
  cached_active_salt="$(read_cache_value "$ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT_CACHE" || true)"
  if is_active_record_secret_valid "$active_primary" \
    && is_active_record_secret_valid "$active_deterministic" \
    && is_active_record_secret_valid "$active_salt" \
    && [[ "$active_primary" != "$LEGACY_ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY" ]] \
    && [[ "$active_deterministic" != "$LEGACY_ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY" ]] \
    && [[ "$active_salt" != "$LEGACY_ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT" ]]; then
    write_cache_value "$ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY_CACHE" "$active_primary"
    write_cache_value "$ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY_CACHE" "$active_deterministic"
    write_cache_value "$ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT_CACHE" "$active_salt"
  elif is_active_record_secret_valid "$cached_active_primary" \
    && is_active_record_secret_valid "$cached_active_deterministic" \
    && is_active_record_secret_valid "$cached_active_salt"; then
    set_env_value "ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY" "$cached_active_primary"
    set_env_value "ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY" "$cached_active_deterministic"
    set_env_value "ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT" "$cached_active_salt"
  elif [[ "$active_primary" == "$LEGACY_ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY" ]] \
    || [[ "$active_deterministic" == "$LEGACY_ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY" ]] \
    || [[ "$active_salt" == "$LEGACY_ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT" ]] \
    || ! is_active_record_secret_valid "$active_primary" \
    || ! is_active_record_secret_valid "$active_deterministic" \
    || ! is_active_record_secret_valid "$active_salt"; then
    active_record_output="$(run_mastodon_generator generate-active-record)"
    active_primary="$(extract_generator_value "$active_record_output" "ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY")"
    active_deterministic="$(extract_generator_value "$active_record_output" "ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY")"
    active_salt="$(extract_generator_value "$active_record_output" "ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT")"
    set_env_value "ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY" "$active_primary"
    set_env_value "ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY" "$active_deterministic"
    set_env_value "ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT" "$active_salt"
    write_cache_value "$ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY_CACHE" "$active_primary"
    write_cache_value "$ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY_CACHE" "$active_deterministic"
    write_cache_value "$ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT_CACHE" "$active_salt"
  fi

  secret_key_base="$(read_env_value SECRET_KEY_BASE || true)"
  if [[ "$secret_key_base" == "$LEGACY_SECRET_KEY_BASE" ]] || ! is_hex_secret_valid "$secret_key_base"; then
    cached_secret_key_base="$(read_cache_value "$SECRET_KEY_BASE_CACHE" || true)"
    if is_hex_secret_valid "$cached_secret_key_base"; then
      set_env_value "SECRET_KEY_BASE" "$cached_secret_key_base"
    else
      secret_key_base="$(run_mastodon_generator generate-secret | tail -n 1 | tr -d '\r\n')"
      set_env_value "SECRET_KEY_BASE" "$secret_key_base"
      write_cache_value "$SECRET_KEY_BASE_CACHE" "$secret_key_base"
    fi
  else
    write_cache_value "$SECRET_KEY_BASE_CACHE" "$secret_key_base"
  fi

  otp_secret="$(read_env_value OTP_SECRET || true)"
  if [[ "$otp_secret" == "$LEGACY_OTP_SECRET" ]] || ! is_hex_secret_valid "$otp_secret"; then
    cached_otp_secret="$(read_cache_value "$OTP_SECRET_CACHE" || true)"
    if is_hex_secret_valid "$cached_otp_secret"; then
      set_env_value "OTP_SECRET" "$cached_otp_secret"
    else
      otp_secret="$(run_mastodon_generator generate-secret | tail -n 1 | tr -d '\r\n')"
      set_env_value "OTP_SECRET" "$otp_secret"
      write_cache_value "$OTP_SECRET_CACHE" "$otp_secret"
    fi
  else
    write_cache_value "$OTP_SECRET_CACHE" "$otp_secret"
  fi

  vapid_private_key="$(read_env_value VAPID_PRIVATE_KEY || true)"
  vapid_public_key="$(read_env_value VAPID_PUBLIC_KEY || true)"
  cached_vapid_private_key="$(read_cache_value "$VAPID_PRIVATE_KEY_CACHE" || true)"
  cached_vapid_public_key="$(read_cache_value "$VAPID_PUBLIC_KEY_CACHE" || true)"
  if is_vapid_key_valid "$vapid_private_key" \
    && is_vapid_key_valid "$vapid_public_key" \
    && [[ "$vapid_private_key" != "$LEGACY_VAPID_PRIVATE_KEY" ]] \
    && [[ "$vapid_public_key" != "$LEGACY_VAPID_PUBLIC_KEY" ]]; then
    write_cache_value "$VAPID_PRIVATE_KEY_CACHE" "$vapid_private_key"
    write_cache_value "$VAPID_PUBLIC_KEY_CACHE" "$vapid_public_key"
  elif is_vapid_key_valid "$cached_vapid_private_key" && is_vapid_key_valid "$cached_vapid_public_key"; then
    set_env_value "VAPID_PRIVATE_KEY" "$cached_vapid_private_key"
    set_env_value "VAPID_PUBLIC_KEY" "$cached_vapid_public_key"
  elif [[ "$vapid_private_key" == "$LEGACY_VAPID_PRIVATE_KEY" ]] \
    || [[ "$vapid_public_key" == "$LEGACY_VAPID_PUBLIC_KEY" ]] \
    || ! is_vapid_key_valid "$vapid_private_key" \
    || ! is_vapid_key_valid "$vapid_public_key"; then
    vapid_output="$(run_mastodon_generator generate-vapid)"
    set_env_value "VAPID_PRIVATE_KEY" "$(extract_generator_value "$vapid_output" "VAPID_PRIVATE_KEY")"
    set_env_value "VAPID_PUBLIC_KEY" "$(extract_generator_value "$vapid_output" "VAPID_PUBLIC_KEY")"
    write_cache_value "$VAPID_PRIVATE_KEY_CACHE" "$(extract_generator_value "$vapid_output" "VAPID_PRIVATE_KEY")"
    write_cache_value "$VAPID_PUBLIC_KEY_CACHE" "$(extract_generator_value "$vapid_output" "VAPID_PUBLIC_KEY")"
  fi
fi

paths=(
  "${CONFIG_PATH:-./data/config}"
  "${DB_DATA_PATH:-./data/db}"
  "${REDIS_DATA_PATH:-./data/redis}"
)

mkdir -p "${paths[@]}"
for path in "${paths[@]}"; do
  case "$path" in
    ./*|../*) chown -R 1000:1000 "$path" 2>/dev/null || true ;;
  esac
done
