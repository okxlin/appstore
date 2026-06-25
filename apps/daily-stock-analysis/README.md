# 每日股票分析

## 应用简介
LLM驱动的A股/港股/美股智能分析系统，多数据源行情+实时新闻+AI决策仪表盘+多渠道推送。

英文说明：LLM-powered stock analysis for A/H/US markets with multi-source data, real-time news, AI dashboard, and multi-channel notifications.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`3.21.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 8000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 数据目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ADMIN_AUTH_ENABLED | 管理密码（首次访问 WebUI 设置） | true | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/ZhuLinsen/daily_stock_analysis>
- 文档: <https://github.com/ZhuLinsen/daily_stock_analysis/blob/main/docs/full-guide.md>
