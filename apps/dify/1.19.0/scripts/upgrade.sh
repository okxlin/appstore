#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

get_env_value() {
  local key="$1"
  local default="$2"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
    value="${value%\"}"
    value="${value#\"}"
    value="${value%\'}"
    value="${value#\'}"
  fi

  if [[ -n "$value" ]]; then
    printf '%s\n' "$value"
  else
    printf '%s\n' "$default"
  fi
}

set_env_value() {
  local key="$1"
  local value="$2"

  touch "$ENV_FILE"
  sed -i -E "/^${key}=/d" "$ENV_FILE"
  printf '%s=%s\n' "$key" "$value" >>"$ENV_FILE"
}

generate_random_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
  else
    od -An -N32 -tx1 /dev/urandom | tr -d ' \n'
  fi
}

generate_agent_server_secret() {
  local value

  if command -v openssl >/dev/null 2>&1; then
    value="$(openssl rand -base64 32)"
  elif command -v base64 >/dev/null 2>&1; then
    value="$(head -c 32 /dev/urandom | base64)"
  else
    echo "[dify:upgrade] cannot generate DIFY_AGENT_SERVER_SECRET_KEY: openssl or base64 is required" >&2
    return 1
  fi

  printf '%s' "$value" | tr '+/' '-_' | tr -d '=\n'
}

is_valid_agent_server_secret() {
  local value="$1"
  local normalized
  local decoded_length

  [[ "$value" =~ ^[A-Za-z0-9_-]+={0,2}$ ]] || return 1
  normalized="${value//-/+}"
  normalized="${normalized//_/\/}"
  case $((${#normalized} % 4)) in
    0) ;;
    2) normalized="${normalized}==" ;;
    3) normalized="${normalized}=" ;;
    *) return 1 ;;
  esac

  if command -v base64 >/dev/null 2>&1; then
    decoded_length="$(printf '%s' "$normalized" | base64 -d 2>/dev/null | wc -c | tr -d '[:space:]')" || return 1
  elif command -v openssl >/dev/null 2>&1; then
    decoded_length="$(printf '%s' "$normalized" | openssl base64 -d -A 2>/dev/null | wc -c | tr -d '[:space:]')" || return 1
  else
    return 1
  fi

  [[ "$decoded_length" == "32" ]]
}

ensure_env_secret() {
  local key="$1"
  local value

  value="$(get_env_value "$key" "")"
  if [[ -n "$value" ]]; then
    return
  fi

  value="${!key:-}"
  if [[ -z "$value" ]]; then
    value="$(generate_random_secret)"
  fi

  set_env_value "$key" "$value"
  echo "[dify:upgrade] generated missing ${key}"
}

ensure_agent_server_secret() {
  local value
  local reason="missing"

  value="$(get_env_value "DIFY_AGENT_SERVER_SECRET_KEY" "")"
  if [[ -z "$value" ]]; then
    value="${DIFY_AGENT_SERVER_SECRET_KEY:-}"
  fi
  if [[ -n "$value" ]] && is_valid_agent_server_secret "$value"; then
    set_env_value "DIFY_AGENT_SERVER_SECRET_KEY" "$value"
    return
  fi
  if [[ -n "$value" ]]; then
    reason="invalid"
  fi

  value="$(generate_agent_server_secret)"
  set_env_value "DIFY_AGENT_SERVER_SECRET_KEY" "$value"
  echo "[dify:upgrade] replaced ${reason} DIFY_AGENT_SERVER_SECRET_KEY with a generated 32-byte Base64URL key"
}

resolve_app_path() {
  local raw="$1"
  if [[ "$raw" = /* ]]; then
    printf '%s\n' "$raw"
  else
    printf '%s\n' "$ROOT_DIR/${raw#./}"
  fi
}

trim_trailing_slash() {
  local raw="$1"
  if [[ "$raw" == "/" ]]; then
    printf '/\n'
  else
    printf '%s\n' "${raw%/}"
  fi
}

to_ws_url() {
  local raw="$1"
  case "$raw" in
    https://*)
      printf 'wss://%s\n' "${raw#https://}"
      ;;
    http://*)
      printf 'ws://%s\n' "${raw#http://}"
      ;;
    *)
      printf '\n'
      ;;
  esac
}

extract_host() {
  local raw="$1"
  raw="${raw#http://}"
  raw="${raw#https://}"
  raw="${raw%%/*}"
  if [[ "$raw" == *:* ]]; then
    raw="${raw%%:*}"
  fi
  printf '%s\n' "$raw"
}

extract_origin() {
  local raw="$1"
  local scheme="http"
  local remainder="$raw"

  if [[ "$raw" == https://* ]]; then
    scheme="https"
    remainder="${raw#https://}"
  elif [[ "$raw" == http://* ]]; then
    scheme="http"
    remainder="${raw#http://}"
  fi

  remainder="${remainder%%/*}"
  if [[ -n "$remainder" ]]; then
    printf '%s://%s\n' "$scheme" "$remainder"
  else
    printf '\n'
  fi
}

rewrite_managed_custom_env() {
  local file="$1"
  local public_base_url="$2"
  local enable_collaboration="$3"

  local begin_marker="# --- BEGIN 1PANEL DIFY MANAGED BLOCK ---"
  local end_marker="# --- END 1PANEL DIFY MANAGED BLOCK ---"
  local tmp_file
  tmp_file="$(mktemp)"

  if [[ -f "$file" ]]; then
    awk -v begin="$begin_marker" -v end="$end_marker" '
      $0 == begin {skip=1; next}
      $0 == end {skip=0; next}
      !skip {print}
    ' "$file" >"$tmp_file"
  fi

  if [[ -n "$public_base_url" ]]; then
    local normalized_url
    local public_origin
    local websocket_url
    local public_host

    normalized_url="$(trim_trailing_slash "$public_base_url")"
    public_origin="$(extract_origin "$normalized_url")"
    websocket_url="$(to_ws_url "$public_origin")"
    public_host="$(extract_host "$normalized_url")"

    {
      [[ -s "$tmp_file" ]] && printf '\n'
      printf '%s\n' "$begin_marker"
      printf 'TRIGGER_URL=%s\n' "$normalized_url"
      printf 'ENDPOINT_URL_TEMPLATE=%s/e/{hook_id}\n' "$normalized_url"
      if [[ -n "$public_host" ]]; then
        printf 'PLUGIN_REMOTE_INSTALL_HOST=%s\n' "$public_host"
      fi
      if [[ "$enable_collaboration" == "true" ]]; then
        if [[ -n "$websocket_url" ]]; then
          printf 'NEXT_PUBLIC_SOCKET_URL=%s\n' "$websocket_url"
        else
          printf 'NEXT_PUBLIC_SOCKET_URL=/\n'
        fi
      fi
      printf '%s\n' "$end_marker"
    } >>"$tmp_file"
  fi

  mv "$tmp_file" "$file"
}

APP_DATA_DIR_RAW="${APP_DATA_DIR:-$(get_env_value "APP_DATA_DIR" "./data")}"
CUSTOM_ENV_FILE_RAW="${CUSTOM_ENV_FILE:-$(get_env_value "CUSTOM_ENV_FILE" "./data/custom.env")}"
PUBLIC_BASE_URL_RAW="${PUBLIC_BASE_URL:-$(get_env_value "PUBLIC_BASE_URL" "")}"
ENABLE_COLLABORATION_MODE_RAW="${ENABLE_COLLABORATION_MODE:-$(get_env_value "ENABLE_COLLABORATION_MODE" "false")}"

ensure_env_secret "DIFY_AGENT_SHELLCTL_AUTH_TOKEN"
ensure_agent_server_secret

APP_DATA_DIR_ABS="$(resolve_app_path "$APP_DATA_DIR_RAW")"
CUSTOM_ENV_FILE_ABS="$(resolve_app_path "$CUSTOM_ENV_FILE_RAW")"

mkdir -p \
  "$APP_DATA_DIR_ABS/app/storage" \
  "$APP_DATA_DIR_ABS/plugin_daemon" \
  "$APP_DATA_DIR_ABS/sandbox/dependencies" \
  "$APP_DATA_DIR_ABS/weaviate" \
  "$APP_DATA_DIR_ABS/nginx/ssl" \
  "$APP_DATA_DIR_ABS/certbot/conf/live" \
  "$APP_DATA_DIR_ABS/certbot/conf" \
  "$APP_DATA_DIR_ABS/certbot/www"
mkdir -p "$(dirname "$CUSTOM_ENV_FILE_ABS")"
touch "$CUSTOM_ENV_FILE_ABS"

rewrite_managed_custom_env "$CUSTOM_ENV_FILE_ABS" "$PUBLIC_BASE_URL_RAW" "$ENABLE_COLLABORATION_MODE_RAW"

echo "[dify:upgrade] ensured persistent directories under ${APP_DATA_DIR_ABS}"
echo "[dify:upgrade] refreshed managed custom env block in ${CUSTOM_ENV_FILE_ABS}"
