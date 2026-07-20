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

valid_private_or_loopback_ipv4() {
  valid_ipv4 "$1" || return 1
  awk -F. '$1 == 10 || $1 == 127 || ($1 == 172 && $2 >= 16 && $2 <= 31) || ($1 == 192 && $2 == 168) { exit 0 } { exit 1 }' <<<"$1"
}

valid_dns_name() {
  [[ "$1" =~ ^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$ && "$1" != *..* ]]
}

valid_ipv4_cidr() {
  local address=${1%%/*}
  local prefix=32
  if [[ "$1" == */* ]]; then
    prefix=${1##*/}
  fi
  valid_ipv4 "$address" && [[ "$prefix" =~ ^[0-9]+$ ]] && ((10#$prefix >= 0 && 10#$prefix <= 32))
}

valid_allowlist() {
  [[ -z "$1" || "$1" =~ ^[A-Fa-f0-9.:/]+$ ]]
}

valid_bearer_token() {
  local length
  length="$(LC_ALL=C printf '%s' "$1" | wc -c)"
  ((length >= 32 && length <= 4096)) && [[ "$1" =~ ^[A-Za-z0-9._~+/-]+=*$ ]]
}

valid_node_id() {
  [[ "$1" =~ ^[a-z][a-z0-9_-]{0,31}$ ]]
}

valid_private_http_origin() {
  local value=$1
  local host
  local port
  [[ "$value" =~ ^http://([^/:]+):([0-9]+)$ ]] || return 1
  host=${BASH_REMATCH[1]}
  port=${BASH_REMATCH[2]}
  valid_port "$port" || return 1
  if valid_ipv4 "$host"; then
    valid_private_or_loopback_ipv4 "$host"
  else
    valid_dns_name "$host"
  fi
}

safe_data_dir() {
  case "$1" in
    / | /bin | /boot | /dev | /etc | /home | /lib | /lib64 | /media | /mnt | /opt | /proc | /root | /run | /sbin | /srv | /sys | /tmp | /usr | /var | /var/lib | /workspace)
      return 1
      ;;
  esac
}

CIDR_SOURCE_PATTERN='^[A-Za-z0-9._:/ -]+$'

ROLE="$(read_env OCI_MIRROR_ROLE)"
ROLE="${ROLE,,}"
SERVICE_PORT="$(read_env PANEL_APP_PORT_HTTP)"
NODE_ID="$(read_env OCI_MIRROR_EGRESS_NODE_ID)"
EGRESS_TOKEN="$(read_env OCI_MIRROR_EGRESS_TOKEN)"
DATA_DIR_VALUE="$(read_env APP_DATA_DIR)"
[[ -n "$DATA_DIR_VALUE" ]] || die 'APP_DATA_DIR must not be empty'
DATA_DIR="$(absolute_path "$DATA_DIR_VALUE")"

[[ "$ROLE" == gateway || "$ROLE" == egress ]] || die 'OCI_MIRROR_ROLE must be gateway or egress'
valid_port "$SERVICE_PORT" || die 'PANEL_APP_PORT_HTTP must be a valid port for the selected node role'
valid_node_id "$NODE_ID" || die 'OCI_MIRROR_EGRESS_NODE_ID must match ^[a-z][a-z0-9_-]{0,31}$'
valid_bearer_token "$EGRESS_TOKEN" || die 'OCI_MIRROR_EGRESS_TOKEN must be a 32 to 4096 byte bearer token'
safe_data_dir "$DATA_DIR" || die 'APP_DATA_DIR is too broad'
[[ "$DATA_DIR" != "$ROOT_DIR" && "$DATA_DIR" != "$ROOT_DIR/config" && "$DATA_DIR" != "$ROOT_DIR/config/"* ]] || die 'APP_DATA_DIR must not point to the application or its config directory'

install -d -m 0750 "$ROOT_DIR/config" "$ROOT_DIR/config/tls" "$DATA_DIR"

if [[ "$ROLE" == gateway ]]; then
  MANAGEMENT_IP="$(read_env OCI_MIRROR_GATEWAY_MANAGEMENT_IP)"
  MANAGEMENT_PORT="$(read_env PANEL_APP_PORT_MANAGEMENT)"
  PUBLIC_HOST="$(read_env OCI_MIRROR_PUBLIC_HOST)"
  EGRESS_PROXY_URL="$(read_env OCI_MIRROR_EGRESS_PROXY_URL)"
  SOURCE_IPV4="$(read_env OCI_MIRROR_SOURCE_IPV4)"
  IP_ALLOWLIST="$(read_env OCI_MIRROR_IP_ALLOWLIST)"
  CIDR_FILE="$(read_env OCI_MIRROR_CHINA_CIDR_FILE)"
  CIDR_SOURCE="$(read_env OCI_MIRROR_CHINA_CIDR_SOURCE)"
  CIDR_UPDATED="$(read_env OCI_MIRROR_CHINA_CIDR_UPDATED)"
  TLS_ENABLED="$(read_env OCI_MIRROR_TLS_ENABLED)"
  TLS_ENABLED="${TLS_ENABLED:-false}"
  TLS_ENABLED="${TLS_ENABLED,,}"
  TLS_DIR="$(read_env OCI_MIRROR_TLS_DIR)"
  MANAGEMENT_TOKEN="$(read_env OCI_MIRROR_MANAGEMENT_TOKEN)"

  valid_private_or_loopback_ipv4 "$MANAGEMENT_IP" || die 'OCI_MIRROR_GATEWAY_MANAGEMENT_IP must be a private or loopback IPv4 address assigned to this host'
  valid_port "$MANAGEMENT_PORT" || die 'PANEL_APP_PORT_MANAGEMENT must be a valid port for the Gateway role'
  [[ "$SERVICE_PORT" != "$MANAGEMENT_PORT" ]] || die 'Gateway public and management ports must be different'
  if ! valid_ipv4 "$PUBLIC_HOST"; then
    if ! valid_dns_name "$PUBLIC_HOST" || [[ "$PUBLIC_HOST" != *.* ]]; then
      die 'OCI_MIRROR_PUBLIC_HOST must be a DNS hostname or IPv4 address'
    fi
  fi
  valid_private_http_origin "$EGRESS_PROXY_URL" || die 'OCI_MIRROR_EGRESS_PROXY_URL must be an HTTP origin on a private IPv4 address or private DNS name with an explicit port'
  valid_ipv4 "$SOURCE_IPV4" || die 'OCI_MIRROR_SOURCE_IPV4 must be an IPv4 address assigned to the Egress host'
  valid_allowlist "$IP_ALLOWLIST" || die 'OCI_MIRROR_IP_ALLOWLIST must contain one IP address or CIDR'
  [[ -n "$CIDR_FILE" ]] || die 'OCI_MIRROR_CHINA_CIDR_FILE is required for the Gateway role'
  CIDR_FILE="$(absolute_path "$CIDR_FILE")"
  [[ -f "$CIDR_FILE" ]] || die "CIDR file does not exist: $CIDR_FILE"
  [[ -n "$CIDR_SOURCE" && -n "$CIDR_UPDATED" ]] || die 'CIDR source and update date are required for the Gateway role'
  [[ "$CIDR_SOURCE" =~ $CIDR_SOURCE_PATTERN ]] || die 'OCI_MIRROR_CHINA_CIDR_SOURCE contains invalid characters'
  [[ "$CIDR_UPDATED" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || die 'OCI_MIRROR_CHINA_CIDR_UPDATED must use YYYY-MM-DD'
  [[ "$TLS_ENABLED" == true || "$TLS_ENABLED" == false ]] || die 'OCI_MIRROR_TLS_ENABLED must be true or false'
  valid_bearer_token "$MANAGEMENT_TOKEN" || die 'OCI_MIRROR_MANAGEMENT_TOKEN must be a 32 to 4096 byte bearer token for the Gateway role'
  [[ "$MANAGEMENT_TOKEN" != "$EGRESS_TOKEN" ]] || die 'management and Egress tokens must be different'

  ALLOWLIST_JSON='[]'
  if [[ -n "$IP_ALLOWLIST" ]]; then
    [[ "$IP_ALLOWLIST" != *'"'* && "$IP_ALLOWLIST" != *$'\n'* ]] || die 'OCI_MIRROR_IP_ALLOWLIST contains invalid characters'
    ALLOWLIST_JSON="[\"$IP_ALLOWLIST\"]"
  fi

  TLS_JSON=''
  if [[ "$TLS_ENABLED" == true ]]; then
    [[ -n "$TLS_DIR" ]] || die 'OCI_MIRROR_TLS_DIR is required when Gateway TLS is enabled'
    TLS_DIR="$(absolute_path "$TLS_DIR")"
    [[ -f "$TLS_DIR/server.crt" && -f "$TLS_DIR/server.key" ]] || die 'TLS directory must contain server.crt and server.key'
    install -m 0644 "$TLS_DIR/server.crt" "$ROOT_DIR/config/tls/server.crt"
    install -m 0600 "$TLS_DIR/server.key" "$ROOT_DIR/config/tls/server.key"
    TLS_JSON=$'    "tls_cert_file": "/etc/oci-mirror/tls/server.crt",\n    "tls_key_file": "/etc/oci-mirror/tls/server.key",'
  else
    rm -f -- "$ROOT_DIR/config/tls/server.crt" "$ROOT_DIR/config/tls/server.key"
  fi

  install -m 0644 "$CIDR_FILE" "$ROOT_DIR/config/china-mainland.cidr"
  chown 65532:65532 "$DATA_DIR"

  cat > "$ROOT_DIR/config/runtime.json" <<EOF
{
  "gateway": {
    "listen": "0.0.0.0:${SERVICE_PORT}",
    "data_dir": "/var/lib/oci-mirror",
${TLS_JSON}
    "management": {
      "listen": "${MANAGEMENT_IP}:${MANAGEMENT_PORT}",
      "token_env": "OCI_MIRROR_MANAGEMENT_TOKEN",
      "public_admin": false
    },
    "egress_control": {
      "snapshot_validity_seconds": 3600,
      "probe_interval_seconds": 300
    },
    "egress_nodes": [{
      "id": "${NODE_ID}",
      "proxy_url": "${EGRESS_PROXY_URL}",
      "token_env": "OCI_MIRROR_EGRESS_TOKEN",
      "weight": 1,
      "transport": {"mode": "private"},
      "pools": [{
        "id": "dockerhub",
        "policy": "sticky",
        "ipv4_sources": ["${SOURCE_IPV4}"],
        "ipv6_sources": [],
        "cooldown_base_seconds": 60,
        "cooldown_max_seconds": 3600
      }]
    }],
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
else
  EGRESS_LISTEN_IP="$(read_env OCI_MIRROR_EGRESS_LISTEN_IP)"
  GATEWAY_MANAGEMENT_URL="$(read_env OCI_MIRROR_GATEWAY_MANAGEMENT_URL)"
  GATEWAY_ALLOWED_PEER="$(read_env OCI_MIRROR_GATEWAY_ALLOWED_PEER)"

  valid_private_or_loopback_ipv4 "$EGRESS_LISTEN_IP" || die 'OCI_MIRROR_EGRESS_LISTEN_IP must be a private or loopback IPv4 address assigned to this host'
  valid_private_http_origin "$GATEWAY_MANAGEMENT_URL" || die 'OCI_MIRROR_GATEWAY_MANAGEMENT_URL must be an HTTP origin on a private IPv4 address or private DNS name with an explicit port'
  valid_ipv4_cidr "$GATEWAY_ALLOWED_PEER" || die 'OCI_MIRROR_GATEWAY_ALLOWED_PEER must be one IPv4 address or CIDR'

  rm -f -- "$ROOT_DIR/config/china-mainland.cidr" "$ROOT_DIR/config/tls/server.crt" "$ROOT_DIR/config/tls/server.key"
  cat > "$ROOT_DIR/config/runtime.json" <<EOF
{
  "egress": {
    "node_id": "${NODE_ID}",
    "listen": "${EGRESS_LISTEN_IP}:${SERVICE_PORT}",
    "token_env": "OCI_MIRROR_EGRESS_TOKEN",
    "allowed_peers": ["${GATEWAY_ALLOWED_PEER}"],
    "snapshot_url": "${GATEWAY_MANAGEMENT_URL}/v1/egress/nodes/${NODE_ID}/snapshot",
    "transport": {"mode": "private"},
    "snapshot_refresh_seconds": 60,
    "max_concurrent_tunnels": 128,
    "tunnel_idle_seconds": 120
  }
}
EOF
fi

chmod 0640 "$ROOT_DIR/config/runtime.json"
chown -R 65532:65532 "$ROOT_DIR/config"
