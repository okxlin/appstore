#!/bin/bash
# init.sh — codex-claude-workstation 1Panel 初始化脚本
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
ENV_FILE="${ROOT_DIR}/.env"

if [[ -L "$ENV_FILE" ]]; then
  echo "Refusing to read a symlinked .env file" >&2
  exit 1
elif [[ -f "$ENV_FILE" ]]; then
  chmod 0600 -- "$ENV_FILE"
fi

strip_matching_quotes() {
  local value="$1"
  if [[ ${#value} -ge 2 ]]; then
    if [[ "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
      value="${value:1:${#value}-2}"
    elif [[ "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
      value="${value:1:${#value}-2}"
    fi
  fi
  printf '%s\n' "$value"
}

get_config_value() {
  local key="$1"
  local default="$2"
  local value=""

  if [[ -n "${!key+x}" ]]; then
    value="${!key}"
  elif [[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]]; then
    value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
    value="$(strip_matching_quotes "$value")"
  fi

  if [[ -n "$value" ]]; then
    printf '%s\n' "$value"
  else
    printf '%s\n' "$default"
  fi
}

paseo_password_is_websocket_token() {
  local value="${1-}"
  local token_pattern="^[A-Za-z0-9!#\$%&'*+.^_\`|~-]+$"

  [[ ${#value} -ge 1 && ${#value} -le 128 && "$value" =~ $token_pattern ]]
}

resolve_app_path() {
  local key="$1"
  local raw="$2"
  local clean candidate resolved current part
  local -a parts=()
  case "$raw" in
    ""|/*|.|..|../*|*/../*|*/..) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  if [[ "$raw" =~ [[:cntrl:]] ]]; then
    echo "unsafe ${key} path" >&2
    return 1
  fi
  clean="${raw#./}"
  [[ -n "$clean" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  command -v realpath >/dev/null 2>&1 || { echo "realpath is required" >&2; return 1; }
  candidate="$ROOT_DIR/$clean"
  resolved="$(realpath -m -- "$candidate")" || { echo "unsafe ${key} path" >&2; return 1; }
  case "$resolved" in
    "$ROOT_DIR"/*) ;;
    *) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  current="$ROOT_DIR"
  IFS='/' read -r -a parts <<< "$clean"
  for part in "${parts[@]}"; do
    [[ -z "$part" || "$part" == "." ]] && continue
    current="$current/$part"
    if [[ -L "$current" ]]; then
      echo "unsafe ${key} path" >&2
      return 1
    fi
  done
  printf '%s\n' "$resolved"
}

APP_DATA_DIR_RAW="$(get_config_value APP_DATA_DIR ./data)"
CUSTOM_ENV_FILE_RAW="$(get_config_value CUSTOM_ENV_FILE ./data/custom.env)"
PANEL_APP_PORT_HTTP_VALUE="$(get_config_value PANEL_APP_PORT_HTTP 8080)"
PANEL_APP_PORT_PASEO_VALUE="$(get_config_value PANEL_APP_PORT_PASEO 6767)"
PASEO_PASSWORD_VALUE="$(get_config_value PASEO_PASSWORD "")"
CODE_SERVER_PASSWORD_VALUE="$(get_config_value CODE_SERVER_PASSWORD change-me)"

if [[ -n "$PASEO_PASSWORD_VALUE" ]]; then
  if ! paseo_password_is_websocket_token "$PASEO_PASSWORD_VALUE"; then
    echo "PASEO_PASSWORD must be 1-128 HTTP-token-safe characters; use: openssl rand -hex 24" >&2
    exit 1
  elif [[ ${#PASEO_PASSWORD_VALUE} -lt 20 ]]; then
    echo "PASEO_PASSWORD must contain at least 20 characters for public access" >&2
    exit 1
  fi
elif ! paseo_password_is_websocket_token "$CODE_SERVER_PASSWORD_VALUE"; then
  echo "WARN: blank PASEO_PASSWORD falls back to a code-server password that is not browser WebSocket-token-safe." >&2
  echo "WARN: code-server will remain usable, but set a separate PASEO_PASSWORD before enabling mobile access." >&2
elif [[ ${#CODE_SERVER_PASSWORD_VALUE} -lt 20 ]]; then
  echo "WARN: blank PASEO_PASSWORD uses a code-server password shorter than the recommended 20 characters." >&2
fi

APP_DATA_DIR_ABS="$(resolve_app_path APP_DATA_DIR "$APP_DATA_DIR_RAW")"
WORKSPACE_DIR="$(resolve_app_path APP_DATA_DIR "${APP_DATA_DIR_RAW%/}/workspace")"
CUSTOM_ENV_FILE_ABS="$(resolve_app_path CUSTOM_ENV_FILE "$CUSTOM_ENV_FILE_RAW")"

mkdir -p -- "$WORKSPACE_DIR" "$(dirname -- "$CUSTOM_ENV_FILE_ABS")"

# Recheck after creation so a pre-existing or concurrently introduced symlink
# cannot silently redirect the file preparation outside the app directory.
[[ "$(resolve_app_path APP_DATA_DIR "$APP_DATA_DIR_RAW")" == "$APP_DATA_DIR_ABS" ]]
[[ "$(resolve_app_path APP_DATA_DIR "${APP_DATA_DIR_RAW%/}/workspace")" == "$WORKSPACE_DIR" ]]
[[ "$(resolve_app_path CUSTOM_ENV_FILE "$CUSTOM_ENV_FILE_RAW")" == "$CUSTOM_ENV_FILE_ABS" ]]

if [[ -L "$CUSTOM_ENV_FILE_ABS" || -d "$CUSTOM_ENV_FILE_ABS" ]]; then
  echo "CUSTOM_ENV_FILE must be a regular non-symlink file" >&2
  exit 1
fi
if [[ ! -e "$CUSTOM_ENV_FILE_ABS" ]]; then
  install -m 0600 /dev/null "$CUSTOM_ENV_FILE_ABS"
fi
chmod 0600 -- "$CUSTOM_ENV_FILE_ABS"

echo "Codex Claude Workstation installed successfully."
echo ""
echo "Persistent directories:"
echo "  ${WORKSPACE_DIR} -> /workspace"
echo "  ${CUSTOM_ENV_FILE_ABS} -> custom env_file"
echo ""
echo "Access:"
echo "  http://<server-ip>:${PANEL_APP_PORT_HTTP_VALUE}"
echo "  Paseo: reverse proxy HTTPS to 127.0.0.1:${PANEL_APP_PORT_PASEO_VALUE}"
echo "  Login: code-server password"
echo "  Switch to root: su - root (password configured from ROOT_PASSWORD)"
echo ""
echo "AI Tools (run in code-server terminal):"
echo "  codex --help          OpenAI Codex CLI"
echo "  claude --help         Anthropic Claude Code"
echo "  npm install -g <pkg>  Installs to persistent ~/.local"
echo ""
echo "Docker CLI (DOCKER_SOCK_SRC=/var/run/docker.sock by default; leave empty to disable):"
echo "  docker ps"
echo "  sudo docker ps  # fallback if host socket permissions block direct access"
echo ""
echo "Codex sandbox:"
echo "  doctor.sh"
echo "  Host must allow kernel.unprivileged_userns_clone=1"
echo ""
echo "Proxy (manual enable):"
echo "  supervisorctl start clash-meta  # or sing-box, xray"
echo "  Configs: ~/proxy/"
