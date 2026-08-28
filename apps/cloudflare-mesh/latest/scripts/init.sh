#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  local value

  value="$(sed -n -E "s/^${key}=//p" "$ENV_FILE" | tail -n 1 || true)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "Environment file is missing or is a symbolic link"

node_token="$(read_env_value MESH_NODE_TOKEN)"
[[ -n "$node_token" && "$node_token" != replace-with-* ]] || fail "MESH_NODE_TOKEN must be configured"
[[ "$node_token" != *[[:space:]]* ]] || fail "MESH_NODE_TOKEN contains whitespace"

srcnat_enabled="$(read_env_value SRCNAT_ENABLED)"
[[ "$srcnat_enabled" == true || "$srcnat_enabled" == false ]] || fail "SRCNAT_ENABLED must be true or false"
