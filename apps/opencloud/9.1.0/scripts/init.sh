#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

ensure_no_symlink_components() {
  local path="$1"
  local current="/"
  local part
  local -a components

  [[ "$path" == /* ]] || fail "Path must be absolute: $path"
  IFS='/' read -r -a components <<< "$path"
  for part in "${components[@]}"; do
    case "$part" in
      "" | .) continue ;;
      ..)
        if [[ "$current" == /*/* ]]; then
          current="${current%/*}"
        else
          current="/"
        fi
        ;;
      *)
        if [[ "$current" == / ]]; then
          current="/$part"
        else
          current="$current/$part"
        fi
        ;;
    esac
    [[ ! -L "$current" ]] || fail "Data path must not contain a symbolic link: $current"
  done
}

read_env_value() {
  local key="$1"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi
  if [[ ${#value} -ge 2 && "${value:0:1}" == '"' && "${value: -1}" == '"' ]]; then
    value="${value:1:${#value}-2}"
  elif [[ ${#value} -ge 2 && "${value:0:1}" == "'" && "${value: -1}" == "'" ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "$value"
}

if [[ ${APP_DATA_DIR+x} ]]; then
  APP_DATA_DIR_RAW="$APP_DATA_DIR"
else
  APP_DATA_DIR_RAW="$(read_env_value APP_DATA_DIR)"
fi
APP_DATA_DIR_RAW="${APP_DATA_DIR_RAW:-./data}"

if [[ ${OC_DOMAIN+x} ]]; then
  OC_DOMAIN_RAW="$OC_DOMAIN"
else
  OC_DOMAIN_RAW="$(read_env_value OC_DOMAIN)"
fi

[[ -n "$APP_DATA_DIR_RAW" ]] || fail "APP_DATA_DIR must not be empty"
case "$APP_DATA_DIR_RAW" in
  *$'\n'* | *$'\r'* | *'$'* | *'#'*) fail "APP_DATA_DIR contains unsupported dotenv characters" ;;
esac

case "$APP_DATA_DIR_RAW" in
  /*)
    ensure_no_symlink_components "$APP_DATA_DIR_RAW"
    APP_DATA_DIR_ABS="$(realpath -m -- "$APP_DATA_DIR_RAW")"
    ;;
  *)
    ensure_no_symlink_components "${ROOT_DIR}/${APP_DATA_DIR_RAW#./}"
    APP_DATA_DIR_ABS="$(realpath -m -- "${ROOT_DIR}/${APP_DATA_DIR_RAW#./}")"
    case "$APP_DATA_DIR_ABS" in
      "$ROOT_DIR" | "$ROOT_DIR"/*) ;;
      *) fail "Relative APP_DATA_DIR must stay inside the application directory" ;;
    esac
    ;;
esac

[[ "$APP_DATA_DIR_ABS" != / ]] || fail "APP_DATA_DIR must not be the filesystem root"
[[ ! -L "$APP_DATA_DIR_ABS" ]] || fail "APP_DATA_DIR must not be a symbolic link"
if [[ -e "$APP_DATA_DIR_ABS" && ! -d "$APP_DATA_DIR_ABS" ]]; then
  fail "APP_DATA_DIR must be a directory"
fi

opencloud_paths=(
  "$APP_DATA_DIR_ABS/config"
  "$APP_DATA_DIR_ABS/storage"
  "$APP_DATA_DIR_ABS/apps"
)
traefik_paths=(
  "$APP_DATA_DIR_ABS/traefik/dynamic"
  "$APP_DATA_DIR_ABS/traefik/certs"
)

for path in "${opencloud_paths[@]}" "${traefik_paths[@]}"; do
  ensure_no_symlink_components "$path"
done

mkdir -p -- "${opencloud_paths[@]}" "${traefik_paths[@]}"
for path in "${opencloud_paths[@]}"; do
  chown 1000:1000 -- "$path" 2>/dev/null || true
done

[[ "$OC_DOMAIN_RAW" =~ ^[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?(\.[A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?)*$ ]] || fail "OC_DOMAIN must be a hostname without a scheme, port, or path"
[[ ${#OC_DOMAIN_RAW} -le 253 ]] || fail "OC_DOMAIN is too long"

route_template="$ROOT_DIR/config/traefik/opencloud.yml"
route_file="$APP_DATA_DIR_ABS/traefik/dynamic/1panel-opencloud-route.yml"
[[ -f "$route_template" && ! -L "$route_template" ]] || fail "OpenCloud Traefik route template is missing or invalid"
[[ ! -L "$route_file" ]] || fail "OpenCloud Traefik route must not be a symbolic link: $route_file"
if [[ -e "$route_file" && ! -f "$route_file" ]]; then
  fail "OpenCloud Traefik route must be a regular file: $route_file"
fi

if [[ ! -e "$route_file" ]]; then
  route_tmp="$(mktemp "${route_file}.tmp.XXXXXX")"
  if ! sed "s/@OC_DOMAIN@/${OC_DOMAIN_RAW}/g" "$route_template" > "$route_tmp"; then
    rm -f -- "$route_tmp"
    fail "Could not create OpenCloud Traefik route"
  fi
  chmod 0644 -- "$route_tmp"
  if ! ln -- "$route_tmp" "$route_file" 2>/dev/null; then
    if [[ ! -f "$route_file" || -L "$route_file" ]]; then
      rm -f -- "$route_tmp"
      fail "Could not create OpenCloud Traefik route"
    fi
  fi
  rm -f -- "$route_tmp"
fi
