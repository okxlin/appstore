# MySQL

## 应用简介
MySQL 开源关系型数据库。

英文说明：Open source relational database management system.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：数据库。
- 支持架构：amd64。
- 可选版本：`5.5.62`、`5.6.51`、`5.7.44`、`8.0.40`、`8.4.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 3306 | 是 |

## 数据持久化
- `./data/:/var/lib/mysql`
- `./conf/my.cnf:/etc/mysql/my.cnf`
- `./log:/var/log/mysql`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_ROOT_PASSWORD | root用户密码 | mysql | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.mysql.com>
- 文档: <https://dev.mysql.com/doc/>
- 源码: <https://github.com/mysql/mysql-server>
