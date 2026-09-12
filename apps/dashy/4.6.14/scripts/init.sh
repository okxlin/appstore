#!/bin/bash
set -euo pipefail

mkdir -p data/user-data data/item-icons
touch data/user-data/conf.yml
chown -R 1000:1000 data
