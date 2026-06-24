# EasyBot

## 应用简介
面向游戏服务器的社区互通与管理服务。

英文说明：Game server community bridge and management service.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`full`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_WEB | Web 端口 | 5000 | 是 |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 5001 | 是 |
| PANEL_APP_PORT_BRIDGE | Bridge端口 | 26990 | 是 |

## 数据持久化
- `./data:/app/appdata`
- `./logs:/app/logs`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://docs.inectar.cn/>
- 文档: <https://docs.inectar.cn/docs/easybot/quick_start/install_docker/>
- 源码: <https://github.com/easybot-team/easybot-docker>
