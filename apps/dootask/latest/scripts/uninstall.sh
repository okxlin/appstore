#!/usr/bin/env bash
set -euo pipefail

docker-compose down --volumes --remove-orphans || true
