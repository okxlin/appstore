#!/usr/bin/env bash
set -euo pipefail

if [[ ! -S /var/run/docker.sock ]]; then
  printf '%s\n' "Docker socket not found: /var/run/docker.sock" >&2
  exit 1
fi
