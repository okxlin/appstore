# BookStack

## 应用简介
BookStack 文档知识库。

英文说明：BookStack documentation wiki maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`26.05.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 6875 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| DB_DATA_PATH | 数据库数据目录 | ./data/db | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_URL | 应用访问 URL | - | 是 |
| APP_KEY | 应用密钥 | 安装时自动生成 | 是 |
| DB_HOST | 数据库主机 | bookstack-db | 是 |
| DB_PORT | 数据库端口 | 3306 | 是 |
| DB_USERNAME | 数据库用户名 | bookstack | 是 |
| DB_DATABASE | 数据库名称 | bookstack | 是 |
| DB_PASSWORD | 数据库密码 | 安装时自动生成 | 是 |
| QUEUE_CONNECTION | 异步队列连接 |  | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次安装时请填写 `APP_URL`、数据库参数和数据目录；应用密钥、数据库密码可留空由脚本自动生成。
- 首次访问通常会进入登录页面，可继续按 BookStack 的默认流程创建或使用现有管理员账号。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.bookstackapp.com/>
- 文档: <https://docs.linuxserver.io/images/docker-bookstack/>
- 源码: <https://github.com/linuxserver/docker-bookstack>
