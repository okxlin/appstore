#!/bin/bash
set -euo pipefail

SOURCE_URL=https://ftp.apnic.net/stats/apnic/delegated-apnic-latest
SOURCE_FILE=
TARGET=

while [[ $# -gt 0 ]]; do
  case "$1" in
    --source-file)
      SOURCE_FILE=$2
      shift 2
      ;;
    --source-url)
      SOURCE_URL=$2
      shift 2
      ;;
    --target)
      TARGET=$2
      shift 2
      ;;
    *)
      printf 'OCI Mirror CIDR: unknown argument: %s\n' "$1" >&2
      exit 2
      ;;
  esac
done

[[ -n "$TARGET" ]] || { printf 'OCI Mirror CIDR: --target is required\n' >&2; exit 2; }
if [[ -e "$TARGET" ]]; then
  [[ -s "$TARGET" ]] || { printf 'OCI Mirror CIDR: existing target is empty: %s\n' "$TARGET" >&2; exit 1; }
  printf 'OCI Mirror CIDR: preserving existing file: %s\n' "$TARGET"
  exit 0
fi

command -v awk >/dev/null 2>&1 || { printf 'OCI Mirror CIDR: awk is required\n' >&2; exit 1; }
command -v sort >/dev/null 2>&1 || { printf 'OCI Mirror CIDR: sort is required\n' >&2; exit 1; }

TARGET_DIR=$(dirname "$TARGET")
install -d -m 0750 "$TARGET_DIR"
SOURCE_TMP=$(mktemp "$TARGET_DIR/delegated-apnic.XXXXXX")
STAGED=$(mktemp "$TARGET_DIR/china-mainland.cidr.XXXXXX")
trap 'rm -f -- "$SOURCE_TMP" "$STAGED"' EXIT

if [[ -n "$SOURCE_FILE" ]]; then
  [[ -s "$SOURCE_FILE" ]] || { printf 'OCI Mirror CIDR: source file is missing or empty: %s\n' "$SOURCE_FILE" >&2; exit 1; }
  cp -- "$SOURCE_FILE" "$SOURCE_TMP"
else
  command -v curl >/dev/null 2>&1 || { printf 'OCI Mirror CIDR: curl is required for automatic APNIC download\n' >&2; exit 1; }
  curl --fail --location --silent --show-error --proto '=https' --tlsv1.2 \
    --output "$SOURCE_TMP" "$SOURCE_URL"
fi

awk -F'|' '
function fail(message) {
  print "OCI Mirror CIDR: " message > "/dev/stderr"
  exit 1
}
function ipv4_number(value, octets, idx, number) {
  if (split(value, octets, ".") != 4) fail("invalid IPv4 address " value)
  number = 0
  for (idx = 1; idx <= 4; idx++) {
    if (octets[idx] !~ /^[0-9]+$/ || octets[idx] < 0 || octets[idx] > 255) fail("invalid IPv4 address " value)
    number = number * 256 + octets[idx]
  }
  return number
}
function ipv4_string(number, first, second, third, fourth) {
  first = int(number / 16777216)
  number %= 16777216
  second = int(number / 65536)
  number %= 65536
  third = int(number / 256)
  fourth = number % 256
  return first "." second "." third "." fourth
}
function emit_ipv4_range(start, count, block, prefix, number, remaining) {
  if (count !~ /^[0-9]+$/ || count <= 0) fail("invalid IPv4 count " count)
  number = ipv4_number(start)
  if (number + count > 4294967296) fail("IPv4 range exceeds the address space: " start " count " count)
  remaining = count
  while (remaining > 0) {
    block = 1
    prefix = 32
    while (prefix > 0 && block * 2 <= remaining && number % (block * 2) == 0) {
      block *= 2
      prefix--
    }
    print ipv4_string(number) "/" prefix
    generated++
    if (generated > 200000) fail("generated CIDR data exceeds 200000 prefixes")
    number += block
    remaining -= block
  }
}
BEGIN { generated = 0 }
/^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
NF == 6 && $1 == "apnic" && $6 == "summary" { next }
NF != 7 { fail("invalid APNIC record at line " NR) }
$1 != "apnic" || $2 != "CN" || ($7 != "allocated" && $7 != "assigned") { next }
$3 == "ipv4" {
  emit_ipv4_range($4, $5)
  next
}
$3 == "ipv6" {
  if ($4 !~ /^[0-9A-Fa-f:]+$/ || $5 !~ /^[0-9]+$/ || $5 < 0 || $5 > 128) fail("invalid IPv6 prefix at line " NR)
  print tolower($4) "/" $5
  generated++
  next
}
END {
  if (generated == 0) fail("APNIC data contains no allocated or assigned CN prefixes")
  if (generated > 200000) fail("generated CIDR data exceeds 200000 prefixes")
}
' "$SOURCE_TMP" | LC_ALL=C sort -u > "$STAGED"

[[ -s "$STAGED" ]] || { printf 'OCI Mirror CIDR: generated file is empty\n' >&2; exit 1; }
line_count=$(wc -l < "$STAGED")
file_size=$(wc -c < "$STAGED")
((line_count <= 200000)) || { printf 'OCI Mirror CIDR: generated file has too many prefixes\n' >&2; exit 1; }
((file_size <= 16777216)) || { printf 'OCI Mirror CIDR: generated file exceeds 16 MiB\n' >&2; exit 1; }

chmod 0644 "$STAGED"
if ! ln "$STAGED" "$TARGET" 2>/dev/null; then
  [[ -s "$TARGET" ]] || { printf 'OCI Mirror CIDR: target appeared but is invalid: %s\n' "$TARGET" >&2; exit 1; }
  printf 'OCI Mirror CIDR: preserving concurrently created file: %s\n' "$TARGET"
else
  printf 'OCI Mirror CIDR: generated %s prefixes at %s\n' "$line_count" "$TARGET"
fi
