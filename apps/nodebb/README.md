# NodeBB

## 应用简介
基于 Node.js 的现代化论坛程序。

英文说明：Open source Forum Powered by Node.js.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`2.8`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40202 | 是 |

## 数据持久化
- `./data:/usr/src/app/public/uploads`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://nodebb.org/>
- 文档: <https://docs.nodebb.org/>
- 源码: <https://github.com/NodeBB/NodeBB>
