#!/bin/bash
set -euo pipefail

APP_DATA_DIR="${APP_DATA_DIR:-./data}"
if test -z "$APP_DATA_DIR" || test "$APP_DATA_DIR" = "/"; then
  echo "APP_DATA_DIR must be a non-root directory" >&2
  exit 1
fi

PROXY_DOMAIN="${PROXY_DOMAIN:-localhost}"
CERT_DOMAIN_RE='^([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?)(\.([A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?))*$'
IPV4_RE='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
if [[ "$PROXY_DOMAIN" =~ $IPV4_RE ]]; then
  IFS='.' read -r -a octets <<< "$PROXY_DOMAIN"
  for octet in "${octets[@]}"; do
    if [[ ${#octet} -gt 1 && "$octet" == 0* ]]; then
      echo "PROXY_DOMAIN is not a canonical IPv4 address" >&2
      exit 1
    fi
    if (( 10#$octet > 255 )); then
      echo "PROXY_DOMAIN is not a valid IPv4 address" >&2
      exit 1
    fi
  done
elif [[ ! "$PROXY_DOMAIN" =~ $CERT_DOMAIN_RE ]]; then
  echo "PROXY_DOMAIN must be a DNS name or IPv4 address without a scheme or port" >&2
  exit 1
fi
