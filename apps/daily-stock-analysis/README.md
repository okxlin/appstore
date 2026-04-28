# 每日股票分析 (Daily Stock Analysis)

LLM 驱动的 A 股/港股/美股智能分析系统，聚合多数据源行情、实时新闻、技术指标与 AI 决策仪表盘，支持多渠道推送。

## 快速开始

安装后访问 `http://<IP>:<端口>` 进入 Web 工作台。

> **首次访问**：若启用管理密码（默认开启），WebUI 会引导设置密码，保护 API Key 等敏感配置。

## 安装时配置（1Panel 表单）

| 字段 | 说明 | 默认值 |
|---|---|---|
| 端口 | WebUI 访问端口 | 8000 |
| 时区 | 容器时区 | Asia/Shanghai |
| 自选股列表 | 可选，可在 WebUI 内添加 | 空 |
| 管理密码 | 首次访问 WebUI 时设置密码 | 开启 |

> **LLM 模型 / 通知渠道 / 新闻搜索 / 报告 / 定时 / 回测 / 策略** 等全部配置请进入 WebUI → 设置页面完成，无需在 1Panel 表单中填写。

## 主要功能

- 🤖 **AI 决策仪表盘**：核心结论、评分、买卖点位、风险警报
- 📊 **多维度分析**：技术面、实时行情、新闻舆情、公告、资金流
- 🌍 **全球市场**：A 股、港股、美股及常见 ETF
- 🖥️ **Web 工作台**：手动分析、配置管理、历史报告、回测、持仓
- 🧠 **策略问股**：均线金叉、缠论、波浪等 11 种内置策略
- 📬 **多渠道推送**：企业微信/飞书/Telegram/Discord/Slack/邮件
- 🔐 **密码保护**：WebUI 管理员登录保护敏感设置

## 数据持久化

| 容器路径 | 用途 |
|---|---|
| `/app/data` | 数据库和分析缓存 |
| `/app/logs` | 运行日志 |
| `/app/reports` | 分析报告存档 |

## 源码

GitHub: [ZhuLinsen/daily_stock_analysis](https://github.com/ZhuLinsen/daily_stock_analysis)

完整配置指南：[docs/full-guide.md](https://github.com/ZhuLinsen/daily_stock_analysis/blob/main/docs/full-guide.md)
