#!/bin/bash
set -euo pipefail

version_root=$(cd "$(dirname "$0")/.." && pwd)
data_dir=./data

if [ -f "$version_root/.env" ]; then
    configured_dir=$(sed -n 's/^APP_DATA_DIR=//p' "$version_root/.env" | tail -n 1)
    if [ -n "$configured_dir" ]; then
        data_dir=$configured_dir
    fi
fi

case "$data_dir" in
    \"*\") data_dir=${data_dir#\"}; data_dir=${data_dir%\"} ;;
    \'*\') data_dir=${data_dir#\'}; data_dir=${data_dir%\'} ;;
esac

if [ -z "$data_dir" ]; then
    echo "APP_DATA_DIR must not be empty" >&2
    exit 1
fi

case "$data_dir" in
    /*) data_root=$(realpath -m "$data_dir") ;;
    *) data_root=$(realpath -m "$version_root/$data_dir") ;;
esac

case "$data_root" in
    /|/bin|/boot|/dev|/etc|/home|/lib|/lib64|/media|/mnt|/opt|/proc|/root|/run|/sbin|/srv|/sys|/tmp|/usr|/var|/workspace)
        echo "Refusing unsafe Vault data directory: $data_root" >&2
        exit 1
        ;;
esac

for name in file logs; do
    target="$data_root/$name"
    if [ -L "$target" ]; then
        echo "Refusing symlinked Vault data path: $target" >&2
        exit 1
    fi
    if [ -e "$target" ] && [ ! -d "$target" ]; then
        echo "Vault data path is not a directory: $target" >&2
        exit 1
    fi
    mkdir -p -- "$target"
    chown 100:1000 "$target"
done

chmod 0700 "$data_root/file"
chmod 0750 "$data_root/logs"
