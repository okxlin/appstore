#!/bin/sh
set -eu

MARKER_FILE=/app/data/.1panel-bootstrap-complete
READY_FILE=/tmp/.1panel-bootstrap-ready

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

validate_secret() {
  name="$1"
  value="$2"
  minimum="$3"
  maximum="$4"
  case "$value" in
    *[!A-Za-z0-9]*) fail "$name contains unsupported characters" ;;
  esac
  length=${#value}
  if [ "$length" -lt "$minimum" ] || [ "$length" -gt "$maximum" ]; then
    fail "$name has an invalid length"
  fi
}

stay_ready() {
  touch "$READY_FILE"
  chmod 0600 "$READY_FILE"
  unset OWNCAST_ADMIN_PASSWORD OWNCAST_STREAM_KEY
  exec sleep infinity
}

[ -f "$MARKER_FILE" ] && stay_ready
validate_secret OWNCAST_ADMIN_PASSWORD "${OWNCAST_ADMIN_PASSWORD:-}" 16 72
validate_secret OWNCAST_STREAM_KEY "${OWNCAST_STREAM_KEY:-}" 24 128

owncast_pid=
cleanup() {
  if [ -n "$owncast_pid" ] && kill -0 "$owncast_pid" 2>/dev/null; then
    kill "$owncast_pid" 2>/dev/null || true
    wait "$owncast_pid" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

/app/owncast \
  -database /app/data/owncast.db \
  -logdir /app/data/logs \
  -backupdir /app/data/backups &
owncast_pid=$!

ready=false
attempt=0
while [ "$attempt" -lt 60 ]; do
  if wget --quiet --spider http://127.0.0.1:8080/api/status; then
    ready=true
    break
  fi
  kill -0 "$owncast_pid" 2>/dev/null || fail "Owncast exited before bootstrap"
  attempt=$((attempt + 1))
  sleep 1
done
[ "$ready" = true ] || fail "Owncast did not become ready for bootstrap"

umask 077
stream_request=/tmp/owncast-stream-key.json
password_request=/tmp/owncast-admin-password.json
stream_response=/tmp/owncast-stream-key-response.json
password_response=/tmp/owncast-admin-password-response.json

printf '{"value":[{"key":"%s","comment":"1Panel generated stream key"}]}' \
  "$OWNCAST_STREAM_KEY" > "$stream_request"
wget --quiet -O "$stream_response" \
  --header 'Authorization: Basic YWRtaW46YWJjMTIz' \
  --header 'Content-Type: application/json' \
  --post-file "$stream_request" \
  http://127.0.0.1:8080/api/admin/config/streamkeys
grep -Eq '"success"[[:space:]]*:[[:space:]]*true' "$stream_response" ||
  fail "Owncast rejected the generated stream key"

printf '{"value":"%s"}' "$OWNCAST_ADMIN_PASSWORD" > "$password_request"
wget --quiet -O "$password_response" \
  --header 'Authorization: Basic YWRtaW46YWJjMTIz' \
  --header 'Content-Type: application/json' \
  --post-file "$password_request" \
  http://127.0.0.1:8080/api/admin/config/adminpass
grep -Eq '"success"[[:space:]]*:[[:space:]]*true' "$password_response" ||
  fail "Owncast rejected the generated administrator password"

cleanup
owncast_pid=
touch "$MARKER_FILE"
chmod 0600 "$MARKER_FILE"
trap - EXIT INT TERM
stay_ready
