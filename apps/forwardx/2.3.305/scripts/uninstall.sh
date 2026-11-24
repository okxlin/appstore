#!/bin/bash
set -e

if docker compose version >/dev/null 2>&1; then
  docker compose down
else
  docker-compose down
fi
