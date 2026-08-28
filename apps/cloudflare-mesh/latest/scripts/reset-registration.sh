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

[[ "${1:-}" == "--confirm" && "$#" -eq 1 ]] || fail "Usage: $0 --confirm (removes this application's local Mesh registration state)"
[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "Environment file is missing or is a symbolic link"
[[ -f "$ROOT_DIR/docker-compose.yml" ]] || fail "docker-compose.yml was not found in the application version directory"
[[ -z "${COMPOSE_FILE:-}" && -z "${COMPOSE_PROJECT_NAME:-}" ]] || fail "Unset COMPOSE_FILE and COMPOSE_PROJECT_NAME before re-registration"

node_token="$(read_env_value MESH_NODE_TOKEN)"
[[ -n "$node_token" && "$node_token" != replace-with-* ]] || fail "MESH_NODE_TOKEN must be configured before re-registration"
[[ "$node_token" != *[[:space:]]* ]] || fail "MESH_NODE_TOKEN contains whitespace"

if docker compose version >/dev/null 2>&1; then
  COMPOSE=(env -u CONTAINER_NAME -u MESH_NODE_TOKEN -u SRCNAT_ENABLED docker compose --env-file "$ENV_FILE" -f "$ROOT_DIR/docker-compose.yml")
elif docker-compose version >/dev/null 2>&1; then
  COMPOSE=(env -u CONTAINER_NAME -u MESH_NODE_TOKEN -u SRCNAT_ENABLED docker-compose --env-file "$ENV_FILE" -f "$ROOT_DIR/docker-compose.yml")
else
  fail "Docker Compose is not available"
fi

cd "$ROOT_DIR"
"${COMPOSE[@]}" config --quiet
services="$("${COMPOSE[@]}" config --services)"
[[ "$services" == "cloudflare-mesh" ]] || fail "Refusing reset: the Compose project contains an unexpected service"
volumes="$("${COMPOSE[@]}" config --volumes)"
[[ "$volumes" == "mesh_data" ]] || fail "Refusing reset: the Compose project contains an unexpected volume"

"${COMPOSE[@]}" down --volumes --remove-orphans
"${COMPOSE[@]}" up -d --force-recreate

printf '%s\n' "Local Mesh registration state was removed and the connector was recreated with the configured token."
printf '%s\n' "Verify the new registration with: docker compose exec -T cloudflare-mesh warp-cli status"
