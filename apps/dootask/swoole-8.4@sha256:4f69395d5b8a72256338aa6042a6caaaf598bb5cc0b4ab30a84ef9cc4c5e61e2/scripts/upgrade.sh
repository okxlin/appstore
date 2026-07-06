#!/usr/bin/env bash
set -euo pipefail

echo "DooTask is currently pinned to upstream release v1.8.64."
echo "Automatic in-place source upgrades are intentionally disabled for this package."
echo "Back up APP_DATA_DIR/app, the external MySQL database, and the external Redis data before changing packaged versions."
exit 0
