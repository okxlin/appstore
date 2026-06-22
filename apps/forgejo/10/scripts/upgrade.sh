#!/bin/bash

if [[ -f ./.env ]]; then
  if grep -q "PANEL_DB_TYPE" ./.env; then
    echo "PANEL_DB_TYPE 已存在"
  else
    echo 'PANEL_DB_TYPE="mysql"' >> ./.env
  fi
else
  echo ".env 文件不存在"
fi