#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

read_env_value() {
  local file="$1"
  local key="$2"
  local value
  value="$(sed -n "s/^${key}=//p" "$file" | tail -n 1)"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
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

set_env_value() {
  local key="$1"
  local value="$2"
  local temp_file
  temp_file="$(mktemp "${ENV_FILE}.kaneo-upgrade.XXXXXX")"
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

restore_credentials_from_env() {
  local candidate="$1"
  local current_container current_db current_user current_password current_auth
  local candidate_container candidate_db candidate_user
  local candidate_password candidate_auth

  [[ -f "$candidate" && ! -L "$candidate" ]] || return 1
  current_password="$(read_env_value "$ENV_FILE" POSTGRES_PASSWORD)"
  current_auth="$(read_env_value "$ENV_FILE" AUTH_SECRET)"
  current_container="$(read_env_value "$ENV_FILE" CONTAINER_NAME)"
  current_db="$(read_env_value "$ENV_FILE" POSTGRES_DB)"
  current_user="$(read_env_value "$ENV_FILE" POSTGRES_USER)"
  candidate_container="$(read_env_value "$candidate" CONTAINER_NAME)"
  candidate_db="$(read_env_value "$candidate" POSTGRES_DB)"
  candidate_user="$(read_env_value "$candidate" POSTGRES_USER)"
  [[ "$candidate_container" == "$current_container" &&
    "$candidate_db" == "$current_db" &&
    "$candidate_user" == "$current_user" ]] || return 1

  candidate_password="$(read_env_value "$candidate" POSTGRES_PASSWORD)"
  candidate_auth="$(read_env_value "$candidate" AUTH_SECRET)"
  [[ "$candidate_password" =~ ^[A-Za-z0-9]{32,128}$ ]] || return 1
  [[ "$candidate_auth" =~ ^[A-Fa-f0-9]{64,128}$ ]] || return 1
  if [[ "$current_password" == "" || "$current_password" == generate ]]; then
    set_env_value POSTGRES_PASSWORD "$candidate_password"
  fi
  if [[ "$current_auth" == "" || "$current_auth" == generate ]]; then
    set_env_value AUTH_SECRET "$candidate_auth"
  fi
  return 0
}

restore_credentials_from_backup() (
  local panel_root app_key install_name backup_dir archive archive_entry
  local temp_dir inner_archive env_entry latest_mtime archive_mtime

  panel_root="${ROOT_DIR%%/apps/*}"
  [[ "$panel_root" != "$ROOT_DIR" ]] || exit 1
  app_key="$(basename "$(dirname "$ROOT_DIR")")"
  install_name="$(basename "$ROOT_DIR")"
  [[ "$app_key" =~ ^[A-Za-z0-9._-]+$ && "$install_name" =~ ^[A-Za-z0-9._-]+$ ]] || exit 1
  backup_dir="$panel_root/backup/app/local${app_key}/${install_name}"
  [[ -d "$backup_dir" && ! -L "$backup_dir" ]] || exit 1

  archive=""
  latest_mtime=0
  while IFS= read -r -d '' candidate; do
    archive_mtime="$(stat -c '%Y' "$candidate")"
    if [[ -z "$archive" ]] || (( archive_mtime > latest_mtime )); then
      archive="$candidate"
      latest_mtime="$archive_mtime"
    fi
  done < <(find "$backup_dir" -maxdepth 1 -type f -name 'upgrade_backup_*.tar.gz' -print0)
  [[ -n "$archive" ]] || exit 1

  temp_dir="$(mktemp -d "$ROOT_DIR/.kaneo-upgrade-backup.XXXXXX")"
  trap 'rm -rf -- "$temp_dir"' EXIT
  inner_archive="$temp_dir/app.tar.gz"
  archive_entry="$(tar -tzf "$archive" | awk '$0 ~ /\/app\.tar\.gz$/ { print; exit }')"
  [[ -n "$archive_entry" ]] || exit 1
  tar -xOf "$archive" "$archive_entry" > "$inner_archive"
  env_entry="$install_name/.env"
  tar -tzf "$inner_archive" | grep -Fqx "$env_entry" || exit 1
  tar -xOf "$inner_archive" "$env_entry" > "$temp_dir/old.env"
  restore_credentials_from_env "$temp_dir/old.env"
)

restore_previous_credentials() {
  local current_password current_auth candidate
  local -a snapshots

  current_password="$(read_env_value "$ENV_FILE" POSTGRES_PASSWORD)"
  current_auth="$(read_env_value "$ENV_FILE" AUTH_SECRET)"
  if [[ "$current_password" != "" && "$current_password" != generate &&
    "$current_auth" != "" && "$current_auth" != generate ]]; then
    return 0
  fi

  shopt -s nullglob
  snapshots=(/tmp/1panel-app-upgrade-*/.env)
  shopt -u nullglob
  for candidate in "${snapshots[@]}"; do
    restore_credentials_from_env "$candidate" && return 0
  done
  restore_credentials_from_backup
}

[[ -f "$ENV_FILE" ]] || {
  printf '%s\n' "$ENV_FILE not found" >&2
  exit 1
}
if ! restore_previous_credentials; then
  data_raw="$(read_env_value "$ENV_FILE" APP_DATA_DIR)"
  data_dir="$(resolve_app_path APP_DATA_DIR "$data_raw")"
  if [[ -f "$data_dir/postgres/PG_VERSION" ]]; then
    printf '%s\n' 'Kaneo upgrade could not recover existing database credentials' >&2
    exit 1
  fi
fi
exec "$SCRIPT_DIR/init.sh"
