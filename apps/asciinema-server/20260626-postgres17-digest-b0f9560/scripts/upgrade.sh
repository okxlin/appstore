#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local file="$1"
  local key="$2"
  local value
  [[ -f "$file" && ! -L "$file" ]] || return 1
  value="$(awk -v key="$key" 'index($0, key "=") == 1 { value = substr($0, length(key) + 2) } END { print value }' "$file")"
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
  temp_file="$(mktemp "${ENV_FILE}.asciinema-upgrade.XXXXXX")"
  awk -v key="$key" -v value="$value" '
    BEGIN { written = 0; prefix = key "=" }
    index($0, prefix) == 1 {
      if (!written) {
        print prefix value
        written = 1
      }
      next
    }
    { print }
    END { if (!written) print prefix value }
  ' "$ENV_FILE" > "$temp_file"
  chmod 600 "$temp_file"
  mv -f -- "$temp_file" "$ENV_FILE"
}

credentials_need_recovery() {
  local key value
  for key in ASCIINEMA_SECRET_KEY_BASE ASCIINEMA_POSTGRES_PASSWORD; do
    value="$(read_env_value "$ENV_FILE" "$key")"
    [[ -z "$value" || "$value" == generate ]] && return 0
  done
  return 1
}

restore_credentials_from_env() {
  local candidate="$1"
  local current_container previous_container key current_value previous_value
  local needs_recovery=0

  [[ -f "$candidate" && ! -L "$candidate" ]] || return 1
  current_container="$(read_env_value "$ENV_FILE" CONTAINER_NAME)"
  previous_container="$(read_env_value "$candidate" CONTAINER_NAME)"
  [[ -n "$current_container" && "$previous_container" == "$current_container" ]] || return 1

  for key in ASCIINEMA_SECRET_KEY_BASE ASCIINEMA_POSTGRES_PASSWORD; do
    current_value="$(read_env_value "$ENV_FILE" "$key")"
    [[ -n "$current_value" && "$current_value" != generate ]] && continue
    previous_value="$(read_env_value "$candidate" "$key")"
    if [[ "$key" == ASCIINEMA_SECRET_KEY_BASE ]]; then
      [[ "$previous_value" =~ ^[A-Za-z0-9]{64,128}$ ]] || return 1
    else
      [[ "$previous_value" =~ ^[A-Za-z0-9]{16,128}$ ]] || return 1
    fi
    set_env_value "$key" "$previous_value"
    needs_recovery=1
  done

  (( needs_recovery == 1 )) || ! credentials_need_recovery
}

restore_credentials_from_backup() (
  local panel_root app_key install_name backup_dir archive archive_entry
  local latest_mtime=0 archive_mtime temp_dir old_env

  panel_root="${ROOT_DIR%%/apps/*}"
  [[ "$panel_root" != "$ROOT_DIR" ]] || exit 1
  app_key="$(basename "$(dirname "$ROOT_DIR")")"
  install_name="$(basename "$ROOT_DIR")"
  [[ "$app_key" =~ ^[A-Za-z0-9._-]+$ && "$install_name" =~ ^[A-Za-z0-9._-]+$ ]] || exit 1
  backup_dir="$panel_root/backup/app/local${app_key}/${install_name}"
  [[ -d "$backup_dir" && ! -L "$backup_dir" ]] || exit 1

  archive=""
  while IFS= read -r -d '' candidate; do
    archive_mtime="$(stat -c '%Y' "$candidate")"
    if [[ -z "$archive" ]] || (( archive_mtime > latest_mtime )); then
      archive="$candidate"
      latest_mtime="$archive_mtime"
    fi
  done < <(find "$backup_dir" -maxdepth 1 -type f -name 'upgrade_backup_*.tar.gz' -print0)
  [[ -n "$archive" ]] || exit 1

  archive_entry="$(tar -tzf "$archive" | awk '$0 ~ /(^|\/)app\.tar\.gz$/ { print; exit }')"
  [[ -n "$archive_entry" ]] || exit 1
  if ! tar -xOf "$archive" -- "$archive_entry" | tar -tzf - | grep -Fqx "$install_name/.env"; then
    exit 1
  fi

  temp_dir="$(mktemp -d "$ROOT_DIR/.asciinema-upgrade-backup.XXXXXX")"
  trap 'rm -rf -- "$temp_dir"' EXIT
  old_env="$temp_dir/old.env"
  tar -xOf "$archive" -- "$archive_entry" | tar -xOzf - -- "$install_name/.env" > "$old_env"
  chmod 600 "$old_env"
  restore_credentials_from_env "$old_env"
)

[[ -f "$ENV_FILE" && ! -L "$ENV_FILE" ]] || fail "$ENV_FILE not found or is a symbolic link"

if credentials_need_recovery; then
  if ! restore_credentials_from_backup && credentials_need_recovery; then
    fail "Could not recover generated Asciinema credentials from the 1Panel upgrade backup; refusing to continue with newly generated credentials"
  fi
fi

exec "$SCRIPT_DIR/init.sh"
