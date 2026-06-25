# Dashy

## 应用简介
专为您打造的可自行托管的个人仪表板。

英文说明：A self-hostable personal dashboard built for you.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`4.3.9`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40209 | 是 |

## 数据持久化
- `./data/user-data/conf.yml:/app/user-data/conf.yml`
- `./data/item-icons:/app/user-data/item-icons`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://dashy.to>
- 文档: <https://dashy.to/docs>
- 源码: <https://github.com/Lissy93/dashy>
