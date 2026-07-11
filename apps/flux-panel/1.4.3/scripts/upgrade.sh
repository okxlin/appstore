#!/bin/bash
set -e

APP_DATA_DIR="${APP_DATA_DIR:-./data}"
mkdir -p "${APP_DATA_DIR}/mysql" "${APP_DATA_DIR}/logs"
