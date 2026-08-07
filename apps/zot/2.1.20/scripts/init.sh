#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

strip_matching_quotes() {
  local value="$1"

  if [[ ${#value} -ge 2 ]]; then
    if [[ "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
      value="${value:1:${#value}-2}"
    elif [[ "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
      value="${value:1:${#value}-2}"
    fi
  fi
  printf '%s\n' "$value"
}

read_env_value() {
  local key="$1"
  local value=""

  value="$(sed -n "s/^${key}=//p" "$ENV_FILE" | tail -n 1)"
  strip_matching_quotes "$value"
}

read_effective_value() {
  local key="$1"

  if [[ -v "$key" ]]; then
    strip_matching_quotes "${!key}"
  else
    read_env_value "$key"
  fi
}

reject_symlink_components() {
  local path="$1"
  local current=""
  local component
  local -a components

  IFS='/' read -r -a components <<< "${path#/}"
  for component in "${components[@]}"; do
    [[ -n "$component" ]] || continue
    current="${current}/${component}"
    [[ ! -L "$current" ]] || fail "APP_DATA_DIR must not contain symbolic-link components"
  done
}

validate_ipv4() {
  local value="$1"
  local octet
  local -a octets

  [[ "$value" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || return 1
  IFS='.' read -r -a octets <<< "$value"
  for octet in "${octets[@]}"; do
    ((10#$octet <= 255)) || return 1
  done
}

[[ -f "$ENV_FILE" ]] || fail "$ENV_FILE not found"
[[ ! -L "$ENV_FILE" ]] || fail "$ENV_FILE must not be a symbolic link"
chmod 0600 -- "$ENV_FILE"

bind_address="$(read_effective_value PANEL_APP_BIND_ADDRESS)"
validate_ipv4 "$bind_address" || fail "PANEL_APP_BIND_ADDRESS must be a valid IPv4 address"

port="$(read_effective_value PANEL_APP_PORT_HTTP)"
[[ "$port" =~ ^[0-9]+$ ]] || fail "PANEL_APP_PORT_HTTP must be numeric"
((10#$port >= 1 && 10#$port <= 65535)) || fail "PANEL_APP_PORT_HTTP must be between 1 and 65535"

username="$(read_effective_value ZOT_USERNAME)"
[[ "$username" =~ ^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$ ]] || fail "ZOT_USERNAME must contain 1-64 safe characters"

password="$(read_effective_value ZOT_PASSWORD)"
[[ ${#password} -ge 12 && ${#password} -le 128 ]] || fail "ZOT_PASSWORD must contain 12-128 characters"
[[ ! "$password" =~ [[:cntrl:]] ]] || fail "ZOT_PASSWORD must not contain control characters"

timezone="$(read_effective_value TZ)"
[[ "$timezone" =~ ^[A-Za-z0-9_+/-]+$ ]] || fail "TZ is invalid"

data_raw="$(read_effective_value APP_DATA_DIR)"
[[ -n "$data_raw" ]] || fail "APP_DATA_DIR must not be empty"
[[ ! "$data_raw" =~ [[:cntrl:]\\\$\`\"\'] ]] || fail "APP_DATA_DIR contains unsupported characters"

if [[ "$data_raw" == /* ]]; then
  data_candidate="$data_raw"
  data_scope=absolute
else
  data_candidate="${ROOT_DIR}/${data_raw#./}"
  data_scope=application
fi

reject_symlink_components "$data_candidate"
data_dir="$(realpath -m -- "$data_candidate")"
case "$data_dir" in
  / | /bin | /boot | /dev | /etc | /home | /lib | /lib64 | /media | /mnt | /opt | /proc | /root | /run | /sbin | /srv | /sys | /tmp | /usr | /var | /var/lib | /workspace)
    fail "APP_DATA_DIR must be a dedicated subdirectory"
    ;;
esac
if [[ "$data_scope" == application ]]; then
  case "$data_dir" in
    "${ROOT_DIR}"/*) ;;
    *) fail "Relative APP_DATA_DIR must stay inside the application version directory" ;;
  esac
fi
[[ ! -e "$data_dir" || -d "$data_dir" ]] || fail "APP_DATA_DIR must be a directory"
[[ ! -L "$data_dir" ]] || fail "APP_DATA_DIR must not be a symbolic link"

data_existed=false
[[ -d "$data_dir" ]] && data_existed=true
install -d -m 0750 -- "$data_dir"
resolved_data_dir="$(realpath -e -- "$data_dir")"
[[ "$resolved_data_dir" == "$data_dir" ]] || fail "APP_DATA_DIR changed while it was being prepared"
if [[ "$data_scope" == application || "$data_existed" == false ]]; then
  chmod 0750 -- "$data_dir"
fi

command -v openssl >/dev/null 2>&1 || fail "openssl is required to generate the Zot password hash"
password_salt="$(openssl rand -hex 8)"
[[ "$password_salt" =~ ^[0-9a-f]{16}$ ]] || fail "failed to generate a password salt"
password_hash="$(printf '%s\n' "$password" | openssl passwd -6 -stdin -salt "rounds=200000\$${password_salt}")"
[[ "$password_hash" == '$6$rounds=200000$'* ]] || fail "failed to generate a hardened SHA-512 password hash"

config_dir="${ROOT_DIR}/config"
[[ ! -L "$config_dir" ]] || fail "Zot config directory must not be a symbolic link"
[[ ! -e "$config_dir" || -d "$config_dir" ]] || fail "Zot config path must be a directory"
install -d -m 0700 -- "$config_dir"

umask 077
htpasswd_temp="$(mktemp "${config_dir}/.htpasswd.tmp.XXXXXX")"
config_temp="$(mktemp "${config_dir}/.config.json.tmp.XXXXXX")"
cleanup_temps() {
  rm -f -- "$htpasswd_temp" "$config_temp"
}
trap cleanup_temps EXIT

printf '%s:%s\n' "$username" "$password_hash" >"$htpasswd_temp"
chmod 0600 -- "$htpasswd_temp"

cat >"$config_temp" <<EOF
{
  "distSpecVersion": "1.1.1",
  "storage": {
    "rootDirectory": "/var/lib/registry",
    "dedupe": true,
    "gc": true,
    "gcDelay": "1h",
    "gcInterval": "24h"
  },
  "http": {
    "address": "0.0.0.0",
    "port": "5000",
    "realm": "zot",
    "compat": ["docker2s2"],
    "auth": {
      "htpasswd": {
        "path": "/etc/zot/htpasswd"
      },
      "failDelay": 3
    },
    "accessControl": {
      "repositories": {
        "**": {
          "defaultPolicy": []
        }
      },
      "adminPolicy": {
        "users": ["${username}"],
        "actions": ["read", "create", "update", "delete"]
      }
    }
  },
  "log": {
    "level": "info"
  }
}
EOF
chmod 0600 -- "$config_temp"

mv -f -- "$htpasswd_temp" "${config_dir}/htpasswd"
mv -f -- "$config_temp" "${config_dir}/config.json"
trap - EXIT
printf '%s\n' "Zot configuration prepared."
