#!/bin/bash

# 创建必要的目录
mkdir -p ./data
mkdir -p ./plugins
mkdir -p ./temp
mkdir -p ./storage

# 设置目录权限
chmod -R 755 ./data
chmod -R 755 ./plugins
chmod -R 755 ./temp
chmod -R 755 ./storage

# 生成随机 JWT 密钥（64字符）
if [ -f ./.env ]; then
    if ! grep -q "^TING_SECURITY__JWT_SECRET=" ./.env || [ "$(grep '^TING_SECURITY__JWT_SECRET=' ./.env | cut -d '=' -f 2)" == "" ]; then
        # 生成64字符的随机密钥
        JWT_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
        if grep -q "^TING_SECURITY__JWT_SECRET=" ./.env; then
            sed -i "s|^TING_SECURITY__JWT_SECRET=.*|TING_SECURITY__JWT_SECRET=${JWT_SECRET}|" ./.env
        else
            echo "TING_SECURITY__JWT_SECRET=${JWT_SECRET}" >> ./.env
        fi
        echo "已生成随机 JWT 密钥"
    fi
fi

echo "Ting Reader 初始化完成"
echo "默认账号: admin"
echo "默认密码: admin123"
echo "请在首次登录后立即修改密码！"
