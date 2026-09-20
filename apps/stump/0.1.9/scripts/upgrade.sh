#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
TMP_FILE=""

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

cleanup() {
  if [[ -n "$TMP_FILE" && -e "$TMP_FILE" ]]; then
    unlink -- "$TMP_FILE"
  fi
}

trap cleanup EXIT HUP INT TERM

read_env_value() {
  local key="$1"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(awk -v key="$key" '
      $0 ~ "^[[:space:]]*" key "[[:space:]]*=" {
        line = $0
        sub("^[[:space:]]*" key "[[:space:]]*=[[:space:]]*", "", line)
        value = line
      }
      END { print value }
    ' "$ENV_FILE")"
  fi

  if [[ ${#value} -ge 2 && "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
    value="${value:1:${#value}-2}"
  elif [[ ${#value} -ge 2 && "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "$value"
}

configured_value() {
  local key="$1"
  local default_value="$2"
  local value
  value="${!key:-}"
  if [[ -z "$value" ]]; then
    value="$(read_env_value "$key")"
  fi
  printf '%s\n' "${value:-$default_value}"
}

resolve_app_path() {
  local key="$1"
  local raw="$2"
  local clean candidate resolved current part
  local -a parts=()
  case "$raw" in
    ""|/*|.|..|../*|*/../*|*/..) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  if [[ "$raw" =~ [[:cntrl:]] ]]; then
    echo "unsafe ${key} path" >&2
    return 1
  fi
  clean="${raw#./}"
  [[ -n "$clean" ]] || { echo "unsafe ${key} path" >&2; return 1; }
  command -v realpath >/dev/null 2>&1 || { echo "realpath is required" >&2; return 1; }
  candidate="$ROOT_DIR/$clean"
  resolved="$(realpath -m -- "$candidate")" || { echo "unsafe ${key} path" >&2; return 1; }
  case "$resolved" in
    "$ROOT_DIR"/*) ;;
    *) echo "unsafe ${key} path" >&2; return 1 ;;
  esac
  current="$ROOT_DIR"
  IFS='/' read -r -a parts <<< "$clean"
  for part in "${parts[@]}"; do
    [[ -z "$part" || "$part" == "." ]] && continue
    current="$current/$part"
    if [[ -L "$current" ]]; then
      echo "unsafe ${key} path" >&2
      return 1
    fi
  done
  printf '%s\n' "$resolved"
}

config_path="$(configured_value CONFIG_PATH "./data/config")"
[[ "$config_path" != *'$'* ]] || fail "unsafe CONFIG_PATH path"
[[ "$config_path" != *'`'* ]] || fail "unsafe CONFIG_PATH path"
[[ "$config_path" != *';'* ]] || fail "unsafe CONFIG_PATH path"
[[ "$config_path" != *'&'* ]] || fail "unsafe CONFIG_PATH path"
[[ "$config_path" != *'|'* ]] || fail "unsafe CONFIG_PATH path"
[[ "$config_path" != *'<'* ]] || fail "unsafe CONFIG_PATH path"
[[ "$config_path" != *'>'* ]] || fail "unsafe CONFIG_PATH path"
[[ "$config_path" != *'('* ]] || fail "unsafe CONFIG_PATH path"
[[ "$config_path" != *')'* ]] || fail "unsafe CONFIG_PATH path"
config_dir="$(resolve_app_path CONFIG_PATH "$config_path")"
config_file="$config_dir/Stump.toml"
[[ ! -L "$config_file" ]] || fail "Stump.toml must not be a symbolic link"
[[ ! -e "$config_file" ]] && exit 0
[[ -f "$config_file" ]] || fail "Stump.toml must be a regular file"

# Stump 0.1.9 replaced the old config loader. The generated 0.1.7 file has
# one field that no longer exists; removing only that obsolete field preserves
# the database and every user-configured setting.
if ! grep -Eq '^[[:space:]]*profile[[:space:]]*=' -- "$config_file"; then
  exit 0
fi

backup_file="${config_file}.pre-v0.1.9"
if [[ -e "$backup_file" || -L "$backup_file" ]]; then
  [[ ! -L "$backup_file" && -f "$backup_file" ]] || fail "migration backup is not a regular file"
  cmp -s -- "$backup_file" "$config_file" || fail "migration backup already exists with different contents"
else
  cp -p -- "$config_file" "$backup_file"
fi

TMP_FILE="$(mktemp "${config_file}.tmp.XXXXXX")"
awk '
  /^[[:space:]]*profile[[:space:]]*=/ { removed = 1; next }
  { print }
  END {
    if (!removed) exit 2
  }
' "$config_file" > "$TMP_FILE" || fail "failed to migrate Stump.toml"

grep -Eq '^[[:space:]]*profile[[:space:]]*=' -- "$TMP_FILE" && fail "obsolete profile setting remains"
chmod --reference="$config_file" "$TMP_FILE"
chown --reference="$config_file" "$TMP_FILE"
mv -f -- "$TMP_FILE" "$config_file"
TMP_FILE=""
