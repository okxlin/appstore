#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

mkdir -p -- "${ROOT_DIR}/data/config" "${ROOT_DIR}/data/logs" "${ROOT_DIR}/data/storage"
