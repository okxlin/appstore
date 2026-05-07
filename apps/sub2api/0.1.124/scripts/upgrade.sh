#!/bin/bash
set -euo pipefail

# 升级时确保应用自身的数据目录存在。
# 数据库与 Redis 数据由 1Panel 依赖应用管理。
mkdir -p "${APP_DATA_DIR_1:-./data}"
