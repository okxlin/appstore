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

top_level_scalar() {
  local key="$1"
  local value
  value="$(sed -n -E "s/^${key}:[[:space:]]*//p" "$CONFIG_FILE" | head -n 1 || true)"
  clean_value "$value"
}

section_scalar() {
  local section="$1"
  local key="$2"
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
  clean_value "$value"
}

ensure_node_timeout() {
  local source_file="$1"
  local output_file="$2"
  local timeout="$3"

  if grep -qE '^node:[[:space:]]*($|#)' "$source_file"; then
    if awk '
      /^[^[:space:]#][^:]*:/ {
        in_node = ($1 == "node:")
        next
      }
      in_node && /^[[:space:]]+inactivity_timeout:[[:space:]]*/ { found = 1 }
      END { exit(found ? 0 : 1) }
    ' "$source_file"; then
      cp "$source_file" "$output_file"
      return 0
    fi

    if awk '
      /^[^[:space:]#][^:]*:/ {
        in_node = ($1 == "node:")
        next
      }
      in_node && /^  ephemeral:[[:space:]]*($|#)/ { found = 1 }
      END { exit(found ? 0 : 1) }
    ' "$source_file"; then
      awk -v timeout="$timeout" '
        /^[^[:space:]#][^:]*:/ { in_node = ($1 == "node:") }
        { print }
        in_node && /^  ephemeral:[[:space:]]*($|#)/ && !inserted {
          print "    inactivity_timeout: " timeout
          inserted = 1
        }
      ' "$source_file" > "$output_file"
      return 0
    fi

    awk -v timeout="$timeout" '
      function is_top_level(line) {
        return line ~ /^[^[:space:]#][^:]*:/
      }
      in_node && is_top_level($0) && !inserted {
        print "  ephemeral:"
        print "    inactivity_timeout: " timeout
        inserted = 1
        in_node = 0
      }
      { print }
      $0 ~ /^node:[[:space:]]*($|#)/ { in_node = 1 }
      END {
        if (in_node && !inserted) {
          print "  ephemeral:"
          print "    inactivity_timeout: " timeout
        }
      }
    ' "$source_file" > "$output_file"
    return 0
  fi

  cp "$source_file" "$output_file"
  cat >> "$output_file" <<EOF

node:
  expiry: 0
  ephemeral:
    inactivity_timeout: ${timeout}
EOF
}

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "$CONFIG_FILE not found; skipped Headscale 0.29 configuration migration"
  exit 0
fi

randomize_client_port="$(top_level_scalar randomize_client_port)"
ephemeral_timeout="$(top_level_scalar ephemeral_node_inactivity_timeout)"

if [[ -z "$randomize_client_port" && -z "$ephemeral_timeout" ]]; then
  echo "Headscale configuration already uses the 0.29 layout; skipped migration"
  exit 0
fi

policy_mode="$(section_scalar policy mode)"
policy_path="$(section_scalar policy path)"
policy_mode="${policy_mode:-file}"
config_dir="$(dirname "$CONFIG_FILE")"
policy_file="${POLICY_FILE:-${config_dir}/policy.hujson}"
set_default_policy=0

case "${randomize_client_port,,}" in
  true|yes|1)
    if [[ "${policy_mode,,}" != "file" ]]; then
      echo "Headscale 0.29 moves randomize_client_port into the policy. Add randomizeClientPort to the database policy before upgrading." >&2
      exit 1
    fi
    if [[ -n "$policy_path" ]]; then
      echo "Headscale 0.29 moves randomize_client_port into the policy. Add randomizeClientPort to ${policy_path} before upgrading, then remove randomize_client_port from config.yaml." >&2
      exit 1
    fi
    set_default_policy=1
    ;;
esac

backup="${CONFIG_FILE}.bak-$(date +%Y%m%d%H%M%S)"
if [[ -e "$backup" ]]; then
  backup="${backup}-$$"
fi
cp -p "$CONFIG_FILE" "$backup"

base_tmp="${CONFIG_FILE}.base-$$"
final_tmp="${CONFIG_FILE}.tmp-$$"
policy_tmp="${policy_file}.tmp-$$"
cleanup() {
  rm -f "$base_tmp" "$final_tmp" "$policy_tmp"
}
trap cleanup EXIT

awk -v set_default_policy="$set_default_policy" '
  /^[^[:space:]#][^:]*:/ { in_policy = ($1 == "policy:") }
  /^(randomize_client_port|ephemeral_node_inactivity_timeout):[[:space:]]*/ { next }
  set_default_policy && in_policy && /^[[:space:]]+path:[[:space:]]*/ {
    print "  path: /etc/headscale/policy.hujson"
    path_set = 1
    next
  }
  { print }
  END {
    if (set_default_policy && !path_set) {
      exit 42
    }
  }
' "$CONFIG_FILE" > "$base_tmp" || {
  echo "Could not migrate policy.path in $CONFIG_FILE; restored original configuration" >&2
  exit 1
}

if [[ -n "$ephemeral_timeout" ]]; then
  ensure_node_timeout "$base_tmp" "$final_tmp" "$ephemeral_timeout"
else
  cp "$base_tmp" "$final_tmp"
fi

if [[ "$set_default_policy" -eq 1 ]]; then
  expected_policy=$'{\n  "randomizeClientPort": true,\n}\n'
  if [[ -e "$policy_file" ]]; then
    if [[ "$(< "$policy_file")" != "${expected_policy%$'\n'}" ]]; then
      echo "$policy_file already exists; add randomizeClientPort to that policy manually before upgrading." >&2
      exit 1
    fi
  else
    printf '%s' "$expected_policy" > "$policy_tmp"
    chmod 600 "$policy_tmp"
    mv "$policy_tmp" "$policy_file"
  fi
fi

chmod --reference="$CONFIG_FILE" "$final_tmp"
mv "$final_tmp" "$CONFIG_FILE"
echo "Migrated Headscale configuration for 0.29; backup: ${backup}"
