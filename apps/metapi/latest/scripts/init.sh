#!/bin/bash
set -euo pipefail

APP_DATA_DIR_VALUE="${APP_DATA_DIR:-data}"

# Only create local directories for bind-mount style paths.
case "${APP_DATA_DIR_VALUE}" in
  /*|./*|../*)
    mkdir -p "${APP_DATA_DIR_VALUE}"
    ;;
  *)
    ;;
esac
