# Duplicati

## 应用简介
在云存储服务上安全地存储加密备份。

英文说明：Store securely encrypted backups on cloud storage services.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`2.3.0.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40261 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| BACKUPS_PATH | 外部备份路径 | ./data/backups | 是 |
| INTERNAL_BACKUPS_PATH | 内部备份路径 | /backups | 是 |
| DATA_PATH | 数据路径 | ./data/data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.duplicati.com>
- 文档: <https://docs.duplicati.com>
- 源码: <https://github.com/duplicati/duplicati>
