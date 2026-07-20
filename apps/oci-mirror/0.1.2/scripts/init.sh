#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

read_env() {
  local key=$1
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  if [[ "$value" == \"*\" ]] || [[ "$value" == \'*\' ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s' "$value"
}

die() {
  printf 'OCI Mirror init: %s\n' "$1" >&2
  exit 1
}

absolute_path() {
  local value=$1
  if [[ "$value" == /* ]]; then
    realpath -m -- "$value"
  else
    realpath -m -- "$ROOT_DIR/$value"
  fi
}

valid_port() {
  [[ "$1" =~ ^[0-9]+$ ]] && ((10#$1 >= 1 && 10#$1 <= 65535))
}

valid_ipv4() {
  awk -F. 'NF != 4 { exit 1 } { for (i = 1; i <= 4; i++) if ($i !~ /^[0-9]+$/ || $i < 0 || $i > 255) exit 1 }' <<<"$1"
}

valid_allowlist() {
  [[ -z "$1" || "$1" =~ ^[A-Fa-f0-9.:/]+$ ]]
}

valid_bearer_token() {
  local length
  length="$(LC_ALL=C printf '%s' "$1" | wc -c)"
  ((length >= 32 && length <= 4096)) && [[ "$1" =~ ^[A-Za-z0-9._~+/-]+=*$ ]]
}

safe_data_dir() {
  case "$1" in
    / | /bin | /boot | /dev | /etc | /home | /lib | /lib64 | /media | /mnt | /opt | /proc | /root | /run | /sbin | /srv | /sys | /tmp | /usr | /var | /var/lib | /workspace)
      return 1
      ;;
  esac
}

CIDR_SOURCE_PATTERN='^[A-Za-z0-9._:/ -]+$'

PUBLIC_PORT="$(read_env PANEL_APP_PORT_HTTP)"
MANAGEMENT_PORT="$(read_env PANEL_APP_PORT_MANAGEMENT)"
EGRESS_PORT="$(read_env PANEL_APP_PORT_EGRESS)"
PUBLIC_HOST="$(read_env OCI_MIRROR_PUBLIC_HOST)"
SOURCE_IPV4="$(read_env OCI_MIRROR_SOURCE_IPV4)"
IP_ALLOWLIST="$(read_env OCI_MIRROR_IP_ALLOWLIST)"
CIDR_FILE="$(read_env OCI_MIRROR_CHINA_CIDR_FILE)"
CIDR_SOURCE="$(read_env OCI_MIRROR_CHINA_CIDR_SOURCE)"
CIDR_UPDATED="$(read_env OCI_MIRROR_CHINA_CIDR_UPDATED)"
TLS_ENABLED="$(read_env OCI_MIRROR_TLS_ENABLED)"
TLS_ENABLED="${TLS_ENABLED:-false}"
TLS_ENABLED="${TLS_ENABLED,,}"
TLS_DIR="$(read_env OCI_MIRROR_TLS_DIR)"
DATA_DIR="$(absolute_path "$(read_env APP_DATA_DIR)")"
MANAGEMENT_TOKEN="$(read_env OCI_MIRROR_MANAGEMENT_TOKEN)"
EGRESS_TOKEN="$(read_env OCI_MIRROR_EGRESS_TOKEN)"

valid_port "$PUBLIC_PORT" || die 'PANEL_APP_PORT_HTTP must be a valid port'
valid_port "$MANAGEMENT_PORT" || die 'PANEL_APP_PORT_MANAGEMENT must be a valid port'
valid_port "$EGRESS_PORT" || die 'PANEL_APP_PORT_EGRESS must be a valid port'
[[ "$PUBLIC_PORT" != "$MANAGEMENT_PORT" && "$PUBLIC_PORT" != "$EGRESS_PORT" && "$MANAGEMENT_PORT" != "$EGRESS_PORT" ]] || die 'all three ports must be different'
if ! valid_ipv4 "$PUBLIC_HOST"; then
  [[ "$PUBLIC_HOST" =~ ^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$ && "$PUBLIC_HOST" == *.* ]] || die 'OCI_MIRROR_PUBLIC_HOST must be a DNS hostname or IPv4 address'
fi
valid_ipv4 "$SOURCE_IPV4" || die 'OCI_MIRROR_SOURCE_IPV4 must be an IPv4 address assigned to this host'
valid_allowlist "$IP_ALLOWLIST" || die 'OCI_MIRROR_IP_ALLOWLIST must contain one IP address or CIDR'
[[ -n "$CIDR_FILE" ]] || die 'OCI_MIRROR_CHINA_CIDR_FILE is required'
CIDR_FILE="$(absolute_path "$CIDR_FILE")"
[[ -f "$CIDR_FILE" ]] || die "CIDR file does not exist: $CIDR_FILE"
[[ -n "$CIDR_SOURCE" && -n "$CIDR_UPDATED" ]] || die 'CIDR source and update date are required'
[[ "$CIDR_SOURCE" =~ $CIDR_SOURCE_PATTERN ]] || die 'OCI_MIRROR_CHINA_CIDR_SOURCE contains invalid characters'
[[ "$CIDR_UPDATED" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || die 'OCI_MIRROR_CHINA_CIDR_UPDATED must use YYYY-MM-DD'
[[ "$TLS_ENABLED" == true || "$TLS_ENABLED" == false ]] || die 'OCI_MIRROR_TLS_ENABLED must be true or false'
safe_data_dir "$DATA_DIR" || die 'APP_DATA_DIR is too broad'
valid_bearer_token "$MANAGEMENT_TOKEN" || die 'OCI_MIRROR_MANAGEMENT_TOKEN must be a 32 to 4096 byte bearer token'
valid_bearer_token "$EGRESS_TOKEN" || die 'OCI_MIRROR_EGRESS_TOKEN must be a 32 to 4096 byte bearer token'
[[ "$MANAGEMENT_TOKEN" != "$EGRESS_TOKEN" ]] || die 'management and Egress tokens must be different'

ALLOWLIST_JSON='[]'
if [[ -n "$IP_ALLOWLIST" ]]; then
  [[ "$IP_ALLOWLIST" != *'"'* && "$IP_ALLOWLIST" != *$'\n'* ]] || die 'OCI_MIRROR_IP_ALLOWLIST contains invalid characters'
  ALLOWLIST_JSON="[\"$IP_ALLOWLIST\"]"
fi

TLS_JSON=''
install -d -m 0750 "$ROOT_DIR/config/tls"
if [[ "$TLS_ENABLED" == true ]]; then
  [[ -n "$TLS_DIR" ]] || die 'OCI_MIRROR_TLS_DIR is required when TLS is enabled'
  TLS_DIR="$(absolute_path "$TLS_DIR")"
  [[ -f "$TLS_DIR/server.crt" && -f "$TLS_DIR/server.key" ]] || die 'TLS directory must contain server.crt and server.key'
  install -m 0644 "$TLS_DIR/server.crt" "$ROOT_DIR/config/tls/server.crt"
  install -m 0600 "$TLS_DIR/server.key" "$ROOT_DIR/config/tls/server.key"
  TLS_JSON=$'    "tls_cert_file": "/etc/oci-mirror/tls/server.crt",\n    "tls_key_file": "/etc/oci-mirror/tls/server.key",'
else
  rm -f -- "$ROOT_DIR/config/tls/server.crt" "$ROOT_DIR/config/tls/server.key"
fi

install -d -m 0750 "$ROOT_DIR/config" "$DATA_DIR"
install -m 0644 "$CIDR_FILE" "$ROOT_DIR/config/china-mainland.cidr"
chown 65532:65532 "$DATA_DIR"
chown -R 65532:65532 "$ROOT_DIR/config"

cat > "$ROOT_DIR/config/gateway.json" <<EOF
{
  "gateway": {
    "listen": "0.0.0.0:${PUBLIC_PORT}",
    "data_dir": "/var/lib/oci-mirror",
${TLS_JSON}
    "egress_proxy_url": "http://127.0.0.1:${EGRESS_PORT}",
    "egress_token_env": "OCI_MIRROR_EGRESS_TOKEN",
    "egress_transport": {"mode": "private"},
    "management": {
      "listen": "127.0.0.1:${MANAGEMENT_PORT}",
      "token_env": "OCI_MIRROR_MANAGEMENT_TOKEN",
      "public_admin": false
    },
    "egress_control": {
      "snapshot_validity_seconds": 3600,
      "probe_interval_seconds": 300,
      "pools": [{
        "id": "dockerhub",
        "policy": "sticky",
        "ipv4_sources": ["${SOURCE_IPV4}"],
        "ipv6_sources": [],
        "cooldown_base_seconds": 60,
        "cooldown_max_seconds": 3600
      }]
    },
    "trusted_proxies": [],
    "registries": [{
      "id": "dockerhub",
      "kind": "dockerhub",
      "public_host": "${PUBLIC_HOST}",
      "upstream": "https://registry-1.docker.io",
      "allowed_auth_hosts": ["auth.docker.io"],
      "allowed_redirect_hosts": ["production.cloudflare.docker.com"]
    }],
    "reverse_proxies": [],
    "access": {
      "china_cidr_file": "/etc/oci-mirror/china-mainland.cidr",
      "china_cidr_source": "${CIDR_SOURCE}",
      "china_cidr_updated": "${CIDR_UPDATED}",
      "ip_allowlist": ${ALLOWLIST_JSON}
    },
    "quota": {
      "visitor_bytes_24h": 16106127360,
      "manifest_pulls_6h": 200,
      "api_requests_per_minute": 120,
      "api_request_burst": 60,
      "max_concurrent_blobs": 3,
      "max_concurrent_blobs_global": 64,
      "max_concurrent_requests_global": 256,
      "max_concurrent_manifest_fetches_global": 64,
      "visitor_bytes_per_second": 10485760,
      "monthly_bytes": 80000000000000,
      "monthly_soft_bytes": 64000000000000,
      "monthly_hard_bytes": 72000000000000
    },
    "cache": {
      "high_bytes": 8589934592,
      "low_bytes": 6442450944,
      "high_objects": 100000,
      "low_objects": 80000,
      "max_blob_bytes": 8589934592,
      "max_inflight_bytes": 8589934592,
      "min_free_bytes": 2147483648,
      "recent_protection_seconds": 300,
      "hot_hits_per_hour": 10,
      "eviction_batch_size": 256
    }
  }
}
EOF

cat > "$ROOT_DIR/config/egress.json" <<EOF
{
  "egress": {
    "listen": "127.0.0.1:${EGRESS_PORT}",
    "token_env": "OCI_MIRROR_EGRESS_TOKEN",
    "allowed_peers": ["127.0.0.1/32"],
    "snapshot_url": "http://127.0.0.1:${MANAGEMENT_PORT}/v1/egress/snapshot",
    "transport": {"mode": "private"},
    "snapshot_refresh_seconds": 60,
    "max_concurrent_tunnels": 128,
    "tunnel_idle_seconds": 120
  }
}
EOF

chmod 0640 "$ROOT_DIR/config/gateway.json" "$ROOT_DIR/config/egress.json"
chown 65532:65532 "$ROOT_DIR/config/gateway.json" "$ROOT_DIR/config/egress.json"
