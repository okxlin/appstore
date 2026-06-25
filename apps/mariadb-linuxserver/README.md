# MariaDB

## 应用简介
MariaDB 数据库服务。

英文说明：MariaDB database service maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：数据库。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`11.4.12`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_DB | 数据库端口 | 3306 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| MYSQL_DATABASE | 初始数据库 | - | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MYSQL_ROOT_PASSWORD | Root 密码 | mariadb-root-change-me | 是 |
| MYSQL_USER | 初始用户 | - | 否 |
| MYSQL_PASSWORD | 初始用户密码 | - | 否 |
| CLI_OPTS | 命令行选项 | - | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://mariadb.org/>
- 文档: <https://docs.linuxserver.io/images/docker-mariadb/>
- 源码: <https://github.com/linuxserver/docker-mariadb>
