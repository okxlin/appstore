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
  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  fi
  value="${value%$'\r'}"
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

  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { updated = 0 }
    $0 ~ ("^" key "=") {
      if (!updated) {
        print key "=" value
        updated = 1
      }
      next
    }
    { print }
    END {
      if (!updated) print key "=" value
    }
  ' "$ENV_FILE" >"$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

validate_boolean() {
  local key="$1"
  local value="$2"
  [[ "$value" == "true" || "$value" == "false" ]] || fail "$key must be true or false"
}

[[ -f "$ENV_FILE" ]] || fail "Environment file not found: ${ENV_FILE}"
[[ ! -L "$ENV_FILE" ]] || fail "Environment file must not be a symbolic link"

bind_address="$(read_env_value PANEL_APP_BIND_ADDRESS)"
[[ "$bind_address" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address"
IFS=. read -r -a bind_octets <<< "$bind_address"
for octet in "${bind_octets[@]}"; do
  ((10#$octet <= 255)) || fail "PANEL_APP_BIND_ADDRESS contains an invalid IPv4 octet"
done

port="$(read_env_value PANEL_APP_PORT_HTTP)"
[[ "$port" =~ ^[0-9]+$ ]] || fail "PANEL_APP_PORT_HTTP must be an integer"
((10#$port >= 1 && 10#$port <= 65535)) || fail "PANEL_APP_PORT_HTTP must be between 1 and 65535"

target="$(read_env_value ANUBIS_TARGET)"
[[ "$target" == http://* || "$target" == https://* ]] || fail "ANUBIS_TARGET must be an http or https URL"
case "$target" in
  *[[:space:]]* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*)
    fail "ANUBIS_TARGET contains unsupported dotenv characters"
    ;;
esac

redirect_domains="$(read_env_value ANUBIS_REDIRECT_DOMAINS)"
[[ -n "$redirect_domains" ]] || fail "ANUBIS_REDIRECT_DOMAINS must not be empty"
case "$redirect_domains" in
  *[[:space:]]* | *\\* | *'$'* | *'#'* | *'"'* | *"'"*)
    fail "ANUBIS_REDIRECT_DOMAINS contains unsupported dotenv characters"
    ;;
esac
IFS=',' read -r -a redirect_domain_items <<< "$redirect_domains"
for redirect_domain in "${redirect_domain_items[@]}"; do
  [[ "$redirect_domain" =~ ^(\*\.)?([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?)(\.([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?))*$ ]] || \
    fail "ANUBIS_REDIRECT_DOMAINS must contain only hostnames or IPv4 addresses without schemes or ports"
done

difficulty="$(read_env_value ANUBIS_DIFFICULTY)"
[[ "$difficulty" =~ ^[0-9]+$ ]] || fail "ANUBIS_DIFFICULTY must be an integer"
((10#$difficulty >= 1 && 10#$difficulty <= 16)) || fail "ANUBIS_DIFFICULTY must be between 1 and 16"

validate_boolean ANUBIS_SERVE_ROBOTS "$(read_env_value ANUBIS_SERVE_ROBOTS)"
validate_boolean ANUBIS_COOKIE_SECURE "$(read_env_value ANUBIS_COOKIE_SECURE)"
validate_boolean ANUBIS_USE_REMOTE_ADDRESS "$(read_env_value ANUBIS_USE_REMOTE_ADDRESS)"

webmaster_email="$(read_env_value ANUBIS_WEBMASTER_EMAIL)"
if [[ -n "$webmaster_email" ]]; then
  case "$webmaster_email" in
    *@*.*) ;;
    *) fail "ANUBIS_WEBMASTER_EMAIL must be empty or a valid email address" ;;
  esac
  case "$webmaster_email" in
    *[[:space:]]* | *\\* | *'$'* | *'"'* | *"'"*)
      fail "ANUBIS_WEBMASTER_EMAIL contains unsupported dotenv characters"
      ;;
  esac
fi

signing_key="$(read_env_value ANUBIS_ED25519_PRIVATE_KEY_HEX)"
if [[ -z "$signing_key" || "$signing_key" == "generate" ]]; then
  signing_key="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  set_env_value ANUBIS_ED25519_PRIVATE_KEY_HEX "$signing_key"
fi
[[ "$signing_key" =~ ^[0-9a-fA-F]{64}$ ]] || fail "ANUBIS_ED25519_PRIVATE_KEY_HEX must contain exactly 64 hexadecimal characters"
chmod 600 "$ENV_FILE"
