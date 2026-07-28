#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
data_dir="${root_dir}/data"
assets_dir="${data_dir}/assets"

[[ ! -L "$data_dir" ]] || { echo "Homer data directory must not be a symbolic link" >&2; exit 1; }
[[ ! -L "$assets_dir" ]] || { echo "Homer assets directory must not be a symbolic link" >&2; exit 1; }

mkdir -p -- "$assets_dir"
chown 1000:1000 "$data_dir" "$assets_dir"
chmod 750 "$data_dir" "$assets_dir"
