#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${ROOT_DIR_OVERRIDE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)}"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1"
  local value
  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ROOT_DIR}/.moltis-env.tmp.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { written = 0 }
    $0 ~ "^" key "=" {
      if (!written) {
        print key "=" value
        written = 1
      }
      next
    }
    { print }
    END { if (!written) print key "=" value }
  ' "$ENV_FILE" > "$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

validate_ipv4() {
  local value="$1"
  local octet
  local -a octets
  [[ "$value" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || fail "PANEL_APP_BIND_ADDRESS must be an IPv4 address"
  IFS=. read -r -a octets <<< "$value"
  for octet in "${octets[@]}"; do
    ((10#$octet <= 255)) || fail "PANEL_APP_BIND_ADDRESS contains an invalid IPv4 octet"
  done
}

validate_port() {
  local key="$1"
  local value="$2"
  [[ "$value" =~ ^[0-9]+$ ]] || fail "$key must be an integer"
  ((10#$value >= 1 && 10#$value <= 65535)) || fail "$key must be between 1 and 65535"
}

generate_password() {
  local material
  material="$(openssl rand -base64 96 | tr -dc A-Za-z0-9)"
  [[ ${#material} -ge 40 ]] || fail "unable to generate sufficient random material"
  printf '%s\n' "${material:0:40}"
}

config_has_required_policy() {
  local config="$1"
  awk '
    BEGIN { section = "" }
    {
      line = $0
      sub(/\r$/, "", line)
      sub(/^[[:space:]]+/, "", line)
      sub(/[[:space:]]+$/, "", line)
      if (line ~ /^\[[^][]+\]$/) {
        section = line
        gsub(/[[:space:]]/, "", section)
        next
      }
      if (line == "" || line ~ /^#/) next

      compact = line
      gsub(/[[:space:]]/, "", compact)
      if (compact ~ /^(server\.terminal_enabled|tools\.policy\.deny|tools\.exec\.sandbox\.backend|tools\.browser\.enabled)=/) invalid = 1

      if (section == "[server]" && compact ~ /^terminal_enabled=/) {
        server_count++
        if (compact != "terminal_enabled=false") invalid = 1
      } else if (section == "[tools.policy]" && compact ~ /^deny=/) {
        policy_count++
        if (compact != "deny=[\"mcp_add\",\"mcp_remove\",\"mcp_restart\",\"nodes_select\"]") invalid = 1
      } else if (section == "[tools.exec.sandbox]" && compact ~ /^backend=/) {
        sandbox_count++
        if (compact != "backend=\"wasm\"") invalid = 1
      } else if (section == "[tools.browser]" && compact ~ /^enabled=/) {
        browser_count++
        if (compact != "enabled=false") invalid = 1
      }
    }
    END {
      exit !(invalid == 0 && server_count == 1 && policy_count == 1 && sandbox_count == 1 && browser_count == 1)
    }
  ' "$config"
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"
[[ "$(id -u)" -eq 0 ]] || fail "Moltis init must run as root"
command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate credentials"

validate_ipv4 "$(read_env_value PANEL_APP_BIND_ADDRESS)"
http_port="$(read_env_value PANEL_APP_PORT_HTTP)"
oauth_port="$(read_env_value PANEL_APP_PORT_OAUTH)"
validate_port PANEL_APP_PORT_HTTP "$http_port"
validate_port PANEL_APP_PORT_OAUTH "$oauth_port"
[[ "$http_port" != "$oauth_port" ]] || fail "web and OAuth callback ports must differ"

password="$(read_env_value MOLTIS_PASSWORD)"
if [[ -z "$password" || "$password" == generate ]]; then
  password="$(generate_password)"
fi
[[ "$password" =~ ^[A-Za-z0-9._~!@%+=-]{16,128}$ ]] ||
  fail "MOLTIS_PASSWORD must contain 16 to 128 safe characters"

data_raw="$(read_env_value DATA_PATH)"
[[ -n "$data_raw" && "$data_raw" != /* ]] || fail "DATA_PATH must be a non-empty relative path"
case "$data_raw" in
  *$'\n'* | *$'\r'* | *\\* | *:* | *'$'* | *'#'* | *'"'* | *"'"*)
    fail "DATA_PATH contains unsupported characters"
    ;;
esac

relative_data="${data_raw#./}"
[[ -n "$relative_data" ]] || fail "DATA_PATH must not resolve to the version root"
current="$ROOT_DIR"
IFS=/ read -r -a components <<< "$relative_data"
for component in "${components[@]}"; do
  [[ -n "$component" && "$component" != . && "$component" != .. ]] || fail "DATA_PATH contains traversal"
  current="$current/$component"
  [[ ! -L "$current" ]] || fail "DATA_PATH must not contain symbolic-link components"
done

data_root="$(realpath -m -- "$ROOT_DIR/$relative_data")"
case "$data_root" in
  "$ROOT_DIR"/*) ;;
  *) fail "DATA_PATH must stay inside the application version directory" ;;
esac

config_dir="$data_root/config"
runtime_dir="$data_root/data"
install -d -m 0750 -- "$data_root" "$config_dir" "$runtime_dir"
resolved_root="$(realpath -e -- "$data_root")"
case "$resolved_root" in
  "$ROOT_DIR"/*) ;;
  *) fail "DATA_PATH resolves outside the application version directory" ;;
esac

config_file="$config_dir/moltis.toml"
[[ ! -L "$config_file" ]] || fail "moltis.toml must not be a symbolic link"
if [[ ! -e "$config_file" ]]; then
  temp_config="$(mktemp "$config_dir/.moltis.toml.tmp.XXXXXX")"
  cat > "$temp_config" <<'EOF'
[server]
terminal_enabled = false

[tools.policy]
deny = ["mcp_add", "mcp_remove", "mcp_restart", "nodes_select"]

[tools.exec]
host = "local"

[tools.exec.sandbox]
backend = "wasm"

[tools.browser]
enabled = false
EOF
  chmod 0640 "$temp_config"
  chown 1000:1001 "$temp_config"
  mv -- "$temp_config" "$config_file"
fi
[[ -f "$config_file" ]] || fail "moltis.toml must be a regular file"
config_has_required_policy "$config_file" || fail "moltis.toml no longer enforces the required 1Panel security policy"

chown -R --no-dereference 1000:1001 -- "$resolved_root"
chmod 0750 "$resolved_root" "$config_dir" "$runtime_dir"
chmod 0640 "$config_file"
set_env_value MOLTIS_PASSWORD "$password"
chmod 0600 "$ENV_FILE"
