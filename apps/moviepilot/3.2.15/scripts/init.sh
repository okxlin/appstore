#!/usr/bin/env bash
set -euo pipefail
umask 077

env_file="$PWD/.env"
[[ -f "$env_file" ]] || { printf '%s\n' 'MoviePilot app .env file is missing.' >&2; exit 1; }

has_token() {
    awk -F= '
        /^[[:space:]]*API_TOKEN[[:space:]]*=/ {
            value = substr($0, index($0, "=") + 1)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
            if (value == "\047\047" || value == "\"\"") value = ""
            if (value != "") found = 1
        }
        END { exit(found ? 0 : 1) }
    ' "$env_file"
}

has_token && exit 0

generated_token="$(od -An -N32 -tx1 /dev/urandom | tr -d '[:space:]')"
[[ "$generated_token" =~ ^[0-9a-f]{64}$ ]] || { printf '%s\n' 'Could not generate MoviePilot API_TOKEN.' >&2; exit 1; }
tmp_file="$(mktemp "${env_file}.tmp.XXXXXX")"
trap 'rm -f "$tmp_file"; unset generated_token' EXIT
awk '!/^[[:space:]]*API_TOKEN[[:space:]]*=/' "$env_file" > "$tmp_file"
printf '\nAPI_TOKEN=%s\n' "$generated_token" >> "$tmp_file"
chmod 600 "$tmp_file"
mv -f "$tmp_file" "$env_file"
unset generated_token
trap - EXIT
