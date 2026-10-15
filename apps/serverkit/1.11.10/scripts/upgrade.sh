#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd -P)"
DATA_DIR="$ROOT_DIR/data"
COMPOSE_FILE="$ROOT_DIR/docker-compose.yml"
LEGACY_VOLUME="serverkit-data"
MIGRATION_IMAGE="jhd3197/serverkit:1.11.4"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

has_data_files() {
  local entry
  for entry in "$DATA_DIR"/* "$DATA_DIR"/.[!.]* "$DATA_DIR"/..?*; do
    if [[ -e "$entry" || -L "$entry" ]]; then
      return 0
    fi
  done
  return 1
}

bash "$SCRIPT_DIR/init.sh"

if ! grep -Fq 'serverkit-data:/app/instance' "$COMPOSE_FILE"; then
  exit 0
fi

if [[ -f "$DATA_DIR/serverkit.db" ]]; then
  exit 0
fi

if has_data_files; then
  fail "ServerKit data directory is non-empty but serverkit.db is missing; refusing legacy-volume migration"
fi

command -v docker >/dev/null 2>&1 || fail "docker is required for legacy ServerKit volume migration"
if ! docker volume inspect "$LEGACY_VOLUME" >/dev/null 2>&1; then
  exit 0
fi
docker image inspect "$MIGRATION_IMAGE" >/dev/null 2>&1 || fail "migration image is unavailable: $MIGRATION_IMAGE"

docker run --rm --network none --user 0 --entrypoint /bin/sh \
  --volume "$LEGACY_VOLUME:/legacy:ro" \
  --volume "$DATA_DIR:/target:rw" \
  "$MIGRATION_IMAGE" \
  -c '
set -eu
stage=/target/.serverkit-data-migration
[ ! -e "$stage" ] && [ ! -L "$stage" ] || { echo "migration staging path already exists" >&2; exit 1; }
mkdir "$stage"
cleanup() {
  rm -rf -- "$stage"
}
trap cleanup EXIT

found=0
found_db=0
for item in /legacy/* /legacy/.[!.]* /legacy/..?*; do
  [ -e "$item" ] || [ -L "$item" ] || continue
  [ -f "$item" ] && [ ! -L "$item" ] || { echo "legacy volume contains an unsupported non-regular file" >&2; exit 1; }
  name=${item##*/}
  case "$name" in
    serverkit.db|serverkit.db-wal|serverkit.db-shm) ;;
    *) echo "legacy volume contains an unexpected file" >&2; exit 1 ;;
  esac
  cp -p -- "$item" "$stage/$name"
  found=1
  [ "$name" = serverkit.db ] && found_db=1
done

[ "$found" = 0 ] && exit 0
[ "$found_db" = 1 ] || { echo "legacy volume does not contain serverkit.db" >&2; exit 1; }

for name in serverkit.db-wal serverkit.db-shm serverkit.db; do
  if [ -e "$stage/$name" ]; then
    [ ! -e "/target/$name" ] && [ ! -L "/target/$name" ] || { echo "target data file already exists" >&2; exit 1; }
    chown 999:999 "$stage/$name"
    chmod 0640 "$stage/$name"
    mv -- "$stage/$name" "/target/$name"
  fi
done
'

bash "$SCRIPT_DIR/init.sh"
