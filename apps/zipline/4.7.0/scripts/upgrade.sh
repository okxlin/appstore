#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"
source "${ROOT_DIR}/scripts/credentials.sh"

zipline_restore_upgrade_credentials "$ROOT_DIR" "$ENV_FILE"
