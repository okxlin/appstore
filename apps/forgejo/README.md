# Forgejo

## 应用简介
新一代的代码托管平台。

英文说明：The next generation of code hosting platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64、arm64。
- 当前可安装版本以 1Panel 应用详情中显示的版本为准。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_PORT | 数据库端口 | 3306 | 是 |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3000 | 是 |
| PANEL_APP_PORT_SSH | SSH 端口 | 222 | 是 |

## 数据持久化
- `./data:/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | forgejo | 是 |
| PANEL_DB_USER | 数据库用户 | forgejo | 是 |
| PANEL_DB_USER_PASSWORD | 数据库密码 | forgejo | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://forgejo.org/>
- 文档: <https://forgejo.org/docs/>
- 源码: <https://codeberg.org/forgejo/forgejo>
