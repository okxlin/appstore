#!/usr/bin/env bash
set -euo pipefail
mkdir -p ./data/config ./data/data1 ./data/data2
chown -R 1000:1000 ./data 2>/dev/null || true
