#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
TTL_SECONDS="${1:-3600}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

base64url() {
  base64 | tr '+/' '-_' | tr -d '=\n'
}

[[ "$TTL_SECONDS" =~ ^[0-9]+$ ]] || fail "TTL must be an integer number of seconds"
((TTL_SECONDS >= 60 && TTL_SECONDS <= 86400)) || fail "TTL must be between 60 and 86400 seconds"
[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must be a regular file"
command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate a token"

jwt_key="$(sed -n 's/^PREST_JWT_KEY=//p' "$ENV_FILE" | tail -n 1)"
if [[ ${#jwt_key} -ge 2 && "${jwt_key:0:1}" == '"' && "${jwt_key: -1}" == '"' ]]; then
  jwt_key="${jwt_key:1:${#jwt_key}-2}"
elif [[ ${#jwt_key} -ge 2 && "${jwt_key:0:1}" == "'" && "${jwt_key: -1}" == "'" ]]; then
  jwt_key="${jwt_key:1:${#jwt_key}-2}"
fi
[[ "$jwt_key" != "generate" && ${#jwt_key} -ge 32 ]] || fail "Run scripts/init.sh before generating a token"

now="$(date +%s)"
expires="$((now + TTL_SECONDS))"
header="$(printf '%s' '{"alg":"HS256","typ":"JWT"}' | base64url)"
payload="$(printf '{"nbf":%s,"exp":%s}' "$now" "$expires" | base64url)"
unsigned="${header}.${payload}"
signature="$(printf '%s' "$unsigned" | openssl dgst -sha256 -binary -hmac "$jwt_key" | base64url)"
printf '%s.%s\n' "$unsigned" "$signature"
