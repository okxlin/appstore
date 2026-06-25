# Planka

## 应用简介
Planka 看板项目管理。

英文说明：Kanban project management maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`2.1.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 1337 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| DB_DATA_PATH | 数据库数据目录 | ./data/db | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| BASE_URL | 基础 URL | http://localhost:1337 | 是 |
| DB_PASSWORD | 数据库密码 | planka-change-me | 是 |
| DEFAULT_ADMIN_EMAIL | 管理员邮箱 | admin@example.com | 是 |
| DEFAULT_ADMIN_USERNAME | 管理员用户名 | admin | 是 |
| DEFAULT_ADMIN_PASSWORD | 管理员密码 | planka-admin-change-me | 是 |
| DEFAULT_ADMIN_NAME | 管理员显示名 | Planka Admin | 是 |
| SECRET_KEY | 会话密钥 | change-this-secret-key-32-characters | 是 |
| TRUST_PROXY | 反向代理部署时信任上游代理头 | false | 否 |
| DEFAULT_LANGUAGE | 通知和看板的默认语言 | en-US | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://planka.app/>
- 文档: <https://docs.linuxserver.io/images/docker-planka/>
- 源码: <https://github.com/linuxserver/docker-planka>
