# Zabbix-Server

## 应用简介
实时监控 IT 组件和服务(服务端)。

英文说明：Real-time monitoring of IT components and services (Server).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`7.4.11`、`7.4.11&mysql`、`7.4.11-postgres`、`6.4.13`、`6.4.13&mysql`、`6.4.13-postgres`、`latest&mysql`、`latest-postgres`。
- 安装后按应用表单中的端口访问 Web UI 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP2 | 网关端口 | 10051 | 是 |
| PANEL_APP_PORT_HTTP | 端口 | 40047 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_NAME | 数据库名 | zabbix | 是 |
| PANEL_DB_USER | 数据库用户 | zabbix | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | zabbix | 是 |

## 使用说明
- 默认账户与密码(注意大小写)

```
username:Admin
password:zabbix
```

### 注意事项

**注意：默认版本是 Zabbix-MySQL 版本。Zabbix 7.4 要求 MySQL/Percona 8.0.30+ 或 PostgreSQL 13+。**

**`postgresql`的版本，资源占用会小很多。**

商店自带的`MySQL 8`的数据库格式设置与`Zabbix`需求有所不同，`zabbix-server-mysql`容器会提示存在错误。

但是实际能够运行。如有错误，期待反馈。

- 带`&mysql`版本，会安装符合`Zabbix`格式要求的数据库版本
- 不带`&mysql`的版本，默认调用面板安装的数据库
- 官方文档说明 Zabbix 7.4.x 支持从 6.4.x 直接升级；旧的 6.4.13 版本目录保留用于老用户升级和回溯。

## 参考资料
- 官网: <https://www.zabbix.com/>
- 文档: <https://www.zabbix.com/manuals>
- 源码: <https://github.com/zabbix/zabbix>
