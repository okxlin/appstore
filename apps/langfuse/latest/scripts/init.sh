#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ROOT_DIR}/.env"
KEY_FILE="${ROOT_DIR}/.langfuse_encryption_key"

[[ -f "$ENV_FILE" ]] || { echo "missing .env" >&2; exit 1; }
[[ ! -L "$ENV_FILE" ]] || { echo "refusing symbolic-link .env" >&2; exit 1; }
[[ ! -e "$KEY_FILE" || ( -f "$KEY_FILE" && ! -L "$KEY_FILE" ) ]] || {
  echo "refusing non-regular encryption key cache" >&2
  exit 1
}

current="$(awk -F= '$1 == "ENCRYPTION_KEY" {sub(/^[^=]*=/, ""); value=$0} END {print value}' "$ENV_FILE")"
if [[ "$current" == \"*\" && "$current" == *\" ]]; then
  current="${current:1:${#current}-2}"
fi
cached=""
if [[ -f "$KEY_FILE" ]]; then
  cached="$(cat "$KEY_FILE")"
fi

if [[ "$cached" =~ ^[0-9a-fA-F]{64}$ ]]; then
  desired="$cached"
elif [[ "$current" =~ ^[0-9a-fA-F]{64}$ ]]; then
  desired="$current"
else
  command -v openssl >/dev/null 2>&1 || {
    echo "openssl is required to generate ENCRYPTION_KEY" >&2
    exit 1
  }
  desired="$(openssl rand -hex 32)"
fi

umask 077
env_tmp="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
key_tmp="$(mktemp "${KEY_FILE}.tmp.XXXXXX")"
cleanup() { rm -f -- "$env_tmp" "$key_tmp"; }
trap cleanup EXIT
awk -v desired="$desired" '
  BEGIN { updated = 0 }
  /^ENCRYPTION_KEY=/ {
    if (!updated) print "ENCRYPTION_KEY=" desired
    updated = 1
    next
  }
  { print }
  END {
    if (!updated) print "ENCRYPTION_KEY=" desired
  }
' "$ENV_FILE" > "$env_tmp"
printf '%s\n' "$desired" > "$key_tmp"
chmod 600 "$env_tmp" "$key_tmp"
mv -f -- "$env_tmp" "$ENV_FILE"
mv -f -- "$key_tmp" "$KEY_FILE"
trap - EXIT
