#!/usr/bin/env bash
set -euo pipefail

mkdir -p ./data/wavelog-config ./data/wavelog-uploads ./data/wavelog-userdata

# The official image writes installer output as www-data.
chown -R 33:33 ./data/wavelog-config ./data/wavelog-uploads ./data/wavelog-userdata 2>/dev/null || true
chmod -R u+rwX,g+rwX ./data/wavelog-config ./data/wavelog-uploads ./data/wavelog-userdata
