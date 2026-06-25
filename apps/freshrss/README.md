# FreshRSS

## 应用简介
自托管的 RSS 和 Atom 订阅源聚合器。

英文说明：A self-hosted RSS and Atom feed aggregator.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm、arm64。
- 可选版本：`latest`、`1.29.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40293 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data/data | 是 |
| EXTENSIONS_PATH | 扩展路径 | ./data/extensions | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| CRON_MIN | 定时任务分钟 | 2,32 | 是 |
| FRESHRSS_ENV | 环境 | development | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://freshrss.org>
- 文档: <https://freshrss.github.io/FreshRSS>
- 源码: <https://github.com/FreshRSS/FreshRSS>
