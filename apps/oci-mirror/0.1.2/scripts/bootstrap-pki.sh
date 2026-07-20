#!/bin/bash
set -euo pipefail
umask 077

PKI_DIR=${OCI_MIRROR_PKI_DIR:-}
GATEWAY_ID=${OCI_MIRROR_MTLS_GATEWAY_ID:-gateway-1}
PUBLIC_HOST=${OCI_MIRROR_PUBLIC_HOST:-}
EGRESS_CERTS=${OCI_MIRROR_MTLS_EGRESS_CERTS:-}
CA_DAYS=${OCI_MIRROR_MTLS_CA_DAYS:-3650}
LEAF_DAYS=${OCI_MIRROR_MTLS_LEAF_DAYS:-397}
GENERATE_GATEWAY_SERVER=${OCI_MIRROR_MTLS_GENERATE_GATEWAY_SERVER:-true}

die() {
  printf 'OCI Mirror PKI: %s\n' "$1" >&2
  exit 1
}

command -v openssl >/dev/null 2>&1 || die 'OpenSSL is required for mTLS certificate initialization'
command -v flock >/dev/null 2>&1 || die 'flock is required for concurrent-safe mTLS certificate initialization'
[[ -n "$PKI_DIR" ]] || die 'OCI_MIRROR_PKI_DIR must not be empty'
[[ "$PKI_DIR" == /* ]] || die 'OCI_MIRROR_PKI_DIR must be an absolute path'
[[ "$GATEWAY_ID" =~ ^[a-z][a-z0-9_-]{0,31}$ ]] || die 'OCI_MIRROR_MTLS_GATEWAY_ID must match ^[a-z][a-z0-9_-]{0,31}$'
[[ -n "$PUBLIC_HOST" ]] || die 'OCI_MIRROR_PUBLIC_HOST must not be empty'
[[ "$GENERATE_GATEWAY_SERVER" == true || "$GENERATE_GATEWAY_SERVER" == false ]] || die 'OCI_MIRROR_MTLS_GENERATE_GATEWAY_SERVER must be true or false'
if [[ ! "$CA_DAYS" =~ ^[0-9]+$ ]] || ((10#$CA_DAYS < 365 || 10#$CA_DAYS > 7300)); then
  die 'OCI_MIRROR_MTLS_CA_DAYS must be between 365 and 7300'
fi
if [[ ! "$LEAF_DAYS" =~ ^[0-9]+$ ]] || ((10#$LEAF_DAYS < 30 || 10#$LEAF_DAYS > 825)); then
  die 'OCI_MIRROR_MTLS_LEAF_DAYS must be between 30 and 825'
fi

valid_ipv4() {
  awk -F. 'NF != 4 { exit 1 } { for (i = 1; i <= 4; i++) if ($i !~ /^[0-9]+$/ || $i < 0 || $i > 255) exit 1 }' <<<"$1"
}

san_kind() {
  local value=$1
  if valid_ipv4 "$value"; then
    printf 'IP'
    return
  fi
  if [[ "$value" =~ ^[0-9A-Fa-f:]+$ && "$value" == *:* ]]; then
    printf 'IP'
    return
  fi
  [[ "$value" =~ ^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$ && "$value" != *..* ]] || die "invalid certificate DNS/IP SAN: $value"
  printf 'DNS'
}

san_display() {
  if [[ "$1" == IP ]]; then
    printf 'IP Address:%s' "$2"
  else
    printf 'DNS:%s' "$2"
  fi
}

install -d -m 0700 "$PKI_DIR" "$PKI_DIR/authority"
exec 9>"$PKI_DIR/.bootstrap.lock"
flock -w 60 9 || die 'timed out waiting for the PKI initialization lock'

AUTHORITY_DIR=$PKI_DIR/authority
CA_KEY=$AUTHORITY_DIR/nodes-ca.key
CA_CERT=$AUTHORITY_DIR/nodes-ca.crt
CA_SERIAL=$AUTHORITY_DIR/nodes-ca.srl

ensure_ca() {
  local key_tmp cert_tmp
  if [[ ! -e "$CA_KEY" && ! -e "$CA_CERT" ]]; then
    key_tmp=$(mktemp "$AUTHORITY_DIR/nodes-ca.key.XXXXXX")
    cert_tmp=$(mktemp "$AUTHORITY_DIR/nodes-ca.crt.XXXXXX")
    trap 'rm -f -- "${key_tmp:-}" "${cert_tmp:-}"' RETURN
    openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out "$key_tmp"
    openssl req -x509 -new -sha256 -days "$CA_DAYS" \
      -key "$key_tmp" -out "$cert_tmp" \
      -subj '/CN=OCI Mirror node CA' \
      -addext 'basicConstraints=critical,CA:TRUE,pathlen:0' \
      -addext 'keyUsage=critical,keyCertSign,cRLSign' \
      -addext 'subjectKeyIdentifier=hash'
    chmod 0600 "$key_tmp"
    chmod 0644 "$cert_tmp"
    mv "$key_tmp" "$CA_KEY"
    mv "$cert_tmp" "$CA_CERT"
    trap - RETURN
  elif [[ -e "$CA_KEY" && ! -e "$CA_CERT" ]]; then
    cert_tmp=$(mktemp "$AUTHORITY_DIR/nodes-ca.crt.XXXXXX")
    trap 'rm -f -- "${cert_tmp:-}"' RETURN
    openssl pkey -in "$CA_KEY" -noout >/dev/null
    openssl req -x509 -new -sha256 -days "$CA_DAYS" \
      -key "$CA_KEY" -out "$cert_tmp" \
      -subj '/CN=OCI Mirror node CA' \
      -addext 'basicConstraints=critical,CA:TRUE,pathlen:0' \
      -addext 'keyUsage=critical,keyCertSign,cRLSign' \
      -addext 'subjectKeyIdentifier=hash'
    chmod 0644 "$cert_tmp"
    mv "$cert_tmp" "$CA_CERT"
    trap - RETURN
  fi
  [[ -s "$CA_CERT" ]] || die 'nodes-ca.crt is missing or empty'
  openssl x509 -in "$CA_CERT" -noout >/dev/null || die 'nodes-ca.crt is invalid'
  openssl verify -CAfile "$CA_CERT" "$CA_CERT" >/dev/null || die 'nodes-ca.crt is not self-verifiable'
  if [[ -e "$CA_KEY" ]]; then
    chmod 0600 "$CA_KEY"
    openssl pkey -in "$CA_KEY" -noout >/dev/null || die 'nodes-ca.key is invalid'
    [[ "$(public_key_digest_from_key "$CA_KEY")" == "$(public_key_digest_from_cert "$CA_CERT")" ]] || die 'nodes-ca.key does not match nodes-ca.crt'
  fi
}

public_key_digest_from_key() {
  openssl pkey -in "$1" -pubout 2>/dev/null | sha256sum | awk '{print $1}'
}

public_key_digest_from_cert() {
  openssl x509 -in "$1" -pubkey -noout 2>/dev/null | sha256sum | awk '{print $1}'
}

normalized_san_set() {
  printf '%s' "$1" | tr ',' '\n' | sed 's/[[:space:]]//g; /^$/d' | LC_ALL=C sort | paste -sd, -
}

certificate_san_set() {
  local output
  output=$(openssl x509 -in "$1" -noout -ext subjectAltName 2>/dev/null) || return 1
  printf '%s\n' "$output" | sed -n '2,$p' | tr ',' '\n' | sed 's/[[:space:]]//g; /^$/d' | LC_ALL=C sort | paste -sd, -
}

verify_existing_leaf() {
  local key=$1 cert=$2 expected_sans=$3
  local actual_sans
  shift 3
  [[ -s "$key" && -s "$cert" ]] || die "partial certificate pair exists: $cert"
  openssl pkey -in "$key" -noout >/dev/null || die "invalid private key: $key"
  openssl x509 -in "$cert" -noout >/dev/null || die "invalid certificate: $cert"
  [[ "$(public_key_digest_from_key "$key")" == "$(public_key_digest_from_cert "$cert")" ]] || die "certificate and key do not match: $cert"
  actual_sans=$(certificate_san_set "$cert") || die "certificate has no readable subjectAltName extension: $cert"
  [[ "$actual_sans" == "$(normalized_san_set "$expected_sans")" ]] || die "existing certificate SAN does not match requested identity: $cert"
  local purpose
  for purpose in "$@"; do
    openssl verify -CAfile "$CA_CERT" -purpose "$purpose" "$cert" >/dev/null || die "certificate verification failed for $purpose: $cert"
  done
}

ensure_leaf() {
  local directory=$1 key_name=$2 cert_name=$3 common_name=$4 expected_san=$5 ext_content=$6
  shift 6
  local key=$directory/$key_name
  local cert=$directory/$cert_name
  local key_tmp csr_tmp ext_tmp cert_tmp
  install -d -m 0750 "$directory"
  if [[ -e "$cert" && ! -e "$key" ]]; then
    die "certificate exists without its private key: $cert"
  fi
  if [[ -e "$key" && -e "$cert" ]]; then
    verify_existing_leaf "$key" "$cert" "$expected_san" "$@"
    return
  fi
  [[ -s "$CA_KEY" ]] || die "nodes-ca.key is required to issue missing certificate: $cert"
  if [[ ! -e "$key" ]]; then
    key_tmp=$(mktemp "$directory/$key_name.XXXXXX")
    openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out "$key_tmp"
    chmod 0600 "$key_tmp"
    mv "$key_tmp" "$key"
  fi
  csr_tmp=$(mktemp "$directory/$cert_name.csr.XXXXXX")
  ext_tmp=$(mktemp "$directory/$cert_name.ext.XXXXXX")
  cert_tmp=$(mktemp "$directory/$cert_name.new.XXXXXX")
  trap 'rm -f -- "${csr_tmp:-}" "${ext_tmp:-}" "${cert_tmp:-}"' RETURN
  printf '%s\n' "$ext_content" > "$ext_tmp"
  openssl req -new -sha256 -key "$key" -out "$csr_tmp" -subj "/CN=$common_name"
  openssl x509 -req -sha256 -days "$LEAF_DAYS" \
    -in "$csr_tmp" -CA "$CA_CERT" -CAkey "$CA_KEY" \
    -CAserial "$CA_SERIAL" -CAcreateserial -out "$cert_tmp" -extfile "$ext_tmp"
  chmod 0644 "$cert_tmp"
  mv "$cert_tmp" "$cert"
  trap - RETURN
  verify_existing_leaf "$key" "$cert" "$expected_san" "$@"
}

system_ca_bundle() {
  local candidate
  for candidate in \
    /etc/ssl/certs/ca-certificates.crt \
    /etc/pki/tls/certs/ca-bundle.crt \
    /etc/ssl/ca-bundle.pem; do
    if [[ -s "$candidate" ]]; then
      printf '%s' "$candidate"
      return
    fi
  done
  die 'a system CA bundle is required to build the OCI Mirror trust bundle'
}

write_runtime_bundle() {
  local directory=$1
  local trust_tmp
  install -d -m 0750 "$directory"
  install -m 0644 "$CA_CERT" "$directory/nodes-ca.crt"
  trust_tmp=$(mktemp "$directory/trust-bundle.crt.XXXXXX")
  cat "$(system_ca_bundle)" "$CA_CERT" > "$trust_tmp"
  chmod 0644 "$trust_tmp"
  if [[ -s "$directory/trust-bundle.crt" ]] && cmp -s "$trust_tmp" "$directory/trust-bundle.crt"; then
    rm -f "$trust_tmp"
  else
    mv "$trust_tmp" "$directory/trust-bundle.crt"
  fi
}

ensure_ca

GATEWAY_DIR=$PKI_DIR/gateway
gateway_spiffe=spiffe://oci-mirror/gateway/$GATEWAY_ID
ensure_leaf "$GATEWAY_DIR" gateway-client.key gateway-client.crt "oci-mirror-$GATEWAY_ID" \
  "URI:$gateway_spiffe" \
  $'basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature\nextendedKeyUsage=critical,clientAuth\nsubjectAltName=URI:'"$gateway_spiffe" \
  sslclient

if [[ "$GENERATE_GATEWAY_SERVER" == true ]]; then
  public_san_kind=$(san_kind "$PUBLIC_HOST")
  public_san_display=$(san_display "$public_san_kind" "$PUBLIC_HOST")
  ensure_leaf "$GATEWAY_DIR" server.key server.crt "oci-mirror-$GATEWAY_ID-public" \
    "$public_san_display" \
    $'basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature\nextendedKeyUsage=critical,serverAuth\nsubjectAltName='"$public_san_kind:$PUBLIC_HOST" \
    sslserver
fi
write_runtime_bundle "$GATEWAY_DIR"

[[ -n "$EGRESS_CERTS" ]] || die 'OCI_MIRROR_MTLS_EGRESS_CERTS must contain at least one node-id=DNS/IP entry'
declare -A seen_nodes=()
IFS=',' read -r -a certificate_specs <<< "$EGRESS_CERTS"
(( ${#certificate_specs[@]} >= 1 && ${#certificate_specs[@]} <= 32 )) || die 'OCI_MIRROR_MTLS_EGRESS_CERTS must contain between 1 and 32 entries'
for certificate_spec in "${certificate_specs[@]}"; do
  node_id=${certificate_spec%%=*}
  node_host=${certificate_spec#*=}
  [[ "$certificate_spec" == *=* && -n "$node_id" && -n "$node_host" ]] || die "invalid Egress certificate entry: $certificate_spec"
  [[ "$node_id" =~ ^[a-z][a-z0-9_-]{0,31}$ ]] || die "invalid Egress node ID: $node_id"
  [[ -z "${seen_nodes[$node_id]:-}" ]] || die "duplicate Egress node ID: $node_id"
  seen_nodes[$node_id]=1
  node_san_kind=$(san_kind "$node_host")
  node_san_display=$(san_display "$node_san_kind" "$node_host")
  node_spiffe=spiffe://oci-mirror/egress/$node_id
  node_dir=$PKI_DIR/egress/$node_id
  ensure_leaf "$node_dir" egress-node.key egress-node.crt "oci-mirror-$node_id" \
    "$node_san_display,URI:$node_spiffe" \
    $'basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature\nextendedKeyUsage=critical,serverAuth,clientAuth\nsubjectAltName='"$node_san_kind:$node_host,URI:$node_spiffe" \
    sslclient sslserver
  write_runtime_bundle "$node_dir"
done

printf 'OCI Mirror PKI: initialized Gateway identity and %s Egress certificate bundle(s) under %s\n' "${#certificate_specs[@]}" "$PKI_DIR"
