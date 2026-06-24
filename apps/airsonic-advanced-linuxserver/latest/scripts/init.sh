#!/usr/bin/env bash
set -euo pipefail
mkdir -p ./data/config ./data/music ./data/playlists ./data/podcasts ./data/media
chown -R 1000:1000 ./data 2>/dev/null || true
