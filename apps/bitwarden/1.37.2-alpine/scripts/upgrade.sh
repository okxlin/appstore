#!/bin/bash

# 检查 .env 文件是否存在
if [[ -f ./.env ]]; then

  # 检查并添加 ADMIN_TOKEN 参数
  if ! grep -q '^ADMIN_TOKEN=' ./.env; then
    echo 'ADMIN_TOKEN=""' >> ./.env
    echo "已添加 ADMIN_TOKEN="
  else
    echo "ADMIN_TOKEN 参数已存在"
  fi

  # 检查并添加 INVITATIONS_ALLOWED 参数
  if ! grep -q '^INVITATIONS_ALLOWED=' ./.env; then
    echo 'INVITATIONS_ALLOWED="true"' >> ./.env
    echo "已添加 INVITATIONS_ALLOWED=true"
  else
    echo "INVITATIONS_ALLOWED 参数已存在"
  fi

  # 检查并添加 SIGNUPS_ALLOWED 参数
  if ! grep -q '^SIGNUPS_ALLOWED=' ./.env; then
    echo 'SIGNUPS_ALLOWED="true"' >> ./.env
    echo "已添加 SIGNUPS_ALLOWED=true"
  else
    echo "SIGNUPS_ALLOWED 参数已存在"
  fi

  # 检查并添加 WEBSOCKET_ENABLED 参数
  if ! grep -q '^WEBSOCKET_ENABLED=' ./.env; then
    echo 'WEBSOCKET_ENABLED="false"' >> ./.env
    echo "已添加 WEBSOCKET_ENABLED=false"
  else
    echo "WEBSOCKET_ENABLED 参数已存在"
  fi

else
  echo ".env 文件不存在"
fi
