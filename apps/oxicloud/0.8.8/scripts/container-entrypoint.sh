#!/bin/sh
set -eu

uri_encode_component() {
  printf '%s' "$1" | od -An -tx1 -v | tr -d ' \n' | sed 's/../%&/g'
}

db_user_uri="$(uri_encode_component "$PANEL_DB_USER")"
db_password_uri="$(uri_encode_component "$PANEL_DB_USER_PASSWORD")"
db_name_uri="$(uri_encode_component "$PANEL_DB_NAME")"

export OXICLOUD_DB_CONNECTION_STRING="postgres://${db_user_uri}:${db_password_uri}@${PANEL_DB_HOST}:${PANEL_DB_PORT}/${db_name_uri}"
unset PANEL_DB_USER PANEL_DB_USER_PASSWORD PANEL_DB_NAME PANEL_DB_HOST PANEL_DB_PORT

exec /usr/local/bin/entrypoint.sh "$@"
