# Sub-Store

## 应用简介
适用于 QX、Loon、Surge、Stash 和 Shadowrocket 的高级订阅管理器。

英文说明：Advanced Subscription Manager for QX, Loon, Surge, Stash and Shadowrocket.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40232 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SUB_STORE_FRONTEND_BACKEND_PATH | 前端后端路径 | /2cXaAxRGfddmGz2yx1wA | 是 |
| DATA_PATH | 数据目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SUB_STORE_PUSH_SERVICE | 推送服务 URL | https://api.day.app/XXXXXXXXXXXX/[推送标题]/[推送内容]?group=SubStore&autoCopy=1&isArchive=1&sound=shake&level=timeSensitive&icon=https%3A%2F%2Fraw.githubusercontent.com%2F58xinian%2Ficon%2Fmaster%2FSub-Store1.png | 是 |
| SUB_STORE_CRON | Cron 定时任务 | 55 23 * * * | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://hub.docker.com/r/xream/sub-store>
- 文档: <https://www.notion.so/Sub-Store-6259586994d34c11a4ced5c406264b46>
- 源码: <https://github.com/sub-store-org/Sub-Store>
