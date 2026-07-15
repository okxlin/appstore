#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
MATOMO_IMAGE="matomo:5.12.0-fpm-alpine"

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

  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f 2- || true)"
  fi
  strip_matching_quotes "$value"
}

DATA_PATH_RAW="${DATA_PATH:-$(read_env_value DATA_PATH)}"
DATA_PATH_RAW="$(strip_matching_quotes "${DATA_PATH_RAW:-./data}")"

[[ -n "$DATA_PATH_RAW" ]] || fail "DATA_PATH must not be empty"
case "$DATA_PATH_RAW" in
  *$'\n'* | *$'\r'* | *:*) fail "DATA_PATH contains unsupported characters" ;;
esac

case "$DATA_PATH_RAW" in
  /*)
    DATA_PATH_ABS="$(realpath -m -- "$DATA_PATH_RAW")"
    ;;
  *)
    DATA_PATH_ABS="$(realpath -m -- "${ROOT_DIR}/${DATA_PATH_RAW#./}")"
    case "$DATA_PATH_ABS" in
      "$ROOT_DIR" | "$ROOT_DIR"/*) ;;
      *) fail "Relative DATA_PATH must stay inside the application directory" ;;
    esac
    ;;
esac

[[ "$DATA_PATH_ABS" != "/" ]] || fail "DATA_PATH must not be the filesystem root"
WEB_PATH="${DATA_PATH_ABS}/web"
[[ ! -L "$WEB_PATH" ]] || fail "$WEB_PATH must not be a symbolic link"
if [[ -e "$WEB_PATH" && ! -d "$WEB_PATH" ]]; then
  fail "$WEB_PATH must be a directory"
fi
mkdir -p -- "$WEB_PATH"

command -v docker >/dev/null 2>&1 || fail "docker CLI not found"
docker image inspect "$MATOMO_IMAGE" >/dev/null 2>&1 || fail "$MATOMO_IMAGE is not available locally"

docker run --rm \
  --network none \
  --read-only \
  --security-opt no-new-privileges:true \
  --entrypoint sh \
  --volume "${WEB_PATH}:/var/www/html" \
  "$MATOMO_IMAGE" \
  -c '
set -eu

source_dir=/usr/src/matomo
target_dir=/var/www/html
[ -f "$source_dir/matomo.php" ] || {
  echo "Matomo source files are missing from the target image" >&2
  exit 1
}
if find "$target_dir" -type l -print -quit | grep -q .; then
  echo "Matomo data directory must not contain symbolic links" >&2
  exit 1
fi

for source_entry in "$source_dir"/* "$source_dir"/.[!.]* "$source_dir"/..?*; do
  [ -e "$source_entry" ] || continue
  name="${source_entry##*/}"
  case "$name" in
    config | misc | plugins) continue ;;
  esac
  rm -rf -- "$target_dir/$name"
done

for subtree in config misc plugins; do
  for source_entry in "$source_dir/$subtree"/* "$source_dir/$subtree"/.[!.]* "$source_dir/$subtree"/..?*; do
    [ -e "$source_entry" ] || continue
    name="${source_entry##*/}"
    if [ "$subtree" = "misc" ] && [ "$name" = "user" ]; then
      continue
    fi
    rm -rf -- "$target_dir/$subtree/$name"
  done
done

tar cf - --one-file-system -C "$source_dir" . | tar xf - -C "$target_dir"
chown -R www-data:www-data "$target_dir"
'

printf 'Matomo application files updated from %s\n' "$MATOMO_IMAGE"
