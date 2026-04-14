#!/bin/bash
set -euo pipefail

# 当前适配使用 1Panel 数据库 / Redis 依赖注入。
# 这里只初始化应用自身的数据目录。
mkdir -p "${APP_DATA_DIR_1:-./data}"
