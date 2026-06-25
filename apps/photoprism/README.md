# PhotoPrism

## 应用简介
去中心化网络的人工智能照片应用程序。

英文说明：AI-Powered Photos App for the Decentralized Web.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`231128`、`sqlite-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PHOTOPRISM_DB_PORT | MariaDB数据库服务端口 | 3306 | 是 |
| PANEL_APP_PORT_HTTP | 端口 | 40101 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |
| SITE_DESCRIPTION | 网站描述 | - | 否 |
| SITE_AUTHOR | 网站作者 | - | 否 |
| SITE_CAPTION | 网站标题 | AI-Powered Photos App | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_HOST | MariaDB数据库服务 | - | 是 |
| PANEL_DB_USER | 数据库用户 | photoprism | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | photoprism | 是 |
| UID | UID | 1000 | 是 |
| GID | GID | 1000 | 是 |
| ADMIN_USER | 管理员用户名 | admin | 是 |
| ADMIN_PASSWORD | 管理员密码 | photoprism | 是 |
| PHOTOPRISM_EXTERNAL_URL | 外部访问地址 | http://localhost:40101/ | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.photoprism.app>
- 文档: <https://docs.photoprism.app>
- 源码: <https://github.com/photoprism/photoprism>
