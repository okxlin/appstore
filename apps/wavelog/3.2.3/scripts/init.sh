#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

mkdir -p "${ROOT_DIR}/data/wavelog-config" "${ROOT_DIR}/data/wavelog-uploads" "${ROOT_DIR}/data/wavelog-userdata"

# The official image writes installer output as www-data.
chown -R 33:33 "${ROOT_DIR}/data/wavelog-config" "${ROOT_DIR}/data/wavelog-uploads" "${ROOT_DIR}/data/wavelog-userdata" 2>/dev/null || true
chmod -R u+rwX,g+rwX "${ROOT_DIR}/data/wavelog-config" "${ROOT_DIR}/data/wavelog-uploads" "${ROOT_DIR}/data/wavelog-userdata"
