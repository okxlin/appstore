#!/usr/bin/env bash
set -euo pipefail

# Re-apply the confined data-path resolution before Compose starts. 1Panel
# rewrites .env from the stored install parameters during an upgrade, so a
# relative APP_DATA_DIR would otherwise move the SQLite bind into the app tree.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
exec "${ROOT_DIR}/scripts/init.sh"
