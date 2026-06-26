#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${CONFIG_FILE:-./data/config/config.yaml}"

clean_value() {
  local value="$1"
  value="${value%% #*}"
  value="${value%\"}"
  value="${value#\"}"
  value="${value%\'}"
  value="${value#\'}"
  printf '%s\n' "$value"
}

scalar_any() {
  local key="$1"
  local default="$2"
  local value
  value="$(sed -n -E "s/^[[:space:]]*${key}:[[:space:]]*//p" "$CONFIG_FILE" | head -n 1 || true)"
  if [[ -n "$value" ]]; then
    clean_value "$value"
  else
    printf '%s\n' "$default"
  fi
}

section_scalar() {
  local section="$1"
  local key="$2"
  local default="$3"
  local value
  value="$(awk -v section="$section" -v key="$key" '
    /^[[:space:]]*#/ { next }
    /^[^[:space:]][^:]*:/ {
      in_section = ($1 == section ":")
      next
    }
    in_section && $0 ~ "^[[:space:]]+" key ":[[:space:]]*" {
      sub("^[[:space:]]+" key ":[[:space:]]*", "")
      print
      exit
    }
  ' "$CONFIG_FILE" || true)"
  if [[ -n "$value" ]]; then
    clean_value "$value"
  else
    printf '%s\n' "$default"
  fi
}

first_prefix() {
  local family="$1"
  local default="$2"
  local value
  value="$(section_scalar prefixes "$family" "")"
  if [[ -z "$value" && "$family" == "v4" ]]; then
    value="$(awk '
      /^[[:space:]]*#/ { next }
      /^[^[:space:]][^:]*:/ {
        in_prefixes = ($1 == "ip_prefixes:")
        next
      }
      in_prefixes && /^[[:space:]]*-[[:space:]]*[0-9]+\./ {
        sub(/^[[:space:]]*-[[:space:]]*/, "")
        print
        exit
      }
    ' "$CONFIG_FILE" || true)"
  elif [[ -z "$value" ]]; then
    value="$(awk '
      /^[[:space:]]*#/ { next }
      /^[^[:space:]][^:]*:/ {
        in_prefixes = ($1 == "ip_prefixes:")
        next
      }
      in_prefixes && /^[[:space:]]*-[[:space:]]*[0-9A-Fa-f:]+\/[0-9]+/ && $0 !~ /\./ {
        sub(/^[[:space:]]*-[[:space:]]*/, "")
        print
        exit
      }
    ' "$CONFIG_FILE" || true)"
  fi
  if [[ -n "$value" ]]; then
    clean_value "$value"
  else
    printf '%s\n' "$default"
  fi
}

dns_global_lines() {
  local lines
  lines="$(awk '
    /^[[:space:]]*#/ { next }
    /^[^[:space:]][^:]*:/ {
      if (in_dns && $1 != "dns_config:" && $1 != "dns:") exit
      in_dns = ($1 == "dns_config:" || $1 == "dns:")
      in_nameservers = 0
      next
    }
    in_dns && /^[[:space:]]+nameservers:[[:space:]]*$/ {
      in_nameservers = 1
      next
    }
    in_nameservers && /^[[:space:]]+[a-zA-Z_]+:[[:space:]]*/ && $1 != "global:" {
      exit
    }
    in_nameservers && /^[[:space:]]*-[[:space:]]*/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "")
      sub(/[[:space:]]+#.*$/, "")
      gsub(/^["'\''"]|["'\''"]$/, "")
      print "      - " $0
    }
  ' "$CONFIG_FILE" || true)"
  if [[ -n "$lines" ]]; then
    printf '%s\n' "$lines"
  else
    printf '%s\n' "      - 223.5.5.5" "      - 1.1.1.1"
  fi
}

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "$CONFIG_FILE not found; skipped Headscale config migration"
  exit 0
fi

if ! grep -qE '^(acl_policy_path|dns_config:|ip_prefixes:|db_type:|db_path:|private_key_path:|node_update_check_interval:)' "$CONFIG_FILE"; then
  echo "Headscale config already uses the 0.27+ layout; skipped migration"
  exit 0
fi

backup="${CONFIG_FILE}.bak-$(date +%Y%m%d%H%M%S)"
cp "$CONFIG_FILE" "$backup"

prefix_v4="$(first_prefix v4 "100.64.0.0/10")"
prefix_v6="$(first_prefix v6 "fd7a:115c:a1e0::/48")"
db_path="$(scalar_any db_path "$(section_scalar sqlite path "/var/lib/headscale/db.sqlite")")"
policy_path="$(scalar_any acl_policy_path "$(section_scalar policy path "")")"
dns_override="$(scalar_any override_local_dns "false")"
dns_magic="$(scalar_any magic_dns "true")"
dns_base="$(scalar_any base_domain "example.com")"
dns_nameservers="$(dns_global_lines)"

tmp="${CONFIG_FILE}.tmp-$$"
awk '
  function is_top_level_key() {
    return $0 ~ /^[^[:space:]#][^:]*:/
  }

  skip_old_block && is_top_level_key() {
    skip_old_block = 0
  }

  !skip_old_block && $0 ~ /^(private_key_path|node_update_check_interval|db_type|db_path|acl_policy_path):/ {
    next
  }

  !skip_old_block && $0 ~ /^(ip_prefixes|dns_config):/ {
    skip_old_block = 1
    next
  }

  !skip_old_block {
    print
  }
' "$CONFIG_FILE" > "$tmp"
mv "$tmp" "$CONFIG_FILE"

append_prefixes() {
  grep -qE '^prefixes:' "$CONFIG_FILE" && return 0
  cat >> "$CONFIG_FILE" <<EOF

prefixes:
  v4: ${prefix_v4}
  v6: ${prefix_v6}
  allocation: sequential
EOF
}

append_database() {
  grep -qE '^database:' "$CONFIG_FILE" && return 0
  cat >> "$CONFIG_FILE" <<EOF

database:
  type: sqlite
  sqlite:
    path: ${db_path}
    write_ahead_log: true
EOF
}

append_policy() {
  grep -qE '^policy:' "$CONFIG_FILE" && return 0
  cat >> "$CONFIG_FILE" <<EOF

policy:
  mode: file
  path: "${policy_path}"
EOF
}

append_dns() {
  grep -qE '^dns:' "$CONFIG_FILE" && return 0
  cat >> "$CONFIG_FILE" <<EOF

dns:
  override_local_dns: ${dns_override}
  nameservers:
    global:
${dns_nameservers}
    split: {}
  search_domains: []
  extra_records: []
  magic_dns: ${dns_magic}
  base_domain: ${dns_base}
EOF
}

append_prefixes
append_database
append_policy
append_dns

echo "Migrated Headscale config for 0.27+ layout; backup: ${backup}"
