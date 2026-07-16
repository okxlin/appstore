# Appsmith

## 产品介绍

Appsmith 是一个开源低代码平台，可通过拖放式编辑器、JavaScript 和数据源连接构建内部工具、管理后台与业务应用。

## 主要功能

- 使用可视化组件和 JavaScript 构建交互界面。
- 连接数据库、REST/GraphQL API 和 SaaS 数据源。
- 管理用户、工作区、应用和访问权限。
- 使用官方 Community Edition 一体化镜像，支持 `amd64` 和 `arm64`。

## 访问说明

该应用使用 Appsmith 官方一体化容器。MongoDB、Redis 和 PostgreSQL 由容器内部的 Supervisor 管理，所有需要持久化的配置、数据库和应用数据都保存在 `/appsmith-stacks`，并映射到安装目录下的 `data` 文件夹。

上游建议主机至少提供 8 GB 内存。首次启动通常需要数分钟；镜像自带健康检查不会可靠确认后端状态，部署时应以 `/api/v1/health` 返回成功作为后端就绪信号。访问 1Panel 显示的 Web 端口后，请在浏览器中创建首个实例管理员。

默认禁用遥测。规范访问地址可以留空，但密码重置、邮件验证和邀请等包含令牌的邮件流程会保持禁用；启用邮件功能前，应将“规范访问地址”设置为用户实际访问 Appsmith 的完整 URL，例如 `https://appsmith.example.com`。

`data/configuration/docker.env` 含有数据库与加密相关密钥。备份或迁移时应完整保存 `data` 目录并妥善保护该文件，不要只复制数据库文件。

## Introduction

Appsmith is an open-source low-code platform for building internal tools and business applications with a visual editor, JavaScript, and data-source integrations.

## Features

- Build interactive interfaces with visual components and JavaScript.
- Connect databases, REST/GraphQL APIs, and SaaS data sources.
- Manage users, workspaces, applications, and access permissions.
- Run the official multi-architecture Community Edition image.

This package uses Appsmith's official Community Edition all-in-one image. The embedded MongoDB, Redis, and PostgreSQL services store their durable state under `/appsmith-stacks`, mapped to the package's `data` directory. Upstream recommends at least 8 GB of memory. The image health check does not reliably establish backend readiness; use a successful `/api/v1/health` response as the backend-ready signal.

Telemetry is disabled by default. The canonical base URL may be left empty, but token-bearing email flows remain disabled until it is set to the complete public URL used to access the instance. Protect and back up the whole data directory, especially `data/configuration/docker.env`, because it contains encryption and database secrets.

## 参考资料

- 官网：<https://www.appsmith.com/>
- 文档：<https://docs.appsmith.com/getting-started/setup/installation-guides/docker>
- 源码：<https://github.com/appsmithorg/appsmith>
- 官方 Docker 说明：<https://github.com/appsmithorg/appsmith/blob/v2.2/deploy/docker/README.md>
