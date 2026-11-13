#!/usr/bin/env bash
set -euo pipefail
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
[[ -d "$ROOT_DIR" && ! -L "$ROOT_DIR" ]] || {
  echo "unsafe application root: $ROOT_DIR" >&2
  exit 1
}
[[ "$(id -u)" == "0" ]] || {
  echo "directory ownership initialization must run as root" >&2
  exit 1
}

ensure_fixed_directory() {
  local name="$1"
  local path="$ROOT_DIR/$name"
  if [[ -L "$path" ]]; then
    echo "unsafe directory symlink: $path" >&2
    exit 1
  fi
  mkdir -p -- "$path"
  [[ -d "$path" && ! -L "$path" ]] || {
    echo "unsafe directory: $path" >&2
    exit 1
  }
}

ensure_fixed_owned_dir() {
  local source="$1"
  local uid="$2"
  local gid="$3"
  local mode="$4"
  local path="$ROOT_DIR/${source#./}"
  if [[ -L "$path" ]]; then
    echo "unsafe directory symlink: $path" >&2
    exit 1
  fi
  mkdir -p -- "$path"
  [[ -d "$path" && ! -L "$path" ]] || {
    echo "unsafe directory: $path" >&2
    exit 1
  }
  chmod "$mode" -- "$path"
  chown --no-dereference "$uid:$gid" -- "$path"
}

ensure_fixed_owned_dir "./milvus-data" "999" "999" "0750"
ensure_fixed_directory "etcd-data"
ensure_fixed_directory "minio-data"

MILVUS_DATA_DIR="$ROOT_DIR/milvus-data"
MILVUS_MARKER="$MILVUS_DATA_DIR/.milvus-volume-owner-999-999"

if [[ -L "$MILVUS_MARKER" ]]; then
  echo "unsafe Milvus ownership marker symlink: $MILVUS_MARKER" >&2
  exit 1
fi

# 1Panel treats a successful one-shot Compose helper as unhealthy. Keep the
# official marker and ownership initialization in the root lifecycle hook.
chmod 0750 -- "$MILVUS_DATA_DIR"
chown --no-dereference 999:999 -- "$MILVUS_DATA_DIR"
if [[ ! -e "$MILVUS_MARKER" ]]; then
  echo "Preparing $MILVUS_DATA_DIR for 999:999"
  chown -R --no-dereference 999:999 -- "$MILVUS_DATA_DIR"
  touch -- "$MILVUS_MARKER"
  chown --no-dereference 999:999 -- "$MILVUS_MARKER"
fi
