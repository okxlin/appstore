#!/usr/bin/env bash
set -euo pipefail

echo "NexusPHP is pinned to a fixed app release and image digest."
echo "Automatic in-place app upgrades are intentionally disabled for this package."
echo "Back up APP_DATA_DIR and the compose-managed MySQL/Redis volumes before changing APP_RELEASE_VERSION or APP_IMAGE."
exit 0
