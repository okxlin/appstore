#!/usr/bin/env bash
set -euo pipefail

# Restore the retained-data path after 1Panel reapplies upgrade form values.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
exec bash "${SCRIPT_DIR}/init.sh"
