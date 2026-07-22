# Weblate

## 产品介绍
Weblate 是一个自由开源的网页连续本地化平台，用于翻译软件项目、文档和网站内容。

## 主要功能
- 管理翻译项目、组件和语言
- 支持网页协作翻译、审核和提交
- 支持 Git 集成、机器翻译和通知工作流

## 访问说明
安装后通过 `http://<服务器 IP>:18081` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Weblate is a libre web-based continuous localization platform for translating software projects and documentation.

## Features
- Manage translation projects, components and languages
- Collaborate through a web translation and review interface
- Integrate with Git, machine translation and notification workflows

## 部署说明
- 本应用基于 Weblate 官方 Docker Compose 拆分为 Weblate、PostgreSQL 和 Valkey 三个服务。
- 应用分类：DevOps。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 未启用官方 HTTPS companion compose；如需 HTTPS，建议通过 1Panel 反向代理或外部入口配置。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 18081 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Weblate、PostgreSQL、Valkey 数据和缓存目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| WEBLATE_SITE_TITLE | 站点标题 | Weblate | 是 |
| WEBLATE_SITE_DOMAIN | 站点域名，用于生成站点 URL | localhost | 是 |
| WEBLATE_ALLOWED_HOSTS | 允许访问的 HTTP Host | * | 是 |
| WEBLATE_ADMIN_NAME | 初始管理员名称 | Weblate Admin | 是 |
| WEBLATE_ADMIN_EMAIL | 初始管理员邮箱 | weblate@example.com | 是 |
| WEBLATE_ADMIN_PASSWORD | 初始管理员密码 | 随机生成 | 是 |
| POSTGRES_PASSWORD | PostgreSQL 密码 | 随机生成 | 是 |
| WEBLATE_REGISTRATION_OPEN | 是否开放注册，`1` 为开放，`0` 为关闭 | 1 | 是 |
| WEBLATE_EMAIL_HOST | SMTP 主机 | 127.0.0.1 | 否 |
| WEBLATE_EMAIL_HOST_USER | SMTP 用户 | 空 | 否 |
| WEBLATE_EMAIL_HOST_PASSWORD | SMTP 密码 | 空 | 否 |

## 使用说明
- 首次登录使用安装表单中的 `WEBLATE_ADMIN_EMAIL` 和 `WEBLATE_ADMIN_PASSWORD`。
- 对公网开放前，请把 `WEBLATE_SITE_DOMAIN`、`WEBLATE_ALLOWED_HOSTS`、SMTP 和反向代理设置调整为真实域名。
- 官方文档说明若不设置 `WEBLATE_ADMIN_PASSWORD`，首次启动会在日志中生成随机密码；本应用改为安装表单显式填写，方便 1Panel 用户登录。

## 升级说明
- 升级前使用 `pg_dump` 备份 PostgreSQL 数据库，并在停止应用后备份 `APP_DATA_DIR`。不要把正在运行的数据库目录热复制当作数据库备份。
- 更新 Valkey 前先触发并确认持久化保存完成，再备份 `APP_DATA_DIR/redis`；升级后确认缓存服务健康且 Weblate 可以正常登录。
- 保持 `APP_DATA_DIR`、`POSTGRES_PASSWORD`、站点域名和管理员参数不变。当前升级脚本不会改写这些值，也不会删除持久化数据。
- PostgreSQL 或 Valkey 跨大版本升级需要单独核对官方迁移说明和数据格式，不能按普通镜像补丁直接更新。

## 参考资料
- 官网: <https://weblate.org/>
- 项目仓库: <https://github.com/WeblateOrg/weblate>
- Docker 文档: <https://docs.weblate.org/en/latest/admin/install/docker.html>
- 官方 compose: <https://github.com/WeblateOrg/docker-compose/blob/main/docker-compose.yml>
