#!/bin/bash
set -euo pipefail

echo '[oh-my-opencode:upgrade] upgrade path is image-driven.'
echo '[oh-my-opencode:upgrade] update IMAGE_TAG or IMAGE_REPO in the app config, then redeploy.'
echo '[oh-my-opencode:upgrade] persistent OpenCode userland stays under ./data/runtime.'
