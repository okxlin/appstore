#!/bin/sh

# 创建临时目录
mkdir -p ./tmp

# 下载 direct-list.txt 文件
wget -O ./tmp/direct-list.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt

# 下载 apple-cn.txt 文件
wget -O ./tmp/apple-cn.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/apple-cn.txt

# 下载 google-cn.txt 文件
wget -O ./tmp/google-cn.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/google-cn.txt

# 下载 proxy-list.txt 文件
wget -O ./tmp/proxy-list.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt

# 下载 gfw.txt 文件
wget -O ./tmp/gfw.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt

# 下载 reject-list.txt 文件
wget -O ./tmp/reject-list.txt https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/reject-list.txt

# 下载 CN-ip-cidr.txt 文件
wget -O ./tmp/CN-ip-cidr.txt https://raw.githubusercontent.com/Hackl0us/GeoIP2-CN/release/CN-ip-cidr.txt

# 将临时目录下的文件复制到当前目录
cp -rf ./tmp/* .

# 删除临时目录
rm -r ./tmp
