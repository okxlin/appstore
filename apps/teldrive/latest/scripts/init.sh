#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/../.env"
if [ -f "${ENV_FILE}" ]; then
  set -a
  # shellcheck disable=SC1090
  . "${ENV_FILE}"
  set +a
fi

DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${DATA_DIR}/postgres"
touch "${DATA_DIR}/storage.db"
