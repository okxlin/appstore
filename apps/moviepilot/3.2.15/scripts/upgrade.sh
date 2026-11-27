#!/usr/bin/env bash
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/init.sh"
printf '%s\n' '升级提醒：本次保留现有 API_TOKEN，避免中断 Webhook、MCP 等集成。若仍使用旧模板的共用默认值，请在 MoviePilot 设置 → 系统 → API 令牌中轮换，并同步更新相关集成。'
