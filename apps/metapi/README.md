# Metapi

## 应用简介
聚合多个 AI 中转站的统一网关。

英文说明：Unified gateway aggregating multiple AI relay services.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`1.3.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 4000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 数据目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| AUTH_TOKEN | 管理员令牌 | - | 是 |
| PROXY_TOKEN | 代理令牌 | - | 是 |
| CHECKIN_CRON | 签到 Cron | 0 8 * * * | 否 |
| BALANCE_REFRESH_CRON | 余额刷新 Cron | 0 * * * * | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://metapi.cita777.me>
- 源码: <https://github.com/cita-777/metapi>
