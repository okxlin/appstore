# Joplin Server

## 应用简介
一个开源的记事本应用程序。

英文说明：An open source note-taking app.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.0.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 40082 | 是 |
| POSTGRES_PORT | Postgres数据库服务端口 | 5432 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| POSTGRES_HOST | Postgres数据库服务 | - | 是 |
| POSTGRES_DB | Postgres数据库名 | joplin | 是 |
| POSTGRES_USER | Postgres数据库用户名 | - | 是 |
| POSTGRES_PWD | Postgres数据库密码 | - | 是 |
| JOPLIN_EXTERNAL_URL | 外部访问地址 | http://localhost:40082 | 是 |

## 使用说明
- 默认账户密码
```
username：admin@localhost
password：admin
```

## 参考资料
- 官网: <https://joplinapp.org/>
- 文档: <https://joplinapp.org/help/>
- 源码: <https://github.com/laurent22/joplin>
