#!/bin/bash
# upgrade.sh — codex-claude-workstation 1Panel upgrade helper
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd -P)"
ENV_FILE="${ROOT_DIR}/.env"

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

get_env_value() {
  local key="$1"
  local value

  value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  strip_matching_quotes "$value"
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

paseo_password_is_websocket_token() {
  local value="${1-}"
  local token_pattern="^[A-Za-z0-9!#\$%&'*+.^_\`|~-]+$"

  [[ ${#value} -ge 1 && ${#value} -le 128 && "$value" =~ $token_pattern ]]
}

ensure_env_default() {
  local key="$1"
  local value="$2"

  if grep -qE "^${key}=" "$ENV_FILE"; then
    echo "${key} already exists"
    return
  fi

  printf '%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  echo "Added ${key}"
}

if [[ -L "$ENV_FILE" ]]; then
  echo "Refusing to update a symlinked .env file" >&2
  exit 1
elif [[ -f "$ENV_FILE" ]]; then
  paseo_password_value="$(get_env_value PASEO_PASSWORD)"
  if [[ -n "$paseo_password_value" ]]; then
    if ! paseo_password_is_websocket_token "$paseo_password_value"; then
      echo "PASEO_PASSWORD must be 1-128 HTTP-token-safe characters; use: openssl rand -hex 24" >&2
      exit 1
    elif [[ ${#paseo_password_value} -lt 20 ]]; then
      echo "PASEO_PASSWORD must contain at least 20 characters for public access" >&2
      exit 1
    fi
  fi

  custom_env_file_raw="$(get_env_value CUSTOM_ENV_FILE)"
  custom_env_file_raw="${custom_env_file_raw:-./data/custom.env}"
  custom_env_file_abs="$(resolve_app_path CUSTOM_ENV_FILE "$custom_env_file_raw")"
  if [[ -L "$custom_env_file_abs" || -d "$custom_env_file_abs" ]]; then
    echo "CUSTOM_ENV_FILE must be a regular non-symlink file" >&2
    exit 1
  fi

  ensure_env_default "PANEL_APP_PORT_PASEO" "6767"
  ensure_env_default "PASEO_PASSWORD" ""
  ensure_env_default "FIX_WORKSPACE_OWNERSHIP_RECURSIVE" "false"
  ensure_env_default "CUSTOM_ENV_FILE" "./data/custom.env"
  ensure_env_default "GITHUB_TOKEN" ""
  ensure_env_default "GIT_AUTHOR_NAME" ""
  ensure_env_default "GIT_AUTHOR_EMAIL" ""
  ensure_env_default "GIT_COMMITTER_NAME" ""
  ensure_env_default "GIT_COMMITTER_EMAIL" ""
  chmod 0600 -- "$ENV_FILE"

  mkdir -p -- "$(dirname -- "$custom_env_file_abs")"
  [[ "$(resolve_app_path CUSTOM_ENV_FILE "$custom_env_file_raw")" == "$custom_env_file_abs" ]]
  if [[ -L "$custom_env_file_abs" || -d "$custom_env_file_abs" ]]; then
    echo "CUSTOM_ENV_FILE must be a regular non-symlink file" >&2
    exit 1
  elif [[ ! -e "$custom_env_file_abs" ]]; then
    install -m 0600 /dev/null "$custom_env_file_abs"
  elif [[ ! -f "$custom_env_file_abs" ]]; then
    echo "CUSTOM_ENV_FILE must be a regular non-symlink file" >&2
    exit 1
  else
    chmod 0600 -- "$custom_env_file_abs"
  fi
else
  echo "${ENV_FILE} not found; skipped environment migration"
fi

echo "Codex Claude Workstation upgrade migration completed."
