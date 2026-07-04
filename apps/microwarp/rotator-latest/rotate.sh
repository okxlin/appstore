#!/usr/bin/env sh
set -eu

INTERVAL_MINUTES="${ROTATE_INTERVAL_MINUTES:-0}"
TEST_URL="${TEST_URL:-https://cloudflare.com/cdn-cgi/trace}"
SOCKS_ADDR="127.0.0.1:${BIND_PORT:-1080}"
WG_DIR="/etc/wireguard"
WG_CONF="${WG_DIR}/wg0.conf"
FIXED_CONFIG="${WARP_WGCF_CONF:-}"
LOG_PREFIX="[microwarp]"
ENTRY_PID=""

log() {
  echo "${LOG_PREFIX} $*"
}

is_non_negative_int() {
  case "$1" in
    ''|*[!0-9]*)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

probe_ip() {
  if ! command -v curl >/dev/null 2>&1; then
    return 0
  fi
  curl --max-time 20 --socks5-hostname "$SOCKS_ADDR" "$TEST_URL" 2>/dev/null | sed -n '1,6p'
}

inject_fixed_config() {
  if [ -z "$FIXED_CONFIG" ]; then
    return 0
  fi
  mkdir -p "$WG_DIR"
  printf '%s\n' "$FIXED_CONFIG" > "$WG_CONF"
  chmod 600 "$WG_CONF" || true
  log "wg0.conf injected from WARP_WGCF_CONF"
}

wait_for_proxy() {
  attempts=0
  while [ "$attempts" -lt 30 ]; do
    if [ -n "$ENTRY_PID" ] && ! kill -0 "$ENTRY_PID" 2>/dev/null; then
      wait "$ENTRY_PID" || true
      return 1
    fi

    if probe_output="$(probe_ip)"; then
      if [ -n "$probe_output" ]; then
        printf '%s\n' "$probe_output"
        return 0
      fi
    fi

    attempts=$((attempts + 1))
    sleep 2
  done
  return 1
}

stop_runtime() {
  if [ -n "$ENTRY_PID" ] && kill -0 "$ENTRY_PID" 2>/dev/null; then
    kill "$ENTRY_PID" 2>/dev/null || true
    wait "$ENTRY_PID" || true
  fi
  ENTRY_PID=""
}

teardown_for_rotation() {
  stop_runtime
  if ip link show wg0 >/dev/null 2>&1; then
    wg-quick down wg0 >/dev/null 2>&1 || true
  fi
  rm -f "$WG_CONF" "$WG_DIR/wgcf-account.toml" "$WG_DIR/wgcf-profile.conf" "$WG_DIR/extra.env"
}

start_runtime() {
  inject_fixed_config
  log "starting MicroWARP runtime"
  /app/entrypoint.sh &
  ENTRY_PID=$!
  if probe_output="$(wait_for_proxy)"; then
    printf '%s\n' "$probe_output"
    return 0
  fi
  log "runtime did not become ready in time"
  return 1
}

on_signal() {
  log "received stop signal"
  stop_runtime
  exit 0
}

main() {
  interval="$INTERVAL_MINUTES"
  if ! is_non_negative_int "$interval"; then
    log "invalid ROTATE_INTERVAL_MINUTES=${interval}, fallback to 0"
    interval=0
  fi

  if [ -n "$FIXED_CONFIG" ] && [ "$interval" -gt 0 ]; then
    log "WARP_WGCF_CONF is set, scheduled rotation disabled because the config is pinned"
    interval=0
  fi

  trap on_signal INT TERM

  if ! start_runtime; then
    exit 1
  fi

  if [ "$interval" -eq 0 ]; then
    log "scheduled rotation disabled"
    wait "$ENTRY_PID"
    exit $?
  fi

  log "scheduled WARP identity rebuild enabled every ${interval} minute(s)"
  while true; do
    sleep "$((interval * 60))"
    log "trigger scheduled WARP identity rebuild"
    if ! rotate_output="$(teardown_for_rotation; start_runtime)"; then
      log "rotation failed"
      exit 1
    fi
    printf '%s\n' "$rotate_output"
  done
}

main "$@"
