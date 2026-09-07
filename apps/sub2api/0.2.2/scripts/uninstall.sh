#!/bin/bash
set -euo pipefail

# 当前适配只卸载 Sub2API 容器本身。
# 数据库与 Redis 为 1Panel 依赖应用，不在此处删除。
docker-compose down --volumes
