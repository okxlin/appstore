# Flipt

## 产品介绍

Flipt 是一个 Git 原生的功能开关管理平台，可通过 Web UI、HTTP API 和 gRPC API 管理与评估功能开关。此应用使用 Flipt 官方镜像，以一个 Flipt service 和本地 Git 存储运行。

## 主要功能

- 在 Web UI 中管理命名空间、功能开关、变体、规则和分群
- 通过 HTTP 与 gRPC API 在应用中评估功能开关
- 将功能开关状态保存为本地 Git 数据，保留可审计的修订历史

## 访问说明

- HTTP/UI 容器端口为 `8080`，安装表单可修改对应主机端口。
- gRPC 容器端口为 `9000`，安装表单可修改对应主机端口。
- 默认安装不启用身份认证。不要把管理界面直接暴露到不受信任的公网；应使用 1Panel 反向代理、访问控制或上游支持的认证配置保护实例。

## 部署拓扑

- 默认包只有一个 Flipt service，不依赖数据库、Redis 或 1Panel Runtime。
- Flipt v2 未显式配置存储时使用易失的 `in-memory` 后端。本包设置 `FLIPT_STORAGE_DEFAULT_BACKEND_TYPE=local`，将功能开关状态持久化到本地 Git 存储。
- 本包关闭上游的版本检查与遥测：`FLIPT_META_CHECK_FOR_UPDATES=false`、`FLIPT_META_TELEMETRY_ENABLED=false`。
- Flipt 可连接外部 Git 仓库并支持更复杂的环境配置，但这些能力不属于当前单机默认包。

## 数据与升级

安装表单选择的数据目录会挂载到 `/var/opt/flipt`，其中：

- `storage` → `/var/opt/flipt/storage`，保存本地 Git 仓库及功能开关状态
- `state` → `/var/opt/flipt/state`，保存实例级状态文件

容器以 UID `100`、GID `1000` 运行。安装和升级脚本会创建上述目录、设置所有者并收紧为 `0700`。升级前请备份完整数据目录。生产环境建议使用固定版本；`latest` 包跟随上游 `v2` 浮动标签，适合明确接受自动获取新 minor/patch 版本的场景。

## 许可证

- Flipt v2 服务端使用 source-available 的 Fair Core License `FCL-1.0-MIT`，不是标准 OSI 开源许可证。
- 许可证允许内部使用、非商业教育与研究等用途，但禁止构成 **Competing Use** 的商业产品或服务。使用者应自行确认用途符合上游条款。
- 每个版本在发布日的 second anniversary 起获得 MIT future license；在对应日期之前，不能把当前服务端版本视为 MIT 软件。
- RPC 客户端代码和 Go SDK 使用 MIT，并不改变当前服务端的 FCL 授权状态。

## 安全扫描快照

维护侧于 2026-07-15 使用 Trivy 0.72.0 扫描固定镜像 `v2.10.0` 与浮动镜像 `v2`；两者当时解析到同一 digest，结果均为 Critical=0、High=6。High 项包括上游二进制依赖中的 Moby、Go 标准库，以及 Alpine OpenSSL 软件包；其中部分已有修复版本，部分扫描时尚无修复版本。该结果是随漏洞库和镜像变化的时间点快照，部署者应持续跟踪上游镜像更新并在生产使用前重新扫描。

## Introduction

Flipt is a Git-native feature flag management platform with a Web UI, HTTP API, and gRPC API. This package runs the official image as one service and explicitly selects persistent local Git storage instead of Flipt v2's default in-memory backend.

The selected data directory is mounted at `/var/opt/flipt`; flag state is stored under `/var/opt/flipt/storage` and instance state under `/var/opt/flipt/state`. Update checks and telemetry are disabled by default. The package does not depend on a database, Redis, or a 1Panel Runtime.

The Flipt v2 server is source-available under `FCL-1.0-MIT`, including a Competing Use restriction and an MIT future license effective on the second anniversary of each version's release. Review the upstream license before deployment.

## Features

- Manage namespaces, feature flags, variants, rules, and segments from the Web UI
- Evaluate flags through HTTP and gRPC APIs
- Persist flag state in a local Git repository with auditable revisions

## 参考资料

- 文档：<https://docs.flipt.io/v2/>
- 配置说明：<https://docs.flipt.io/v2/configuration/overview>
- 许可证说明：<https://docs.flipt.io/v2/licensing>
- 许可证全文：<https://github.com/flipt-io/flipt/blob/v2/LICENSE>
- 源码仓库：<https://github.com/flipt-io/flipt>
- 官方 Docker 用法：<https://github.com/flipt-io/flipt#docker>
