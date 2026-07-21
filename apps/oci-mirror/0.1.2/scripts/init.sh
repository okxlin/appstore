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
  local value=$1
  local octet
  local -a octets
  IFS=. read -r -a octets <<< "$value"
  (( ${#octets[@]} == 4 )) || return 1
  for octet in "${octets[@]}"; do
    [[ "$octet" =~ ^(0|[1-9][0-9]{0,2})$ ]] || return 1
    ((10#$octet <= 255)) || return 1
  done
}

valid_ipv6_hextet_sequence() {
  local sequence=$1
  local hextet
  local -a hextets

  [[ -z "$sequence" ]] && return 0
  [[ "$sequence" != :* && "$sequence" != *: && "$sequence" != *::* ]] || return 1
  IFS=: read -r -a hextets <<< "$sequence"
  for hextet in "${hextets[@]}"; do
    [[ "$hextet" =~ ^[0-9A-Fa-f]{1,4}$ ]] || return 1
  done
}

expand_ipv6_hextets() {
  local value=$1
  local left right explicit zero_count i hextet
  local -a left_hextets=() right_hextets=() full_hextets=()

  IPV6_EXPANDED_HEXTETS=()
  if [[ "$value" == *::* ]]; then
    [[ "${value#*::}" != *::* ]] || return 1
    left=${value%%::*}
    right=${value#*::}
    valid_ipv6_hextet_sequence "$left" || return 1
    valid_ipv6_hextet_sequence "$right" || return 1
    if [[ -n "$left" ]]; then
      IFS=: read -r -a left_hextets <<< "$left"
    fi
    if [[ -n "$right" ]]; then
      IFS=: read -r -a right_hextets <<< "$right"
    fi
    explicit=$(( ${#left_hextets[@]} + ${#right_hextets[@]} ))
    ((explicit < 8)) || return 1
    zero_count=$((8 - explicit))
    full_hextets=("${left_hextets[@]}")
    for ((i = 0; i < zero_count; i++)); do
      full_hextets+=(0)
    done
    full_hextets+=("${right_hextets[@]}")
  else
    [[ "$value" != :* && "$value" != *: ]] || return 1
    valid_ipv6_hextet_sequence "$value" || return 1
    IFS=: read -r -a full_hextets <<< "$value"
    (( ${#full_hextets[@]} == 8 )) || return 1
  fi

  for hextet in "${full_hextets[@]}"; do
    IPV6_EXPANDED_HEXTETS+=("${hextet,,}")
  done
}

valid_ipv6() {
  local value=$1
  local hextet

  [[ "$value" =~ ^[0-9A-Fa-f:]+$ ]] || return 1
  expand_ipv6_hextets "$value" || return 1
  if [[ "${IPV6_EXPANDED_HEXTETS[0]}" =~ ^0+$ &&
        "${IPV6_EXPANDED_HEXTETS[1]}" =~ ^0+$ &&
        "${IPV6_EXPANDED_HEXTETS[2]}" =~ ^0+$ &&
        "${IPV6_EXPANDED_HEXTETS[3]}" =~ ^0+$ &&
        "${IPV6_EXPANDED_HEXTETS[4]}" =~ ^0+$ &&
        "${IPV6_EXPANDED_HEXTETS[5]}" == ffff ]]; then
    return 1
  fi
  for hextet in "${IPV6_EXPANDED_HEXTETS[@]}"; do
    [[ "$hextet" =~ ^[0-9a-f]{1,4}$ ]] || return 1
  done
}

json_string_array() {
  local value
  local separator=''
  local result='['
  for value in "$@"; do
    result+="${separator}\"${value}\""
    separator=','
  done
  printf '%s]' "$result"
}

parse_egress_source_addresses() {
  local input=$1
  local entry address canonical network_key
  local -a entries=() ipv4_sources=() ipv6_sources=()
  local -A seen=() seen_ipv6_networks=()

  [[ -n "$input" ]] || die 'OCI_MIRROR_EGRESS_SOURCE_ADDRESSES must contain at least one IPv4 or IPv6 address'
  [[ "$input" != *$'\n'* && "$input" != *$'\r'* ]] || die 'OCI_MIRROR_EGRESS_SOURCE_ADDRESSES must be a comma-separated single-line list'
  [[ "$input" != *, ]] || die 'OCI_MIRROR_EGRESS_SOURCE_ADDRESSES must not contain an empty trailing item'
  IFS=',' read -r -a entries <<< "$input"
  (( ${#entries[@]} >= 1 && ${#entries[@]} <= 256 )) || die 'OCI_MIRROR_EGRESS_SOURCE_ADDRESSES must contain 1 to 256 addresses'

  for entry in "${entries[@]}"; do
    canonical=''
    address="${entry#"${entry%%[![:space:]]*}"}"
    address="${address%"${address##*[![:space:]]}"}"
    [[ -n "$address" ]] || die 'OCI_MIRROR_EGRESS_SOURCE_ADDRESSES must not contain empty items'
    if valid_ipv4 "$address"; then
      valid_public_source_ipv4 "$address" || die "OCI_MIRROR_EGRESS_SOURCE_ADDRESSES contains a non-public IPv4 address: $address"
      ipv4_sources+=("$address")
    elif valid_ipv6 "$address"; then
      valid_public_source_ipv6 "$address" || die "OCI_MIRROR_EGRESS_SOURCE_ADDRESSES contains a non-public IPv6 address: $address"
      canonical="$(canonical_ipv6 "$address")"
      IFS=: read -r -a IPV6_CANONICAL_HEXTETS <<<"$canonical"
      network_key="${IPV6_CANONICAL_HEXTETS[0]}:${IPV6_CANONICAL_HEXTETS[1]}:${IPV6_CANONICAL_HEXTETS[2]}:${IPV6_CANONICAL_HEXTETS[3]}"
      [[ -z ${seen_ipv6_networks["$network_key"]+x} ]] ||
        die "OCI_MIRROR_EGRESS_SOURCE_ADDRESSES contains IPv6 addresses from the same /64: $address"
      seen_ipv6_networks["$network_key"]=1
      ipv6_sources+=("$canonical")
    else
      die "OCI_MIRROR_EGRESS_SOURCE_ADDRESSES contains an invalid IPv4/IPv6 address: $address"
    fi
    if [[ -n "$canonical" ]]; then
      address="$canonical"
    fi
    if [[ -n ${seen["$address"]+x} ]]; then
      die "OCI_MIRROR_EGRESS_SOURCE_ADDRESSES contains duplicate address: $address"
    fi
    seen["$address"]=1
  done

  EGRESS_IPV4_SOURCES_JSON="$(json_string_array "${ipv4_sources[@]}")"
  EGRESS_IPV6_SOURCES_JSON="$(json_string_array "${ipv6_sources[@]}")"
}

valid_private_or_loopback_ipv4() {
  valid_ipv4 "$1" || return 1
  awk -F. '$1 == 10 || $1 == 127 || ($1 == 172 && $2 >= 16 && $2 <= 31) || ($1 == 192 && $2 == 168) { exit 0 } { exit 1 }' <<<"$1"
}

valid_private_or_loopback_ipv6() {
  valid_ipv6 "$1" || return 1
  local first second third fourth
  first=$((16#${IPV6_EXPANDED_HEXTETS[0]}))
  second=$((16#${IPV6_EXPANDED_HEXTETS[1]}))
  third=$((16#${IPV6_EXPANDED_HEXTETS[2]}))
  fourth=$((16#${IPV6_EXPANDED_HEXTETS[3]}))
  if ((first == 0 && second == 0 && third == 0 && fourth == 0)); then
    ((16#${IPV6_EXPANDED_HEXTETS[4]} == 0 &&
      16#${IPV6_EXPANDED_HEXTETS[5]} == 0 &&
      16#${IPV6_EXPANDED_HEXTETS[6]} == 0 &&
      16#${IPV6_EXPANDED_HEXTETS[7]} == 1))
    return
  fi
  ((first >= 0xfc00 && first <= 0xfdff))
}

valid_private_or_loopback_ip() {
  valid_private_or_loopback_ipv4 "$1" || valid_private_or_loopback_ipv6 "$1"
}

valid_listen_ip() {
  valid_ipv4 "$1" || valid_ipv6 "$1"
}

listen_address() {
  if [[ "$1" == *:* ]]; then
    printf '[%s]:%s' "$1" "$2"
  else
    printf '%s:%s' "$1" "$2"
  fi
}

canonical_ipv6() {
  local value=$1
  local hextet normalized separator='' result=''
  valid_ipv6 "$value" || return 1
  for hextet in "${IPV6_EXPANDED_HEXTETS[@]}"; do
    printf -v normalized '%x' "$((16#$hextet))"
    result+="${separator}${normalized}"
    separator=:
  done
  printf '%s' "$result"
}

canonical_host() {
  local value=$1
  if valid_ipv4 "$value"; then
    printf '%s' "$value"
  elif valid_ipv6 "$value"; then
    canonical_ipv6 "$value"
  else
    printf '%s' "${value,,}"
  fi
}

valid_public_source_ipv4() {
  local value=$1
  local first second third
  valid_ipv4 "$value" || return 1
  IFS=. read -r first second third _ <<<"$value"
  if ((
    (first == 192 && second == 0 && third == 2) ||
    (first == 198 && second == 51 && third == 100) ||
    (first == 203 && second == 0 && third == 113)
  )); then
    return 0
  fi
  ((first > 0 && first < 224)) || return 1
  ((first != 10 && first != 127)) || return 1
  ! ((first == 100 && second >= 64 && second <= 127)) || return 1
  ! ((first == 169 && second == 254)) || return 1
  ! ((first == 172 && second >= 16 && second <= 31)) || return 1
  ! ((first == 192 && (second == 0 || second == 88 || second == 168))) || return 1
  ! ((first == 198 && (second == 18 || second == 19))) || return 1
}

valid_public_source_ipv6() {
  local value=$1
  valid_ipv6 "$value" || return 1
  local first second third fourth fifth sixth seventh eighth embedded_ipv4
  first=$((16#${IPV6_EXPANDED_HEXTETS[0]}))
  second=$((16#${IPV6_EXPANDED_HEXTETS[1]}))
  third=$((16#${IPV6_EXPANDED_HEXTETS[2]}))
  fourth=$((16#${IPV6_EXPANDED_HEXTETS[3]}))
  fifth=$((16#${IPV6_EXPANDED_HEXTETS[4]}))
  sixth=$((16#${IPV6_EXPANDED_HEXTETS[5]}))
  seventh=$((16#${IPV6_EXPANDED_HEXTETS[6]}))
  eighth=$((16#${IPV6_EXPANDED_HEXTETS[7]}))
  if ((first == 0 && second == 0 && third == 0 && fourth == 0)); then
    return 1
  fi

  if ((first == 0x64 && second == 0xff9b && third == 0 && fourth == 0 && fifth == 0 && sixth == 0)); then
    printf -v embedded_ipv4 '%d.%d.%d.%d' \
      "$((seventh >> 8))" "$((seventh & 255))" "$((eighth >> 8))" "$((eighth & 255))"
    if [[ "$embedded_ipv4" == 192.0.2.* || "$embedded_ipv4" == 198.51.100.* || "$embedded_ipv4" == 203.0.113.* ]]; then
      return 1
    fi
    valid_public_source_ipv4 "$embedded_ipv4"
    return
  fi

  ((first == 0x64 && second == 0xff9b && third == 1)) && return 1
  ((first == 0x100 && second == 0 && third == 0 && fourth == 0)) && return 1
  ((first == 0x100 && second == 0 && third == 0 && fourth == 1)) && return 1
  if ((first == 0x2001 && second <= 0x1ff)); then
    if ((second == 1 && third == 0 && fourth == 0 && fifth == 0 && sixth == 0 && seventh == 0 && (eighth == 1 || eighth == 2 || eighth == 3))) ||
      ((second == 3)) ||
      ((second == 4 && third == 0x112)) ||
      ((second >= 0x20 && second <= 0x2f)) ||
      ((second >= 0x30 && second <= 0x3f)); then
      return 0
    fi
    return 1
  fi
  ((first >= 0x3ff0 && first <= 0x3fff)) && return 1
  ((first == 0x2002)) && return 1
  ((first == 0x5f00)) && return 1
  ((first >= 0xfc00 && first <= 0xfdff)) && return 1
  ((first >= 0xfe80 && first <= 0xfebf)) && return 1
  ((first >= 0xff00 && first <= 0xffff)) && return 1
  return 0
}

valid_dns_name() {
  [[ "$1" =~ ^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$ && "$1" != *..* ]]
}

valid_ip_cidr() {
  local address=${1%%/*}
  local prefix=32
  if [[ "$1" == */* ]]; then
    prefix=${1##*/}
  fi
  if valid_ipv4 "$address"; then
    [[ "$prefix" =~ ^[0-9]+$ ]] && ((10#$prefix >= 0 && 10#$prefix <= 32))
  else
    valid_ipv6 "$address" && [[ "$prefix" =~ ^[0-9]+$ ]] && ((10#$prefix >= 0 && 10#$prefix <= 128))
  fi
}

parse_ip_allowlist() {
  local input=$1 entry normalized
  local -a entries=() values=()
  [[ -z "$input" ]] && { ALLOWLIST_JSON='[]'; return; }
  [[ "$input" != *$'\n'* && "$input" != *$'\r'* ]] || die 'OCI_MIRROR_IP_ALLOWLIST must be a comma-separated single-line list'
  IFS=',' read -r -a entries <<<"$input"
  (( ${#entries[@]} >= 1 && ${#entries[@]} <= 4096 )) || die 'OCI_MIRROR_IP_ALLOWLIST must contain 1 to 4096 entries'
  for entry in "${entries[@]}"; do
    normalized="${entry#"${entry%%[![:space:]]*}"}"
    normalized="${normalized%"${normalized##*[![:space:]]}"}"
    valid_ip_cidr "$normalized" || die "OCI_MIRROR_IP_ALLOWLIST contains an invalid IP/CIDR entry: $normalized"
    values+=("$normalized")
  done
  ALLOWLIST_JSON="$(json_string_array "${values[@]}")"
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
  if [[ "$value" =~ ^http://\[([0-9A-Fa-f:]+)\]:([0-9]+)$ ]]; then
    host=${BASH_REMATCH[1]}
    port=${BASH_REMATCH[2]}
    valid_private_or_loopback_ipv6 "$host" && valid_port "$port"
    return
  fi
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

valid_https_origin() {
  local value=$1
  local host
  local port
  if [[ "$value" =~ ^https://\[([0-9A-Fa-f:]+)\]:([0-9]+)$ ]]; then
    host=${BASH_REMATCH[1]}
    port=${BASH_REMATCH[2]}
    valid_ipv6 "$host" || return 1
  elif [[ "$value" =~ ^https://([^/:]+):([0-9]+)$ ]]; then
    host=${BASH_REMATCH[1]}
    port=${BASH_REMATCH[2]}
    if ! valid_ipv4 "$host"; then
      valid_dns_name "$host" || return 1
    fi
  else
    return 1
  fi
  valid_port "$port"
}

origin_host() {
  local value=$1
  if [[ "$value" =~ ^https?://\[([0-9A-Fa-f:]+)\]:[0-9]+$ ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
  elif [[ "$value" =~ ^https?://([^/:]+):[0-9]+$ ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
  else
    return 1
  fi
}

certificate_host_for_node() {
  local wanted=$1
  local spec node host
  IFS=',' read -r -a specs <<< "$2"
  for spec in "${specs[@]}"; do
    node=${spec%%=*}
    host=${spec#*=}
    if [[ "$node" == "$wanted" ]]; then
      printf '%s' "$host"
      return 0
    fi
  done
  return 1
}

stage_runtime_pki() {
  local source_dir=$1
  local required_prefix=$2
  local trust_mode=$3
  local candidate
  rm -rf -- "$CONFIG_STAGE/pki"
  install -d -m 0750 "$CONFIG_STAGE/pki"
  install -m 0644 "$source_dir/nodes-ca.crt" "$CONFIG_STAGE/pki/nodes-ca.crt"
  if [[ "$trust_mode" == node ]]; then
    install -m 0644 "$source_dir/trust-bundle.crt" "$CONFIG_STAGE/pki/trust-bundle.crt"
  else
    for candidate in \
      /etc/ssl/certs/ca-certificates.crt \
      /etc/pki/tls/certs/ca-bundle.crt \
      /etc/ssl/ca-bundle.pem; do
      if [[ -s "$candidate" ]]; then
        install -m 0644 "$candidate" "$CONFIG_STAGE/pki/trust-bundle.crt"
        break
      fi
    done
    [[ -s "$CONFIG_STAGE/pki/trust-bundle.crt" ]] || die 'a system CA bundle is required for HTTPS upstream connections'
  fi
  install -m 0600 "$source_dir/$required_prefix.key" "$CONFIG_STAGE/pki/$required_prefix.key"
  install -m 0644 "$source_dir/$required_prefix.crt" "$CONFIG_STAGE/pki/$required_prefix.crt"
}

stage_system_trust_bundle() {
  local candidate
  rm -rf -- "$CONFIG_STAGE/pki"
  for candidate in \
    /etc/ssl/certs/ca-certificates.crt \
    /etc/pki/tls/certs/ca-bundle.crt \
    /etc/ssl/ca-bundle.pem; do
    if [[ -s "$candidate" ]]; then
      install -d -m 0750 "$CONFIG_STAGE/pki"
      install -m 0644 "$candidate" "$CONFIG_STAGE/pki/trust-bundle.crt"
      return
    fi
  done
  die 'a system CA bundle is required for HTTPS upstream connections'
}

publish_config() {
  local backup_dir had_existing=false
  backup_dir="$(mktemp -d "$ROOT_DIR/.oci-mirror-config-backup.XXXXXX")"
  if [[ -e "$CONFIG_DIR" ]]; then
    mv -- "$CONFIG_DIR" "$backup_dir/config"
    had_existing=true
  fi
  if ! mv -- "$CONFIG_STAGE" "$CONFIG_DIR"; then
    if [[ "$had_existing" == true ]]; then
      mv -- "$backup_dir/config" "$CONFIG_DIR"
    fi
    rmdir -- "$backup_dir" 2>/dev/null || true
    die 'failed to publish generated configuration'
  fi
  CONFIG_STAGE=
  rm -rf -- "$backup_dir"
}

cleanup_config_stage() {
  if [[ -n ${CONFIG_STAGE:-} && -d "$CONFIG_STAGE" ]]; then
    rm -rf -- "$CONFIG_STAGE"
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
CONFIG_DIR="$ROOT_DIR/config"
CONFIG_STAGE=
trap cleanup_config_stage EXIT

ROLE="$(read_env OCI_MIRROR_ROLE)"
ROLE="${ROLE,,}"
TRANSPORT_MODE="$(read_env OCI_MIRROR_TRANSPORT_MODE)"
TRANSPORT_MODE="${TRANSPORT_MODE,,}"
SERVICE_PORT="$(read_env PANEL_APP_PORT_HTTP)"
NODE_ID="$(read_env OCI_MIRROR_EGRESS_NODE_ID)"
EGRESS_TOKEN="$(read_env OCI_MIRROR_EGRESS_TOKEN)"
DATA_DIR_VALUE="$(read_env OCI_MIRROR_DATA_DIR)"
PKI_DIR_VALUE="$(read_env OCI_MIRROR_PKI_DIR)"
PKI_DIR_VALUE="${PKI_DIR_VALUE:-./pki}"
GATEWAY_ID="$(read_env OCI_MIRROR_MTLS_GATEWAY_ID)"
GATEWAY_ID="${GATEWAY_ID:-gateway-1}"
EGRESS_CERTS="$(read_env OCI_MIRROR_MTLS_EGRESS_CERTS)"
EGRESS_CERTS="${EGRESS_CERTS:-egress-a=egress.example.com}"
[[ -n "$DATA_DIR_VALUE" ]] || die 'OCI_MIRROR_DATA_DIR must not be empty'
DATA_DIR="$(absolute_path "$DATA_DIR_VALUE")"
PKI_DIR="$(absolute_path "$PKI_DIR_VALUE")"

[[ "$ROLE" == gateway || "$ROLE" == egress ]] || die 'OCI_MIRROR_ROLE must be gateway or egress'
[[ "$TRANSPORT_MODE" == private || "$TRANSPORT_MODE" == mtls ]] || die 'OCI_MIRROR_TRANSPORT_MODE must be private or mtls'
valid_port "$SERVICE_PORT" || die 'PANEL_APP_PORT_HTTP must be a valid port for the selected node role'
valid_node_id "$NODE_ID" || die 'OCI_MIRROR_EGRESS_NODE_ID must match ^[a-z][a-z0-9_-]{0,31}$'
valid_bearer_token "$EGRESS_TOKEN" || die 'OCI_MIRROR_EGRESS_TOKEN must be 32 to 4096 bytes using A-Z, a-z, 0-9, . _ ~ + / -, with optional trailing = padding'
safe_data_dir "$DATA_DIR" || die 'OCI_MIRROR_DATA_DIR is too broad'
safe_data_dir "$PKI_DIR" || die 'OCI_MIRROR_PKI_DIR is too broad'
[[ "$DATA_DIR" != "$ROOT_DIR" && "$DATA_DIR" != "$ROOT_DIR/config" && "$DATA_DIR" != "$ROOT_DIR/config/"* ]] || die 'OCI_MIRROR_DATA_DIR must not point to the application or its config directory'
[[ "$PKI_DIR" != "$ROOT_DIR" && "$PKI_DIR" != "$ROOT_DIR/config" && "$PKI_DIR" != "$ROOT_DIR/config/"* ]] || die 'OCI_MIRROR_PKI_DIR must not point to the application or its config directory'
[[ "$PKI_DIR" != "$DATA_DIR" && "$PKI_DIR" != "$DATA_DIR/"* ]] || die 'OCI_MIRROR_PKI_DIR must not be the data directory or one of its subdirectories'
[[ "$DATA_DIR" != "$PKI_DIR" && "$DATA_DIR" != "$PKI_DIR/"* ]] || die 'OCI_MIRROR_DATA_DIR must not be the PKI directory or one of its subdirectories'
[[ ! -L "$CONFIG_DIR" ]] || die 'the generated config directory must not be a symbolic link'
valid_node_id "$GATEWAY_ID" || die 'OCI_MIRROR_MTLS_GATEWAY_ID must match ^[a-z][a-z0-9_-]{0,31}$'

install -d -m 0750 "$DATA_DIR"
CONFIG_STAGE="$(mktemp -d "$ROOT_DIR/.oci-mirror-config.XXXXXX")"
install -d -m 0750 "$CONFIG_STAGE/tls"
stage_system_trust_bundle

if [[ "$ROLE" == gateway ]]; then
  MANAGEMENT_IP="$(read_env OCI_MIRROR_GATEWAY_MANAGEMENT_IP)"
  GATEWAY_LISTEN_IP="$(read_env OCI_MIRROR_GATEWAY_LISTEN_IP)"
  GATEWAY_LISTEN_IP="${GATEWAY_LISTEN_IP:-0.0.0.0}"
  MANAGEMENT_PORT="$(read_env PANEL_APP_PORT_MANAGEMENT)"
  PUBLIC_HOST="$(read_env OCI_MIRROR_PUBLIC_HOST)"
  EGRESS_PROXY_URL="$(read_env OCI_MIRROR_EGRESS_PROXY_URL)"
  SOURCE_ADDRESSES="$(read_env OCI_MIRROR_EGRESS_SOURCE_ADDRESSES)"
  IP_ALLOWLIST="$(read_env OCI_MIRROR_IP_ALLOWLIST)"
  CIDR_FILE="$(read_env OCI_MIRROR_CHINA_CIDR_FILE)"
  CIDR_SOURCE="$(read_env OCI_MIRROR_CHINA_CIDR_SOURCE)"
  CIDR_UPDATED="$(read_env OCI_MIRROR_CHINA_CIDR_UPDATED)"
  CIDR_REFRESH_DAYS="$(read_env OCI_MIRROR_CHINA_CIDR_REFRESH_DAYS)"
  CIDR_REFRESH_DAYS="${CIDR_REFRESH_DAYS:-30}"
  TLS_ENABLED="$(read_env OCI_MIRROR_TLS_ENABLED)"
  TLS_ENABLED="${TLS_ENABLED:-true}"
  TLS_ENABLED="${TLS_ENABLED,,}"
  TLS_DIR="$(read_env OCI_MIRROR_TLS_DIR)"
  MTLS_RENEW_BEFORE_DAYS="$(read_env OCI_MIRROR_MTLS_RENEW_BEFORE_DAYS)"
  MANAGEMENT_TOKEN="$(read_env OCI_MIRROR_MANAGEMENT_TOKEN)"

  valid_listen_ip "$GATEWAY_LISTEN_IP" || die 'OCI_MIRROR_GATEWAY_LISTEN_IP must be an IPv4 or IPv6 address'
  valid_private_or_loopback_ip "$MANAGEMENT_IP" || die 'OCI_MIRROR_GATEWAY_MANAGEMENT_IP must be a private or loopback IPv4/IPv6 address assigned to this host'
  valid_port "$MANAGEMENT_PORT" || die 'PANEL_APP_PORT_MANAGEMENT must be a valid port for the Gateway role'
  [[ "$SERVICE_PORT" != "$MANAGEMENT_PORT" ]] || die 'Gateway public and management ports must be different'
  if ! valid_ipv4 "$PUBLIC_HOST" && ! valid_ipv6 "$PUBLIC_HOST"; then
    if ! valid_dns_name "$PUBLIC_HOST" || [[ "$PUBLIC_HOST" != *.* ]]; then
      die 'OCI_MIRROR_PUBLIC_HOST must be a DNS hostname or IPv4/IPv6 address'
    fi
  fi
  if [[ "$TRANSPORT_MODE" == private ]]; then
    valid_private_http_origin "$EGRESS_PROXY_URL" || die 'OCI_MIRROR_EGRESS_PROXY_URL must be an HTTP origin on a private IPv4 address or private DNS name with an explicit port'
  else
    valid_https_origin "$EGRESS_PROXY_URL" || die 'OCI_MIRROR_EGRESS_PROXY_URL must be an HTTPS origin with an explicit port for mTLS'
  fi
  parse_egress_source_addresses "$SOURCE_ADDRESSES"
  parse_ip_allowlist "$IP_ALLOWLIST"
  if [[ ! "$CIDR_REFRESH_DAYS" =~ ^[0-9]+$ ]] ||
    ((10#$CIDR_REFRESH_DAYS < 1 || 10#$CIDR_REFRESH_DAYS > 365)); then
    die 'OCI_MIRROR_CHINA_CIDR_REFRESH_DAYS must be between 1 and 365'
  fi
  if [[ -n "$CIDR_FILE" ]]; then
    CIDR_FILE="$(absolute_path "$CIDR_FILE")"
    bash "$ROOT_DIR/scripts/generate-cidr.sh" --target "$CIDR_FILE"
  else
    CIDR_FILE="$DATA_DIR/china-mainland.cidr"
    bash "$ROOT_DIR/scripts/generate-cidr.sh" --target "$CIDR_FILE" --refresh-after-days "$CIDR_REFRESH_DAYS"
  fi
  [[ -s "$CIDR_FILE" ]] || die "CIDR file does not exist or is empty: $CIDR_FILE"
  CIDR_SOURCE="${CIDR_SOURCE:-https://ftp.apnic.net/stats/apnic/delegated-apnic-latest}"
  CIDR_UPDATED="${CIDR_UPDATED:-$(date -u -r "$CIDR_FILE" +%F)}"
  [[ "$CIDR_SOURCE" =~ $CIDR_SOURCE_PATTERN ]] || die 'OCI_MIRROR_CHINA_CIDR_SOURCE contains invalid characters'
  [[ "$CIDR_UPDATED" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || die 'OCI_MIRROR_CHINA_CIDR_UPDATED must use YYYY-MM-DD'
  [[ "$TLS_ENABLED" == true || "$TLS_ENABLED" == false ]] || die 'OCI_MIRROR_TLS_ENABLED must be true or false'
  [[ "$TRANSPORT_MODE" != mtls || "$TLS_ENABLED" == true ]] || die 'mTLS transport requires Gateway TLS to be enabled'
  valid_bearer_token "$MANAGEMENT_TOKEN" || die 'OCI_MIRROR_MANAGEMENT_TOKEN must be 32 to 4096 bytes using A-Z, a-z, 0-9, . _ ~ + / -, with optional trailing = padding for the Gateway role'
  [[ "$MANAGEMENT_TOKEN" != "$EGRESS_TOKEN" ]] || die 'management and Egress tokens must be different'
  if [[ "$TLS_ENABLED" == true && -n "$TLS_DIR" ]]; then
    TLS_DIR="$(absolute_path "$TLS_DIR")"
    if [[ "$TLS_DIR" != "$PKI_DIR/gateway" ]]; then
      [[ -f "$TLS_DIR/server.crt" && -f "$TLS_DIR/server.key" ]] || die 'TLS directory must contain server.crt and server.key'
    fi
  elif [[ "$TLS_ENABLED" == true && "$TRANSPORT_MODE" != mtls ]]; then
    die 'OCI_MIRROR_TLS_DIR is required when Gateway TLS is enabled outside mTLS mode'
  fi

  if [[ "$TRANSPORT_MODE" == mtls ]]; then
    GATEWAY_TRANSPORT_JSON=$(cat <<EOF
{"mode":"mtls","ca_file":"/etc/oci-mirror/pki/nodes-ca.crt","cert_file":"/etc/oci-mirror/pki/gateway-client.crt","key_file":"/etc/oci-mirror/pki/gateway-client.key","peer_spiffe_id":"spiffe://oci-mirror/egress/${NODE_ID}"}
EOF
)
    cert_host="$(certificate_host_for_node "$NODE_ID" "$EGRESS_CERTS")" || die 'OCI_MIRROR_MTLS_EGRESS_CERTS must include the selected Egress node ID'
    [[ "$(canonical_host "$cert_host")" == "$(canonical_host "$(origin_host "$EGRESS_PROXY_URL")")" ]] || die 'selected Egress certificate SAN host must match the Egress proxy URL host'
    export OCI_MIRROR_PKI_DIR="$PKI_DIR"
    export OCI_MIRROR_MTLS_GATEWAY_ID="$GATEWAY_ID"
    export OCI_MIRROR_PUBLIC_HOST="$PUBLIC_HOST"
    export OCI_MIRROR_MTLS_EGRESS_CERTS="$EGRESS_CERTS"
    if [[ -n "$MTLS_RENEW_BEFORE_DAYS" ]]; then
      export OCI_MIRROR_MTLS_RENEW_BEFORE_DAYS="$MTLS_RENEW_BEFORE_DAYS"
    fi
    if [[ -n "$TLS_DIR" ]]; then
      if [[ "$TLS_DIR" == "$PKI_DIR/gateway" ]]; then
        export OCI_MIRROR_MTLS_GENERATE_GATEWAY_SERVER=true
      else
        export OCI_MIRROR_MTLS_GENERATE_GATEWAY_SERVER=false
      fi
    else
      TLS_DIR="$PKI_DIR/gateway"
      export OCI_MIRROR_MTLS_GENERATE_GATEWAY_SERVER=true
    fi
    bash "$ROOT_DIR/scripts/bootstrap-pki.sh"
    stage_runtime_pki "$PKI_DIR/gateway" gateway-client system
  else
    GATEWAY_TRANSPORT_JSON='{"mode":"private"}'
  fi

  TLS_JSON=''
  if [[ "$TLS_ENABLED" == true ]]; then
    [[ -n "$TLS_DIR" ]] || die 'OCI_MIRROR_TLS_DIR is required when Gateway TLS is enabled'
    [[ -f "$TLS_DIR/server.crt" && -f "$TLS_DIR/server.key" ]] || die 'TLS directory must contain server.crt and server.key'
    install -m 0644 "$TLS_DIR/server.crt" "$CONFIG_STAGE/tls/server.crt"
    install -m 0600 "$TLS_DIR/server.key" "$CONFIG_STAGE/tls/server.key"
    TLS_JSON=$'    "tls_cert_file": "/etc/oci-mirror/tls/server.crt",\n    "tls_key_file": "/etc/oci-mirror/tls/server.key",'
  else
    rm -f -- "$CONFIG_STAGE/tls/server.crt" "$CONFIG_STAGE/tls/server.key"
  fi

  if [[ "$(realpath -m -- "$CIDR_FILE")" != "$(realpath -m -- "$CONFIG_STAGE/china-mainland.cidr")" ]]; then
    install -m 0644 "$CIDR_FILE" "$CONFIG_STAGE/china-mainland.cidr"
  fi
  chown 65532:65532 "$DATA_DIR"

  cat > "$CONFIG_STAGE/runtime.json" <<EOF
{
  "gateway": {
    "listen": "$(listen_address "$GATEWAY_LISTEN_IP" "$SERVICE_PORT")",
    "data_dir": "/var/lib/oci-mirror",
${TLS_JSON}
    "management": {
      "listen": "$(listen_address "$MANAGEMENT_IP" "$MANAGEMENT_PORT")",
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
      "transport": ${GATEWAY_TRANSPORT_JSON},
      "pools": [{
        "id": "dockerhub",
        "policy": "sticky",
        "ipv4_sources": ${EGRESS_IPV4_SOURCES_JSON},
        "ipv6_sources": ${EGRESS_IPV6_SOURCES_JSON},
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

  if [[ "$TRANSPORT_MODE" == private ]]; then
    valid_private_or_loopback_ip "$EGRESS_LISTEN_IP" || die 'OCI_MIRROR_EGRESS_LISTEN_IP must be a private or loopback IPv4/IPv6 address assigned to this host'
    valid_private_http_origin "$GATEWAY_MANAGEMENT_URL" || die 'OCI_MIRROR_GATEWAY_MANAGEMENT_URL must be an HTTP origin on a private IP address or private DNS name with an explicit port'
    valid_ip_cidr "$GATEWAY_ALLOWED_PEER" || die 'OCI_MIRROR_GATEWAY_ALLOWED_PEER must be one IPv4/IPv6 address or CIDR'
  else
    valid_listen_ip "$EGRESS_LISTEN_IP" || die 'OCI_MIRROR_EGRESS_LISTEN_IP must be an IPv4 or IPv6 listen address for mTLS'
    valid_https_origin "$GATEWAY_MANAGEMENT_URL" || die 'OCI_MIRROR_GATEWAY_MANAGEMENT_URL must be an HTTPS origin with an explicit port for mTLS'
    if [[ -n "$GATEWAY_ALLOWED_PEER" ]]; then
      valid_ip_cidr "$GATEWAY_ALLOWED_PEER" || die 'OCI_MIRROR_GATEWAY_ALLOWED_PEER must be one IPv4/IPv6 address or CIDR when provided'
    fi
    NODE_DIR="$PKI_DIR/egress/$NODE_ID"
    [[ -s "$NODE_DIR/nodes-ca.crt" && -s "$NODE_DIR/trust-bundle.crt" && -s "$NODE_DIR/egress-node.key" && -s "$NODE_DIR/egress-node.crt" ]] || die 'Egress mTLS bundle is missing; generate it on Gateway and copy the selected egress directory to OCI_MIRROR_PKI_DIR'
    stage_runtime_pki "$NODE_DIR" egress-node node
  fi

  rm -f -- "$CONFIG_STAGE/china-mainland.cidr" "$CONFIG_STAGE/tls/server.crt" "$CONFIG_STAGE/tls/server.key"
  if [[ "$TRANSPORT_MODE" == mtls ]]; then
    GATEWAY_TRANSPORT_JSON=$(cat <<EOF
{"mode":"mtls","ca_file":"/etc/oci-mirror/pki/nodes-ca.crt","cert_file":"/etc/oci-mirror/pki/egress-node.crt","key_file":"/etc/oci-mirror/pki/egress-node.key","peer_spiffe_id":"spiffe://oci-mirror/gateway/${GATEWAY_ID}"}
EOF
)
    ALLOWED_PEERS_JSON='[]'
    if [[ -n "$GATEWAY_ALLOWED_PEER" ]]; then
      ALLOWED_PEERS_JSON="[\"$GATEWAY_ALLOWED_PEER\"]"
    fi
  else
    GATEWAY_TRANSPORT_JSON='{"mode":"private"}'
    ALLOWED_PEERS_JSON="[\"$GATEWAY_ALLOWED_PEER\"]"
  fi
  cat > "$CONFIG_STAGE/runtime.json" <<EOF
{
  "egress": {
    "node_id": "${NODE_ID}",
    "listen": "$(listen_address "$EGRESS_LISTEN_IP" "$SERVICE_PORT")",
    "token_env": "OCI_MIRROR_EGRESS_TOKEN",
    "allowed_peers": ${ALLOWED_PEERS_JSON},
    "snapshot_url": "${GATEWAY_MANAGEMENT_URL}/v1/egress/nodes/${NODE_ID}/snapshot",
    "transport": ${GATEWAY_TRANSPORT_JSON},
    "snapshot_refresh_seconds": 60,
    "max_concurrent_tunnels": 128,
    "tunnel_idle_seconds": 120
  }
}
EOF
fi

chmod 0640 "$CONFIG_STAGE/runtime.json"
chown -R 65532:65532 "$CONFIG_STAGE"
publish_config
