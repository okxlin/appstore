# Nging

## 应用简介
Go 语言 Web 管理面板。

英文说明：Go Language Web Management Panel.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40227 | 是 |

## 数据持久化
- `./data/data/cache:/home/nging_linux_amd64/data/cache`
- `./data/data/ftpdir:/home/nging_linux_amd64/data/ftpdir`
- `./data/data/logs:/home/nging_linux_amd64/data/logs`
- `./data/data/sm2:/home/nging_linux_amd64/data/sm2`
- `./data/myconfig:/home/nging_linux_amd64/myconfig`
- `./data/public:/home/nging_linux_amd64/public`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/admpub/nging>
