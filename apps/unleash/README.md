# Unleash

## 产品介绍

Unleash 是一个开源的功能开关与特性管理平台，可用于解耦代码部署和功能发布、渐进式发布、A/B 实验以及多环境功能配置。

本应用包使用 Unleash 官方容器镜像，并复用 1Panel 管理的 PostgreSQL Runtime。应用 Compose 只包含一个 Unleash 服务，不内置数据库 sidecar。

## 主要功能

- 通过功能开关控制软件功能的启用范围和发布时间
- 管理项目、环境、策略、约束和变体
- 为后端与前端 SDK 提供 API，并记录变更审计事件

## 访问说明

- 选择一个 PostgreSQL 15 或更高版本的 1Panel Runtime；Unleash v8 仅正式测试并支持 PostgreSQL 15+。
- 首次安装时填写管理员用户名和随机强密码。初始管理员只会在空数据库的第一次启动时创建。
- Session Secret 用于签名登录会话，必须保持私密且在升级时保持不变。
- 默认访问地址为 `http://<服务器地址>:<HTTP 端口>`，数据库感知的就绪检查地址为 `/ready`。
- 使用域名或反向代理时，可填写 Public URL；留空时沿用上游默认值 `http://localhost:4242`。

## 数据与升级

- 项目、功能开关、用户和审计数据全部存放在所选的 PostgreSQL Runtime 中；容器本身不保存业务数据。
- Unleash 启动时自动执行数据库迁移。升级前应完整备份 PostgreSQL 数据库，并等待 `/ready` 恢复后再继续操作。
- `latest` 跟随上游稳定镜像；需要可复现部署时请选择固定版本。

## 安全说明

- 本包不使用上游演示 Compose 中的默认管理员密码或不安全示例 API token。
- 安装表单要求填写符合复杂度规则的管理员密码、数据库密码和 Session Secret，包内不预置共享默认值。
- 官方镜像以非 root 的 UID 1000 运行，不需要特权模式、主机网络或 Docker Socket。
- 1Panel 内部 PostgreSQL 连接默认不启用 TLS；如连接远程数据库，请按照上游文档配置 `DATABASE_SSL_*` 参数并重新评估网络信任边界。
- Unleash v8 的开源许可为 AGPL-3.0-or-later，请在部署前确认其与使用场景兼容。

## Introduction

Unleash is an open-source feature management platform for separating code deployment from feature release, progressive delivery, experimentation, and multi-environment configuration.

This package uses the official Unleash image and a selectable 1Panel-managed PostgreSQL Runtime. Its Compose topology contains one Unleash service and no bundled database sidecar.

## Features

- Control feature exposure independently from code deployment
- Manage projects, environments, strategies, constraints, and variants
- Serve backend and frontend SDK APIs with an auditable change history

## Usage and upgrades

- Select PostgreSQL 15 or newer; Unleash v8 officially tests and supports PostgreSQL 15+.
- Supply strong database, administrator, and Session Secret values in the install form and keep them private. The package contains no shared secret defaults; the initial administrator is created only on the first start of an empty database.
- Business data lives in PostgreSQL. Back up that database before upgrades and wait for `/ready` to recover after migrations.
- The image runs as non-root UID 1000 and requires no privileged mode, host network, or Docker Socket.

Sources: `https://github.com/Unleash/unleash`, `https://docs.getunleash.io/deploy/getting-started`, and `https://docs.getunleash.io/deploy/configuring-unleash`.
