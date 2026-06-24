# SeaTable

## 应用简介
一款以智能表格为基础的新型数字化平台。

英文说明：A spreadsheet/database like Airtable.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`6.1.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |
| PANEL_APP_PORT_HTTP | HTTP端口 | 40154 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_ROOT_PASSWORD | 数据库 root 密码 | mysql_root_password | 是 |
| REDIS_HOST | Redis服务 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码 | - | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| MEMCACHED_TYPE | Memcached 服务 | memcached | 是 |
| SERVER_HOSTNAME | 服务端主机名 | example.seatable.com | 是 |

## 使用说明
**创建时需要手动连接容器终端执行命令启动服务，并创建管理员账户密码。**

容器管理功能页面，连接容器终端，执行以下命令

- 启动 SeaTable 服务

```
/shared/seatable/scripts/seatable.sh start
```

- # 创建一个管理员帐户
```
/shared/seatable/scripts/seatable.sh superuser  
```

## 参考资料
- 官网: <https://seatable.cn>
- 文档: <https://docs.seatable.cn>
- 源码: <https://github.com/seatable/seatable>
