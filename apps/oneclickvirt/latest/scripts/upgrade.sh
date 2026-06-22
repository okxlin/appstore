#!/bin/bash

if [[ ! -f ./.env ]]; then
  echo ".env 文件不存在"
  exit 0
fi

if grep -q "^PANEL_DB_PORT=" ./.env; then
  echo "PANEL_DB_PORT 已存在"
else
  echo 'PANEL_DB_PORT="3306"' >> ./.env
fi
