#!/usr/bin/env bash
set -euo pipefail

app_data_dir="${APP_DATA_DIR_1:-}"
if [[ -z "${app_data_dir}" && -f ./.env ]]; then
  app_data_dir="$(sed -n 's/^APP_DATA_DIR_1=\"\{0,1\}\(.*\)\"\{0,1\}$/\1/p' ./.env | tail -n 1)"
fi
app_data_dir="${app_data_dir:-./data}"

mkdir -p "${app_data_dir}"
exit 0
