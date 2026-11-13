#!/bin/sh
set -eu
export LC_ALL=C

CONFIG_DIR=/data/config
PLUGIN_DIR=/data/plugins
CREDENTIAL_FILE=/data/.bootstrap-credentials

chown 65534:65534 "$CONFIG_DIR" "$PLUGIN_DIR"

bootstrap_pid=
stop_bootstrap() {
  if [ -n "$bootstrap_pid" ] && kill -0 "$bootstrap_pid" 2>/dev/null; then
    kill -TERM -"$bootstrap_pid" 2>/dev/null || true
    for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
      kill -0 -"$bootstrap_pid" 2>/dev/null || break
      sleep 0.1
    done
    if kill -0 -"$bootstrap_pid" 2>/dev/null; then
      kill -KILL -"$bootstrap_pid" 2>/dev/null || true
    fi
    wait "$bootstrap_pid" 2>/dev/null || true
  fi
}
trap stop_bootstrap EXIT
trap 'stop_bootstrap; exit 143' HUP INT TERM

setsid su -s /bin/sh nobody -c \
  'exec /usr/local/bin/zoraxy \
    -autorenew=86400 \
    -cfgupgrade=true \
    -conf=/data/config/conf \
    -db=auto \
    -dbpath=/data/config/sys.db \
    -default_inbound_enabled=false \
    -docker=true \
    -earlyrenew=30 \
    -enablelog=true \
    -fastgeoip=false \
    -log=/data/config/log \
    -mdns=false \
    -noauth=false \
    -plugin=/data/plugins/ \
    -port=127.0.0.1:8000 \
    -sshlb=false \
    -tmp=/data/config/tmp \
    -uuid=/data/config/sys.uuid' &
bootstrap_pid=$!

account_count="$(python3 -c '
import sys
import time
import urllib.request

url = "http://127.0.0.1:8000/api/auth/userCount"
for _ in range(60):
    try:
        value = urllib.request.urlopen(url, timeout=1).read().decode().strip()
        if value.isdigit():
            print(value)
            raise SystemExit(0)
    except Exception:
        pass
    time.sleep(0.5)
raise SystemExit("Zoraxy bootstrap listener did not become ready")
')"

case "$account_count" in
  0)
    [ -f "$CREDENTIAL_FILE" ] || {
      printf '%s\n' 'Bootstrap credentials are missing' >&2
      exit 1
    }
    [ "$(stat -c '%a' "$CREDENTIAL_FILE")" = 400 ] ||
      [ "$(stat -c '%a' "$CREDENTIAL_FILE")" = 600 ] || {
        printf '%s\n' 'Bootstrap credentials have unsafe permissions' >&2
        exit 1
      }
    sed -n '1p' "$CREDENTIAL_FILE" | grep -Eq '^[A-Za-z0-9][A-Za-z0-9._-]{2,63}$' || {
      printf '%s\n' 'Bootstrap username is invalid' >&2
      exit 1
    }
    [ "$(wc -l <"$CREDENTIAL_FILE" | tr -d ' ')" = 2 ] || {
      printf '%s\n' 'Bootstrap credential file must contain exactly two lines' >&2
      exit 1
    }
    LC_ALL=C sed -n '2p' "$CREDENTIAL_FILE" | grep -Eq '^[[:graph:]]+$' || {
      printf '%s\n' 'Bootstrap password must contain 16 to 256 printable ASCII characters without spaces' >&2
      exit 1
    }
    password_length="$(sed -n '2p' "$CREDENTIAL_FILE" | wc -c | tr -d ' ')"
    if [ "$password_length" -lt 17 ] || [ "$password_length" -gt 257 ]; then
      printf '%s\n' 'Bootstrap password must contain 16 to 256 printable ASCII characters without spaces' >&2
      exit 1
    fi
    python3 -c '
import http.cookiejar
import re
import sys
import urllib.parse
import urllib.request

username = sys.stdin.buffer.readline().rstrip(b"\n").decode()
password = sys.stdin.buffer.readline().rstrip(b"\n").decode()
jar = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(jar))
page = opener.open("http://127.0.0.1:8000/login.html", timeout=5).read().decode()
match = re.search(r"name=\"zoraxy.csrf.Token\" content=\"([^\"]+)\"", page)
if match is None:
    raise SystemExit("Unable to obtain the Zoraxy CSRF token")
request = urllib.request.Request(
    "http://127.0.0.1:8000/api/auth/register",
    data=urllib.parse.urlencode({"username": username, "password": password}).encode(),
    headers={"X-CSRF-Token": match.group(1)},
)
if opener.open(request, timeout=5).read().strip() != b"\"OK\"":
    raise SystemExit("Zoraxy administrator registration failed")
' <"$CREDENTIAL_FILE"
    ;;
  1) ;;
  *)
    printf 'Unexpected Zoraxy account count: %s\n' "$account_count" >&2
    exit 1
    ;;
esac

[ "$(python3 -c 'import urllib.request; print(urllib.request.urlopen("http://127.0.0.1:8000/api/auth/userCount", timeout=5).read().decode().strip())')" = 1 ] || {
  printf '%s\n' 'Zoraxy administrator bootstrap verification failed' >&2
  exit 1
}

stop_bootstrap
bootstrap_pid=
rm -f "$CREDENTIAL_FILE"
trap - EXIT HUP INT TERM

exec su -s /bin/sh nobody -c \
  'exec /usr/local/bin/zoraxy \
    -autorenew=86400 \
    -cfgupgrade=true \
    -conf=/data/config/conf \
    -db=auto \
    -dbpath=/data/config/sys.db \
    -docker=true \
    -earlyrenew=30 \
    -enablelog=true \
    -fastgeoip=false \
    -log=/data/config/log \
    -mdns=false \
    -noauth=false \
    -plugin=/data/plugins/ \
    -port=:8000 \
    -sshlb=false \
    -tmp=/data/config/tmp \
    -uuid=/data/config/sys.uuid'
