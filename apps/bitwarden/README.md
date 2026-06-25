# Bitwarden

## 应用简介
一个开源的密码管理服务。

英文说明：An open source password management service.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：安全。
- 支持架构：arm64、amd64、arm。
- 可选版本：`latest`、`1.36.0-alpine`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40031 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SIGNUPS_ALLOWED | 允许注册 | true | 是 |
| INVITATIONS_ALLOWED | 允许邀请 | true | 是 |
| WEBSOCKET_ENABLED | 启用 WebSocket | false | 是 |
| ADMIN_TOKEN | 管理员令牌 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://bitwarden.com/>
- 文档: <https://github.com/dani-garcia/vaultwarden/wiki>
- 源码: <https://github.com/dani-garcia/vaultwarden>
