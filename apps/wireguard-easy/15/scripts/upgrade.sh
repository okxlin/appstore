#!/bin/bash

# 检查 .env 文件是否存在
if [[ -f ./.env ]]; then

  # 如果 .env 文件中有 WEBUI_PWD 的设置，删除该行
  if grep -q 'WEBUI_PWD' ./.env; then
    sed -i '/WEBUI_PWD/d' ./.env
    echo "已移除 .env 文件中的 WEBUI_PWD 参数"
  fi

  # 检查并添加 WG_ALLOWED_IPS 参数
  if ! grep -q 'WG_ALLOWED_IPS' ./.env; then
    echo 'WG_ALLOWED_IPS="10.0.8.0/24"' >> ./.env
    echo "已添加 WG_ALLOWED_IPS=10.0.8.0/24"
  else
    echo "WG_ALLOWED_IPS 参数已存在"
  fi

  # 检查并添加 WG_DEFAULT_ADDRESS 参数
  if ! grep -q 'WG_DEFAULT_ADDRESS' ./.env; then
    echo 'WG_DEFAULT_ADDRESS="10.0.8.x"' >> ./.env
    echo "已添加 WG_DEFAULT_ADDRESS=10.0.8.x"
  else
    echo "WG_DEFAULT_ADDRESS 参数已存在"
  fi

  # 检查并添加 WG_DEFAULT_DNS 参数
  if ! grep -q 'WG_DEFAULT_DNS' ./.env; then
    echo 'WG_DEFAULT_DNS="119.29.29.29,1.1.1.1"' >> ./.env
    echo "已添加 WG_DEFAULT_DNS=119.29.29.29,1.1.1.1"
  else
    echo "WG_DEFAULT_DNS 参数已存在"
  fi

  # 检查并添加 WG_MTU 参数
  if ! grep -q 'WG_MTU' ./.env; then
    echo 'WG_MTU=1420' >> ./.env
    echo "已添加 WG_MTU=1420"
  else
    echo "WG_MTU 参数已存在"
  fi

  # 检查并添加 WG_PERSISTENT_KEEPALIVE 参数
  if ! grep -q 'WG_PERSISTENT_KEEPALIVE' ./.env; then
    echo 'WG_PERSISTENT_KEEPALIVE=25' >> ./.env
    echo "已添加 WG_PERSISTENT_KEEPALIVE=25"
  else
    echo "WG_PERSISTENT_KEEPALIVE 参数已存在"
  fi

  # 检查并添加 WIREGUARD_PORT 参数
  if ! grep -q 'WIREGUARD_PORT' ./.env; then
    echo 'WIREGUARD_PORT=51820' >> ./.env
    echo "已添加 WIREGUARD_PORT=51820"
  else
    echo "WIREGUARD_PORT 参数已存在"
  fi

  # 检查并添加 PASSWORD_HASH 参数
  if ! grep -q 'PASSWORD_HASH' ./.env; then
    echo 'PASSWORD_HASH="$$2a$$12$$0AL3hGeedv8fOfsNtfZY5OO3mMvBqlnZA8QmeBGfWPAQEoZ7LZ/7a"' >> ./.env
    echo '已添加 PASSWORD_HASH="$$2a$$12$$0AL3hGeedv8fOfsNtfZY5OO3mMvBqlnZA8QmeBGfWPAQEoZ7LZ/7a"'
  else
    echo "PASSWORD_HASH 参数已存在"
  fi

else
  echo ".env 文件不存在"
fi
