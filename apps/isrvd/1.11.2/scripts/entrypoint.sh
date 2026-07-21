#!/bin/sh
set -eu

CONFIG_PATH="${CONFIG_PATH:-/data/conf/isrvd.yml}"
INITIAL_PASSWORD_FILE="$(dirname "$CONFIG_PATH")/.initial-admin-password"

if [ ! -s "$INITIAL_PASSWORD_FILE" ]; then
  exec /entrypoint.sh
fi

json_escape() {
  sed 's/\\/\\\\/g; s/"/\\"/g'
}

USERNAME="$(sed -n '/username:/ { s/^[^:]*:[[:space:]]*//; p; q; }' "$CONFIG_PATH")"
case "$USERNAME" in
  \'*\') USERNAME="${USERNAME#\'}"; USERNAME="${USERNAME%\'}"; USERNAME="$(printf '%s' "$USERNAME" | sed "s/''/'/g")" ;;
  \"*\") USERNAME="${USERNAME#\"}"; USERNAME="${USERNAME%\"}" ;;
esac
DESIRED_PASSWORD="$(cat "$INITIAL_PASSWORD_FILE")"
if [ -z "$USERNAME" ] || [ -z "$DESIRED_PASSWORD" ]; then
  echo "initial administrator bootstrap data is incomplete" >&2
  exit 1
fi

REQUEST_DIR="$(dirname "$CONFIG_PATH")/.bootstrap"
LOGIN_REQUEST="$REQUEST_DIR/login.json"
DESIRED_LOGIN_REQUEST="$REQUEST_DIR/desired-login.json"
PASSWORD_REQUEST="$REQUEST_DIR/password.json"
LOGIN_RESPONSE="$REQUEST_DIR/login-response.json"
mkdir -p "$REQUEST_DIR"
chmod 700 "$REQUEST_DIR"
trap 'rm -f "$LOGIN_REQUEST" "$DESIRED_LOGIN_REQUEST" "$PASSWORD_REQUEST" "$LOGIN_RESPONSE"' EXIT

USERNAME_JSON="$(printf '%s' "$USERNAME" | json_escape)"
PASSWORD_JSON="$(printf '%s' "$DESIRED_PASSWORD" | json_escape)"
printf '{"username":"%s","password":"admin"}' "$USERNAME_JSON" > "$LOGIN_REQUEST"
printf '{"username":"%s","password":"%s"}' "$USERNAME_JSON" "$PASSWORD_JSON" > "$DESIRED_LOGIN_REQUEST"
printf '{"oldPassword":"admin","newPassword":"%s"}' "$PASSWORD_JSON" > "$PASSWORD_REQUEST"
chmod 600 "$LOGIN_REQUEST" "$DESIRED_LOGIN_REQUEST" "$PASSWORD_REQUEST"

/usr/local/bin/isrvd &
ISRVD_PID=$!
stop_bootstrap_server() {
  if [ "${ISRVD_PID:-0}" -gt 0 ]; then
    kill "$ISRVD_PID" 2>/dev/null || true
    wait "$ISRVD_PID" 2>/dev/null || true
    ISRVD_PID=0
  fi
}
trap 'stop_bootstrap_server; rm -f "$LOGIN_REQUEST" "$DESIRED_LOGIN_REQUEST" "$PASSWORD_REQUEST" "$LOGIN_RESPONSE"' EXIT INT TERM

ready=false
for _ in $(seq 1 60); do
  if wget -q --spider -T 2 http://127.0.0.1:8080/; then
    ready=true
    break
  fi
  sleep 1
done
if [ "$ready" != true ]; then
  echo "temporary administrator bootstrap server did not become ready" >&2
  exit 1
fi

wget -qO "$LOGIN_RESPONSE" -T 5 \
  --header 'Content-Type: application/json' \
  --post-file "$DESIRED_LOGIN_REQUEST" \
  http://127.0.0.1:8080/api/account/login 2>/dev/null || true
TOKEN="$(sed -n 's/.*"token":"\([^"]*\)".*/\1/p' "$LOGIN_RESPONSE" 2>/dev/null || true)"
if [ -z "$TOKEN" ]; then
  wget -qO "$LOGIN_RESPONSE" -T 5 \
    --header 'Content-Type: application/json' \
    --post-file "$LOGIN_REQUEST" \
    http://127.0.0.1:8080/api/account/login
  TOKEN="$(sed -n 's/.*"token":"\([^"]*\)".*/\1/p' "$LOGIN_RESPONSE")"
  if [ -z "$TOKEN" ]; then
    echo "temporary administrator login did not return a token" >&2
    exit 1
  fi

  CONTENT_LENGTH="$(wc -c < "$PASSWORD_REQUEST" | tr -d ' ')"
  CHANGE_RESPONSE="$({
    printf 'PUT /api/account/password HTTP/1.1\r\n'
    printf 'Host: 127.0.0.1:8080\r\n'
    printf 'Authorization: Bearer %s\r\n' "$TOKEN"
    printf 'Content-Type: application/json\r\n'
    printf 'Content-Length: %s\r\n' "$CONTENT_LENGTH"
    printf 'Connection: close\r\n\r\n'
    cat "$PASSWORD_REQUEST"
  } | nc -w 5 127.0.0.1 8080)"
  case "$CHANGE_RESPONSE" in
    *'"success":true'*) ;;
    *) echo "initial administrator password update failed" >&2; exit 1 ;;
  esac
fi

stop_bootstrap_server
CONFIG_TMP="$CONFIG_PATH.tmp.$$"
awk 'BEGIN { changed = 0 } !changed && /^  listenAddr: / { print "  listenAddr: :8080"; changed = 1; next } { print }' "$CONFIG_PATH" > "$CONFIG_TMP"
chmod 600 "$CONFIG_TMP"
mv "$CONFIG_TMP" "$CONFIG_PATH"
rm -f "$INITIAL_PASSWORD_FILE" "$LOGIN_REQUEST" "$DESIRED_LOGIN_REQUEST" "$PASSWORD_REQUEST" "$LOGIN_RESPONSE"
rmdir "$REQUEST_DIR" 2>/dev/null || true
trap - EXIT INT TERM

exec /entrypoint.sh
