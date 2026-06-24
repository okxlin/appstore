# Mattermost

## 应用简介
开源团队协作平台。

英文说明：Open-source team collaboration platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`11.8.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40271 | 是 |
| PANEL_APP_PORT_CALLS | RTC 服务端口 | 40272 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MATTERMOST_CONFIG_PATH | 配置路径 | ./data/config | 是 |
| MATTERMOST_DATA_PATH | 数据路径 | ./data/data | 是 |
| MATTERMOST_LOGS_PATH | 日志路径 | ./data/logs | 是 |
| MATTERMOST_PLUGINS_PATH | 插件路径 | ./data/plugins | 是 |
| MATTERMOST_CLIENT_PLUGINS_PATH | 客户端插件路径 | ./data/client/plugins | 是 |
| GITLAB_PKI_CHAIN_PATH | GitLab PKI 链路径 (编辑去除compose.yml里的注释生效) | - | 否 |
| MATTERMOST_BLEVE_INDEXES_PATH | Bleve 索引路径 | ./data/bleve/indexes | 是 |
| MM_BLEVESETTINGS_INDEXDIR | Bleve 索引目录 | /mattermost/bleve-indexes | 是 |
| MM_SERVICESETTINGS_SITEURL | 站点 URL | http://localhost:40271 | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MATTERMOST_CONTAINER_READONLY | 只读容器 | false | 否 |
| MM_SQLSETTINGS_DRIVERNAME | SQL 驱动名称 | postgres | 是 |
| PANEL_DB_TYPE | 数据库服务 | postgresql | 是 |
| PANEL_DB_NAME | 数据库名 | mattermost | 是 |
| PANEL_DB_USER | 数据库用户 | mattermost | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | mattermost | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://mattermost.com>
- 文档: <https://docs.mattermost.com>
- 源码: <https://github.com/mattermost/mattermost>
