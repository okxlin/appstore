# Directus

## 产品介绍

Directus 是一个无头数据平台，可连接数据库并自动提供 REST、GraphQL、WebSocket API 以及可视化数据管理界面。本应用使用 Directus 官方镜像，以单个 Directus service 和 SQLite 数据库运行。

## 主要功能

- 连接 SQLite 数据库并自动提供 REST、GraphQL 和 WebSocket API
- 使用 Directus Studio 管理数据模型、内容、文件、权限和自动化流程
- 保存本地上传文件并加载自定义扩展

## 访问说明

- 默认容器端口为 `8055`，安装表单可修改主机端口。
- 安装时会使用表单中的管理员邮箱和强密码创建初始管理员；管理员密码由用户输入，并由 1Panel 复杂度规则校验。
- `SECRET` 用于签名访问令牌。该值由 1Panel 安装表单随机生成，安装脚本会缓存到数据目录下的 `.directus-secret`，并在升级时恢复原值。迁移时必须连同该文件保留同一个值，否则已有会话和令牌可能失效。
- `PUBLIC_URL` 可留空，此时 Directus 使用默认相对地址 `/`。如需邮件链接、OAuth、SSO 或许可证激活，请填写实际可访问的绝对 URL，例如 `https://directus.example.com`。

## 部署拓扑

- 默认包只有一个 Directus service，不依赖 1Panel 数据库、Redis 或网站 Runtime。
- 数据库使用 SQLite，数据库文件为 `/directus/database/data.db`。
- Directus 官方 Quickstart 提供了相同的单服务 SQLite 拓扑，但明确说明其示例不是 production-ready。本包补充了随机密钥、初始管理员、持久化、健康检查并关闭默认遥测，仍定位于单节点和中小规模自托管。
- 较大生产环境或横向扩展应使用 PostgreSQL、MySQL 或 MariaDB；Redis 对缓存是推荐项，对多副本横向扩展是必需项。这些依赖适合后续通过 1Panel service selector 联动，但不属于当前默认包。不要仅修改现有 SQLite 实例的环境变量来切换数据库。

## 数据与升级

安装表单选择的数据目录包含以下持久化子目录：

- `database` → `/directus/database`
- `uploads` → `/directus/uploads`
- `extensions` → `/directus/extensions`
- `.directus-secret` → 升级时用于恢复令牌签名密钥的隐藏文件

容器以 UID/GID `1000:1000` 运行，安装脚本只负责创建三个数据子目录并设置对应所有者。升级前请备份完整数据目录（包括 `.directus-secret`），并阅读目标版本的 breaking changes。Directus 会在启动时自动执行数据库迁移；迁移完成前不要中断容器。生产环境建议使用固定版本，`latest` 仅适合明确接受浮动更新的场景。

## 许可证与遥测

- Directus v12 使用 source-available 的 `MSCL-1.0-GPL`（Monospace Sustainable Core License 1.0），不是标准 OSI 开源许可证。
- 许可证禁止将软件用于与许可方商业 Directus 产品竞争的 **Competing Use**；使用者必须自行确认用途符合上游许可条款。
- 未配置许可证时实例运行在免费 `core tier`。更高限制或附加能力需要许可证；符合条件的组织可申请 Open Innovation Grant。
- 本包设置 `TELEMETRY=false` 和 `PROJECT_OWNER_ENABLED=false`。某些许可证权益可能要求遥测保持启用，上游授权规则优先。
- 若曾激活许可证，删除实例或清除数据库前应先在 Directus 中停用许可证，避免遗留占用激活名额。

## Introduction

Directus is a headless data platform that provides REST, GraphQL, and WebSocket APIs plus a data studio on top of a database. This package uses the official image in a single-service SQLite topology for single-node and small-to-medium self-hosted deployments.

The package persists `/directus/database`, `/directus/uploads`, and `/directus/extensions`, creates the initial administrator from installation fields, caches the panel-generated token-signing secret in `.directus-secret`, and probes `/server/ping`. Larger or horizontally scaled deployments should use an external PostgreSQL/MySQL/MariaDB service and Redis where required.

Directus 12 is source-available under `MSCL-1.0-GPL`. Review the upstream license, including the Competing Use restriction and core-tier entitlements, before deployment.

## Features

- REST, GraphQL, and WebSocket APIs generated from the persisted SQLite database
- Directus Studio for schema, content, file, permission, and flow management
- Persistent local uploads and extension loading

## 参考资料

- Docker Compose Quickstart：<https://directus.io/docs/getting-started/create-a-project>
- 自托管部署：<https://directus.io/docs/self-hosting/deploying>
- 数据库配置：<https://directus.io/docs/configuration/database>
- 升级说明：<https://directus.io/docs/self-hosting/upgrading>
- 许可证说明：<https://directus.io/docs/licensing/overview>
- 许可证全文：<https://directus.com/license>
- 源码仓库：<https://github.com/directus/directus>
- 官方镜像：<https://hub.docker.com/r/directus/directus>
