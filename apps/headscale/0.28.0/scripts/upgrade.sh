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

yaml_quote() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  printf '"%s"' "$value"
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
      in_global = 0
      next
    }
    in_dns && /^[[:space:]]+nameservers:[[:space:]]*(#.*)?$/ {
      in_nameservers = 1
      next
    }
    in_nameservers && /^[[:space:]]+[a-zA-Z_]+:[[:space:]]*/ && $1 != "global:" {
      exit
    }
    in_nameservers && $1 == "global:" {
      in_global = 1
      next
    }
    in_nameservers && in_global && /^[[:space:]]+[a-zA-Z_]+:[[:space:]]*/ {
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

dns_child_block() {
  local old_key="$1"
  local new_key="$2"
  local extra_indent="$3"
  local default="$4"
  local block
  block="$(awk -v old_key="$old_key" -v new_key="$new_key" -v extra_indent="$extra_indent" '
    /^[[:space:]]*#/ {
      if (found) {
        print extra_indent $0
      }
      next
    }
    /^[^[:space:]][^:]*:/ {
      if (found) {
        exit
      }
      in_dns = ($1 == "dns_config:" || $1 == "dns:")
      next
    }
    in_dns && !found && $0 ~ "^[[:space:]][[:space:]]" old_key ":[[:space:]]*" {
      found = 1
      sub("^[[:space:]][[:space:]]" old_key ":", "  " new_key ":")
      print extra_indent $0
      next
    }
    found {
      if ($0 ~ "^[[:space:]][[:space:]][A-Za-z_][A-Za-z0-9_]*:[[:space:]]*" && $0 !~ "^[[:space:]][[:space:]][[:space:]][[:space:]]") {
        exit
      }
      print extra_indent $0
    }
  ' "$CONFIG_FILE" || true)"
  if [[ -n "$block" ]]; then
    printf '%s\n' "$block"
  else
    printf '%s\n' "$default"
  fi
}

app_root_from_config() {
  local config_dir
  local data_dir
  config_dir="$(dirname "$CONFIG_FILE")"
  data_dir="$(dirname "$config_dir")"

  if [[ "$(basename "$config_dir")" == "config" && "$(basename "$data_dir")" == "data" ]]; then
    dirname "$data_dir"
  else
    printf '.\n'
  fi
}

sqlite_host_path() {
  local container_path="$1"
  case "$container_path" in
    /var/lib/headscale/*)
      printf '%s/data/data/%s\n' "$APP_ROOT" "${container_path#/var/lib/headscale/}"
      ;;
    /*)
      printf '%s\n' "$container_path"
      ;;
    *)
      printf '%s/%s\n' "$APP_ROOT" "$container_path"
      ;;
  esac
}

backup_sqlite_database() {
  local db_type="$1"
  local db_path="$2"
  local normalized_type="${db_type,,}"

  if [[ "$normalized_type" == "postgres" || "$normalized_type" == "postgresql" ]]; then
    return 0
  fi

  local host_path
  host_path="$(sqlite_host_path "$db_path")"
  if [[ ! -f "$host_path" ]]; then
    echo "SQLite database ${host_path} not found; skipped database backup"
    return 0
  fi

  local backup_dir
  backup_dir="$(dirname "$host_path")/backup-$(date +%Y%m%d%H%M%S)"
  mkdir -p "$backup_dir"

  local copied=0
  local candidate
  for candidate in "$host_path" "$host_path-wal" "$host_path-shm"; do
    if [[ -f "$candidate" ]]; then
      cp "$candidate" "$backup_dir/"
      copied=1
    fi
  done

  if [[ "$copied" -eq 1 ]]; then
    echo "Backed up Headscale SQLite database files to ${backup_dir}"
  else
    rmdir "$backup_dir" 2>/dev/null || true
  fi
}

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "$CONFIG_FILE not found; skipped Headscale config migration"
  exit 0
fi

if ! grep -qE '^(acl_policy_path|dns_config:|ip_prefixes:|db_type:|db_path:|db_host:|db_port:|db_name:|db_user:|db_pass:|db_ssl:|private_key_path:|node_update_check_interval:)' "$CONFIG_FILE"; then
  echo "Headscale config already uses the 0.27+ layout; skipped migration"
  exit 0
fi

backup="${CONFIG_FILE}.bak-$(date +%Y%m%d%H%M%S)"
cp "$CONFIG_FILE" "$backup"
APP_ROOT="$(app_root_from_config)"

prefix_v4="$(first_prefix v4 "100.64.0.0/10")"
prefix_v6="$(first_prefix v6 "fd7a:115c:a1e0::/48")"
db_type="$(scalar_any db_type "$(section_scalar database type "sqlite")")"
db_path="$(scalar_any db_path "$(section_scalar sqlite path "/var/lib/headscale/db.sqlite")")"
db_host="$(scalar_any db_host "localhost")"
db_port="$(scalar_any db_port "5432")"
db_name="$(scalar_any db_name "headscale")"
db_user="$(scalar_any db_user "foo")"
db_pass="$(scalar_any db_pass "bar")"
db_ssl="$(scalar_any db_ssl "false")"
policy_path="$(scalar_any acl_policy_path "$(section_scalar policy path "")")"
dns_override="$(scalar_any override_local_dns "false")"
dns_magic="$(scalar_any magic_dns "true")"
dns_base="$(scalar_any base_domain "example.com")"
dns_nameservers="$(dns_global_lines)"
dns_split="$(dns_child_block restricted_nameservers split "  " "    split: {}")"
dns_search_domains="$(dns_child_block domains search_domains "" "  search_domains: []")"
dns_extra_records="$(dns_child_block extra_records extra_records "" "  extra_records: []")"

backup_sqlite_database "$db_type" "$db_path"

tmp="${CONFIG_FILE}.tmp-$$"
awk '
  function is_top_level_key() {
    return $0 ~ /^[^[:space:]#][^:]*:/
  }

  skip_old_block && is_top_level_key() {
    skip_old_block = 0
  }

  !skip_old_block && $0 ~ /^(private_key_path|node_update_check_interval|db_type|db_path|db_host|db_port|db_name|db_user|db_pass|db_ssl|acl_policy_path):/ {
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
  local normalized_type="${db_type,,}"
  if [[ "$normalized_type" == "postgres" || "$normalized_type" == "postgresql" ]]; then
    cat >> "$CONFIG_FILE" <<EOF

database:
  type: postgres
  postgres:
    host: $(yaml_quote "$db_host")
    port: ${db_port}
    name: $(yaml_quote "$db_name")
    user: $(yaml_quote "$db_user")
    pass: $(yaml_quote "$db_pass")
    ssl: ${db_ssl}
EOF
  else
    cat >> "$CONFIG_FILE" <<EOF

database:
  type: sqlite
  sqlite:
    path: $(yaml_quote "$db_path")
    write_ahead_log: true
EOF
  fi
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
${dns_split}
${dns_search_domains}
${dns_extra_records}
  magic_dns: ${dns_magic}
  base_domain: ${dns_base}
EOF
}

append_prefixes
append_database
append_policy
append_dns

echo "Migrated Headscale config for 0.27+ layout; backup: ${backup}"
