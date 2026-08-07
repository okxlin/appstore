#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
TEMPLATE_FILE="$ROOT_DIR/config/isrvd.yml.template"
ENTRYPOINT_SOURCE="$ROOT_DIR/scripts/entrypoint.sh"

read_env_value() {
  local key="$1"
  [[ -f "$ENV_FILE" ]] || return 0
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

configured_value() {
  local key="$1"
  local default_value="$2"
  local value="${!key:-}"
  if [[ -z "$value" ]]; then
    value="$(read_env_value "$key")"
  fi
  printf '%s\n' "${value:-$default_value}"
}

yaml_quote() {
  local value="$1"
  if [[ "$value" == *$'\n'* || "$value" == *$'\r'* ]]; then
    echo "configuration values must not contain line breaks" >&2
    return 1
  fi
  value="${value//\'/\'\'}"
  printf "'%s'" "$value"
}

DATA_DIR_INPUT="$(configured_value APP_DATA_DIR ./data)"
ADMIN_USERNAME="$(configured_value ISRVD_ADMIN_USERNAME admin)"
ADMIN_PASSWORD="$(configured_value ISRVD_ADMIN_PASSWORD '')"
MONITOR_INTERVAL="$(configured_value ISRVD_MONITOR_INTERVAL 0)"
MARKETPLACE_URL="$(configured_value ISRVD_MARKETPLACE_URL https://apps.rehi.org)"

if [[ -z "$DATA_DIR_INPUT" || "$DATA_DIR_INPUT" == *$'\n'* || "$DATA_DIR_INPUT" == *$'\r'* ]]; then
  echo "APP_DATA_DIR must be a single non-empty path" >&2
  exit 1
fi
if [[ "$DATA_DIR_INPUT" == /* ]]; then
  DATA_DIR_TARGET="$DATA_DIR_INPUT"
else
  DATA_DIR_TARGET="$ROOT_DIR/$DATA_DIR_INPUT"
fi
mkdir -p "$DATA_DIR_TARGET"
DATA_DIR="$(cd "$DATA_DIR_TARGET" && pwd -P)"
if [[ "$DATA_DIR" == / ]]; then
  echo "APP_DATA_DIR must not resolve to /" >&2
  exit 1
fi
if [[ -z "$ADMIN_USERNAME" || "$ADMIN_USERNAME" == *$'\n'* || "$ADMIN_USERNAME" == *$'\r'* ]]; then
  echo "ISRVD_ADMIN_USERNAME must be a single non-empty line" >&2
  exit 1
fi
if (( ${#ADMIN_PASSWORD} < 8 )) || [[ "$ADMIN_PASSWORD" == *$'\n'* || "$ADMIN_PASSWORD" == *$'\r'* || "$ADMIN_PASSWORD" == *$'\t'* ]]; then
  echo "ISRVD_ADMIN_PASSWORD must contain at least 8 characters and must not contain tabs or line breaks" >&2
  exit 1
fi
case "$MONITOR_INTERVAL" in
  0|5|15|30|60) ;;
  *) echo "ISRVD_MONITOR_INTERVAL must be one of 0, 5, 15, 30, or 60" >&2; exit 1 ;;
esac

CONF_DIR="$DATA_DIR/conf"
CONF_FILE="$CONF_DIR/isrvd.yml"
INITIAL_PASSWORD_FILE="$CONF_DIR/.initial-admin-password"
mkdir -p "$CONF_DIR" "$DATA_DIR/container"
if [[ ! -f "$ENTRYPOINT_SOURCE" ]]; then
  echo "missing container entrypoint: $ENTRYPOINT_SOURCE" >&2
  exit 1
fi
install -m 700 "$ENTRYPOINT_SOURCE" "$CONF_DIR/app-entrypoint.sh"

ENV_TMP="$ENV_FILE.tmp.$$"
trap 'rm -f -- "$ENV_TMP"' EXIT
if [[ -f "$ENV_FILE" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" == ISRVD_DATA_ABS=* ]] && continue
    printf '%s\n' "$line"
  done < "$ENV_FILE" > "$ENV_TMP"
fi
printf 'ISRVD_DATA_ABS=%s\n' "$DATA_DIR" >> "$ENV_TMP"
chmod 600 "$ENV_TMP"
mv "$ENV_TMP" "$ENV_FILE"
trap - EXIT

prepare_plaintext_password_migration() {
  [[ -f "$CONF_FILE" ]] || return 0
  [[ ! -s "$INITIAL_PASSWORD_FILE" ]] || return 0

  local raw_password password
  raw_password="$(sed -n 's/^    password: //p' "$CONF_FILE" | head -n 1)"
  [[ -n "$raw_password" ]] || return 0
  password="$raw_password"
  case "$password" in
    \'*\') password="${password#\'}"; password="${password%\'}"; password="${password//\'\'/\'}" ;;
    \"*\") password="${password#\"}"; password="${password%\"}" ;;
  esac
  [[ "$password" != \$2* ]] || return 0

  printf '%s' "$password" > "$INITIAL_PASSWORD_FILE"
  chmod 600 "$INITIAL_PASSWORD_FILE"
  sed -i '0,/^    password: .*$/s//    password: admin/' "$CONF_FILE"
  sed -i '0,/^  listenAddr: .*$/s//  listenAddr: 127.0.0.1:8080/' "$CONF_FILE"
}

if [[ -f "$CONF_FILE" ]]; then
  prepare_plaintext_password_migration
  exit 0
fi
if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "missing configuration template: $TEMPLATE_FILE" >&2
  exit 1
fi

ADMIN_USERNAME_YAML="$(yaml_quote "$ADMIN_USERNAME")"
CONTAINER_ROOT_YAML="$(yaml_quote "$DATA_DIR/container")"
MARKETPLACE_URL_YAML="$(yaml_quote "$MARKETPLACE_URL")"
TMP_FILE="$CONF_FILE.tmp.$$"
trap 'rm -f -- "$TMP_FILE"' EXIT

while IFS= read -r line || [[ -n "$line" ]]; do
  case "$line" in
    *'__ISRVD_CONTAINER_ROOT__'*) line="${line/__ISRVD_CONTAINER_ROOT__/$CONTAINER_ROOT_YAML}" ;;
    *'__ISRVD_MONITOR_INTERVAL__'*) line="${line/__ISRVD_MONITOR_INTERVAL__/$MONITOR_INTERVAL}" ;;
    *'__ISRVD_MARKETPLACE_URL__'*) line="${line/__ISRVD_MARKETPLACE_URL__/$MARKETPLACE_URL_YAML}" ;;
    *'__ISRVD_ADMIN_USERNAME__'*) line="${line/__ISRVD_ADMIN_USERNAME__/$ADMIN_USERNAME_YAML}" ;;
  esac
  printf '%s\n' "$line"
done < "$TEMPLATE_FILE" > "$TMP_FILE"

chmod 600 "$TMP_FILE"
mv "$TMP_FILE" "$CONF_FILE"
trap - EXIT

printf '%s' "$ADMIN_PASSWORD" > "$INITIAL_PASSWORD_FILE"
chmod 600 "$INITIAL_PASSWORD_FILE"
