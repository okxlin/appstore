#!/bin/bash

if [[ ! -f ./.env ]]; then
  echo ".env 文件不存在"
  exit 0
fi

if ! grep -q "^TING_SECURITY__JWT_SECRET=" ./.env || [[ -z "$(grep '^TING_SECURITY__JWT_SECRET=' ./.env | cut -d '=' -f 2-)" ]]; then
  JWT_SECRET=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 64 | head -n 1)
  if grep -q "^TING_SECURITY__JWT_SECRET=" ./.env; then
    sed -i "s|^TING_SECURITY__JWT_SECRET=.*|TING_SECURITY__JWT_SECRET=${JWT_SECRET}|" ./.env
  else
    echo "TING_SECURITY__JWT_SECRET=${JWT_SECRET}" >> ./.env
  fi
  echo "已生成随机 JWT 密钥"
else
  echo "TING_SECURITY__JWT_SECRET 已存在"
fi
