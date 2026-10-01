#!/usr/bin/env bash
set -euo pipefail

echo "DeepSeek Harness Workstation keeps application state under ./data/data:/data."
echo "If legacy state exists in dsh-home:/home/node/.local/share/deepseek-harness, the image migrates it to /data on first startup when /data/auth is empty."
exit 0
