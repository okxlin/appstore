#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
bash "${SCRIPT_DIR}/init.sh"

echo "Next Terminal upgrade preflight completed."
