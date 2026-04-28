#!/bin/bash
set -euo pipefail

mkdir -p ./data/workspace ./data/config ./data/cache ./data/runtime

echo '[oh-my-opencode:init] initialized persistent directories:'
echo '  ./data/workspace -> /workspace'
echo '  ./data/config -> /config'
echo '  ./data/cache -> /cache'
echo '  ./data/runtime -> /data'
echo '[oh-my-opencode:init] default serve address: http://0.0.0.0:4096'
echo '[oh-my-opencode:init] ACP port: 8765'
