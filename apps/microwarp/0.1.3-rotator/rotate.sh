#!/usr/bin/env sh
set -eu

INTERVAL_MINUTES="${ROTATE_INTERVAL_MINUTES:-0}"
ROTATE_MAX_ATTEMPTS="${ROTATE_MAX_ATTEMPTS:-5}"
ROTATE_RETRY_DELAY_SECONDS="${ROTATE_RETRY_DELAY_SECONDS:-5}"
TEST_URL="${TEST_URL:-https://cloudflare.com/cdn-cgi/trace}"
IP_CHECK_URL="${IP_CHECK_URL:-https://cloudflare.com/cdn-cgi/trace}"
SOCKS_ADDR="127.0.0.1:${BIND_PORT:-1080}"
SOCKS_USER_VALUE="${SOCKS_USER:-}"
SOCKS_PASS_VALUE="${SOCKS_PASS:-}"
WG_DIR="/etc/wireguard"
WG_CONF="${WG_DIR}/wg0.conf"
PREVIOUS_CONF="${WG_CONF}.rotation-previous"
FIXED_CONFIG="${WARP_WGCF_CONF:-}"
LOG_PREFIX="[microwarp]"
ENTRY_PID=""
CURRENT_EGRESS_IP=""

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

is_positive_int() {
  case "$1" in
    ''|*[!0-9]*|0)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

is_ipv4() {
  printf '%s\n' "$1" | awk -F. '
    NF == 4 {
      for (i = 1; i <= 4; i++) {
        if ($i !~ /^[0-9]+$/ || $i < 0 || $i > 255) exit 1
      }
      exit 0
    }
    { exit 1 }
  '
}

probe_ip() {
  if ! command -v curl >/dev/null 2>&1; then
    return 1
  fi
  curl_via_socks "$TEST_URL" >/dev/null 2>&1
}

curl_via_socks() {
  url="$1"
  if [ -n "$SOCKS_USER_VALUE" ] && [ -n "$SOCKS_PASS_VALUE" ]; then
    curl --max-time 20 --socks5-hostname "$SOCKS_ADDR" \
      --proxy-user "${SOCKS_USER_VALUE}:${SOCKS_PASS_VALUE}" "$url"
    return $?
  fi
  curl --max-time 20 --socks5-hostname "$SOCKS_ADDR" "$url"
}

get_egress_ip() {
  if ! command -v curl >/dev/null 2>&1; then
    return 1
  fi

  trace_output="$(curl_via_socks "$IP_CHECK_URL" 2>/dev/null)" || return 1
  current_ip="$(printf '%s\n' "$trace_output" |
    awk -F= '$1 == "ip" { print $2; exit }' | tr -d '\r')"
  is_ipv4 "$current_ip" && printf '%s\n' "$current_ip"
}

record_egress_ip() {
  current_ip="$(get_egress_ip || true)"
  if [ -n "$current_ip" ]; then
    CURRENT_EGRESS_IP="$current_ip"
    log "current WARP egress IPv4: ${CURRENT_EGRESS_IP}"
  else
    CURRENT_EGRESS_IP=""
    log "unable to verify current WARP egress IPv4"
  fi
  return 0
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
      ENTRY_PID=""
      return 1
    fi

    if probe_ip; then
      return 0
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
  CURRENT_EGRESS_IP=""
  inject_fixed_config
  log "starting MicroWARP runtime"
  /app/entrypoint.sh &
  ENTRY_PID=$!
  if ! wait_for_proxy; then
    log "runtime did not become ready in time"
    stop_runtime
    return 1
  fi
  record_egress_ip
  if [ -z "$ENTRY_PID" ] || ! kill -0 "$ENTRY_PID" 2>/dev/null; then
    log "runtime exited while its egress was being checked"
    stop_runtime
    return 1
  fi
  return 0
}

save_previous_config() {
  if [ -s "$WG_CONF" ]; then
    previous_tmp="${PREVIOUS_CONF}.tmp.$$"
    rm -f "$previous_tmp"
    if ! cp -p "$WG_CONF" "$previous_tmp"; then
      rm -f "$previous_tmp"
      return 1
    fi
    if ! mv -f "$previous_tmp" "$PREVIOUS_CONF"; then
      rm -f "$previous_tmp"
      return 1
    fi
    return 0
  fi
  return 1
}

restore_previous_runtime() {
  if [ ! -s "$PREVIOUS_CONF" ]; then
    return 1
  fi

  log "restoring the previous working WARP configuration"
  teardown_for_rotation
  if ! cp -p "$PREVIOUS_CONF" "$WG_CONF"; then
    log "unable to restore the previous WARP configuration"
    return 1
  fi
  start_runtime
}

rotate_once() {
  if [ -z "$ENTRY_PID" ] || ! kill -0 "$ENTRY_PID" 2>/dev/null; then
    log "WARP runtime exited before the scheduled identity rebuild"
    return 1
  fi

  record_egress_ip
  old_ip="$CURRENT_EGRESS_IP"
  if [ -z "$old_ip" ]; then
    log "scheduled identity rebuild skipped because the current WARP egress IPv4 could not be verified"
    return 0
  fi
  attempt=1
  if ! save_previous_config; then
    log "scheduled identity rebuild skipped because the working WARP configuration could not be backed up"
    return 0
  fi

  while [ "$attempt" -le "$ROTATE_MAX_ATTEMPTS" ]; do
    log "WARP identity rebuild attempt ${attempt}/${ROTATE_MAX_ATTEMPTS}"
    teardown_for_rotation

    if start_runtime; then
      new_ip="$CURRENT_EGRESS_IP"
      if [ -n "$new_ip" ] &&
        [ "$new_ip" != "$old_ip" ]; then
        rm -f "$PREVIOUS_CONF"
        log "WARP egress IPv4 changed: ${old_ip:-unknown} -> ${new_ip}"
        return 0
      fi

      if [ -n "$new_ip" ] && [ "$new_ip" = "$old_ip" ]; then
        log "WARP egress IPv4 stayed ${new_ip}; retrying identity rebuild"
      else
        log "WARP egress IPv4 could not be verified; retrying identity rebuild"
      fi
    else
      log "WARP runtime failed during identity rebuild attempt ${attempt}"
    fi

    if [ "$attempt" -lt "$ROTATE_MAX_ATTEMPTS" ]; then
      sleep "$ROTATE_RETRY_DELAY_SECONDS"
    fi
    attempt=$((attempt + 1))
  done

  if restore_previous_runtime; then
    log "no different public IPv4 was observed; previous runtime restored"
    rm -f "$PREVIOUS_CONF"
    return 0
  fi

  log "rotation failed and no working runtime is available"
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

  if ! is_positive_int "$ROTATE_MAX_ATTEMPTS"; then
    log "invalid ROTATE_MAX_ATTEMPTS=${ROTATE_MAX_ATTEMPTS}, fallback to 5"
    ROTATE_MAX_ATTEMPTS=5
  fi

  if ! is_non_negative_int "$ROTATE_RETRY_DELAY_SECONDS"; then
    log "invalid ROTATE_RETRY_DELAY_SECONDS=${ROTATE_RETRY_DELAY_SECONDS}, fallback to 5"
    ROTATE_RETRY_DELAY_SECONDS=5
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

  log "scheduled WARP identity rebuild enabled every ${interval} minute(s); egress verification allows ${ROTATE_MAX_ATTEMPTS} attempt(s)"
  while true; do
    sleep "$((interval * 60))"
    log "trigger scheduled WARP identity rebuild"
    if ! rotate_once; then
      log "rotation failed"
      exit 1
    fi
  done
}

main "$@"
