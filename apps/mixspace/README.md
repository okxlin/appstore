# MixSpace

## 产品介绍
MixSpace 是开源自部署的个人博客后端系统，当前 `latest` 和 `13` 版本均基于 PostgreSQL 和 Redis 运行。

## 主要功能
- 提供个人博客、内容管理和 API 服务。
- `latest` 和 `13` 版本使用 PostgreSQL 和 Redis，主服务启动时会自动执行数据库迁移。
- 两个版本使用不同镜像标签，但当前运行时依赖保持一致。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问 MixSpace API；首次部署请按上游文档配置前端和允许访问域名。

## Introduction
MixSpace is an open-source self-hosted backend for personal blogs. The current `latest` and `13` versions run with PostgreSQL and Redis.

## Features
- Provides personal blog, content management, and API services.
- The `latest` and `13` versions use PostgreSQL and Redis; the main service runs database migrations automatically during startup.
- Both versions use different image tags, but their current runtime dependencies are aligned.

## 应用简介
开源自部署个人前后端分离博客系统。

英文说明：Open source self-deployed personal front-end and back-end separation blogging system.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`13`。
- 安装后按应用表单中的端口访问 MixSpace API 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40203 | 是 |

## 数据持久化
- `./data/mx-space:/root/.mx-space`
- `./data/postgres:/var/lib/postgresql/data`
- `./data/redis:/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ALLOWED_ORIGINS | 被允许的域名 (多个使用英文逗号分割) | example.com | 是 |
| JWT_SECRET | JWT 密钥 (16 到 32 位字符) | MxJwtSecret2026ChangeThisValue01 | 是 |
| PG_PASSWORD | PostgreSQL 密码 | MxPostgres2026 | 是 |
| ENCRYPT_KEY | 加密密钥 (非特殊需求不建议填写,终端执行 "openssl rand -hex 32" 获取) | - | 否 |
| ENCRYPT_ENABLE | 是否开启加密 (true或false,开启则需要填写加密密钥) | false | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| SUBNET_PREFIX | 新 docker 网络子网前缀 | 10.250.0 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://mx-space.js.org>
- 文档: <https://mx-space.js.org/docs>
- 源码: <https://github.com/mx-space/core>
