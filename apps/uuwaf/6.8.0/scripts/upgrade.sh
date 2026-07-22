#!/usr/bin/env bash
set -euo pipefail

if docker volume inspect wafshared >/dev/null 2>&1; then
  echo "The legacy wafshared volume will be retained read-only and migrated on first 6.8.0 startup."
fi

if docker volume inspect wafdata >/dev/null 2>&1; then
  echo "The existing wafdata database volume will be reused without modification."
fi
