# Dragonfly

## 产品介绍

Dragonfly 是面向现代应用负载的高性能内存数据存储，兼容 Redis 与 Memcached API。本应用使用官方镜像，以一个 Dragonfly service 提供 Redis/HTTP 端口，并将快照持久化到本地目录。

## 主要功能

- 通过 Redis 协议提供缓存、键值数据与常用数据结构能力
- 使用多线程架构扩展单实例吞吐量
- 通过定时快照和手动 `BGSAVE` 将数据写入磁盘

## 访问说明

- 容器的 Redis/HTTP 混合端口为 `6379`，安装表单可修改对应主机端口。
- 本包强制用户设置至少 16 个字符的密码，并通过 `DFLY_requirepass` 启用认证；未认证客户端会收到 `NOAUTH`。
- HTTP 指标端点为 `/metrics`，健康端点为 `/healthz`；这两个端点无需 Redis 密码即可访问，可能暴露运行指标。真实 1Panel 验证同时覆盖了 Redis 认证访问与 `/metrics` HTTP 访问。
- Dragonfly 不提供面向最终用户的管理 Web UI。不要将端口直接暴露到不受信任的公网，应使用防火墙或可信网络限制访问。

## 部署拓扑与 Runtime

- 默认包只有一个 Dragonfly service，不依赖数据库、Redis 容器或其他 service。
- Dragonfly 本身实现 Redis 兼容协议，但不是 1Panel 官方 Redis **Runtime**，本包不联动也不注册为 1Panel Runtime。其他应用只有在明确支持自定义 Redis 主机时才能连接本实例。
- 本包不使用特权模式、主机网络、额外 Linux capability 或 Docker socket。

## 资源参数

默认设置为 `1gb` 最大内存和 2 个工作线程。Dragonfly v1.39.0 启动时按每个线程约 256 MiB 检查最低内存；提高线程数时必须同步提高最大内存，否则容器会拒绝启动。实际运行还需要为进程、快照和操作系统保留额外内存，生产部署前应按数据集和并发量压测。

## 数据、快照与升级

安装表单选择的数据目录会挂载到 `/data`。安装和升级脚本创建该目录、设置为容器用户 UID/GID `999:999`，并将目录权限收紧为 `0700`；生成的 DFS 快照默认权限为 `0600`。默认 cron 表达式 `*/5 * * * *` 每五分钟创建快照，也可以通过 Redis 客户端执行 `BGSAVE` 立即创建快照。

升级前请确认快照成功并备份整个数据目录。生产环境建议使用固定版本；`latest` 包跟随上游浮动标签，仅适合明确接受镜像内容变化并在升级前重新验证的场景。

## 许可证

- Dragonfly 服务端采用 Business Source License 1.1，SPDX 标识为 `BUSL-1.1`；它是 source-available 软件，不是 OSI 批准的开源软件。
- Additional Use Grant 禁止把本软件作为 **Service** 提供，即不得以允许第三方访问其功能的商业托管或托管式服务方式，与许可方产品或服务竞争；其他生产用途也必须满足许可证全文。
- Change Date 为 **July 1, 2030**。每个具体版本会在该日期或首次公开发布满四周年（以较早者为准）转为 **Apache-2.0**。
- 本说明不是法律意见。部署者应根据自身使用方式审阅上游许可证，必要时向许可方取得商业授权。

## 安全扫描快照

维护侧于 2026-07-15 使用 Trivy 0.72.0 扫描固定镜像 `v1.39.0` 与浮动镜像 `latest`；两者当时解析到同一 digest，结果均为 Critical=0、High=4。High 项为 Ubuntu 软件包中的 Lua/lua-bitop 漏洞，以及 OpenSSL `CVE-2026-45447`；扫描时 OpenSSL 项已有上游修复包版本，Lua 项尚未给出修复版本。该结果是随漏洞库与镜像变化的时间点快照，生产部署前应重新扫描并持续跟踪上游镜像更新。

## Introduction

Dragonfly is a high-performance in-memory data store compatible with the Redis and Memcached APIs. This package runs the official image as one service, requires password authentication, and persists DFS snapshots under `/data`. It does not depend on another database, Redis service, or 1Panel Runtime.

The default resource settings are 1 GiB of maximum memory and two worker threads. Dragonfly v1.39.0 requires roughly 256 MiB per thread at startup, so memory must be increased when raising the thread count. Back up the data directory and verify a recent snapshot before upgrades.

Dragonfly is source-available under `BUSL-1.1`, including restrictions on offering the software as a hosted or managed Service. The license changes to Apache-2.0 on July 1, 2030 or the fourth anniversary of a specific version's first public distribution, whichever comes first. Review the upstream license before use.

## Features

- Serve common key/value and data-structure operations through the Redis protocol
- Scale a single instance across multiple worker threads
- Persist data with scheduled snapshots or an explicit `BGSAVE`

## 参考资料

- 文档：<https://www.dragonflydb.io/docs/>
- 配置参数：<https://www.dragonflydb.io/docs/managing-dragonfly/flags>
- 持久化：<https://www.dragonflydb.io/docs/managing-dragonfly/backups>
- 许可证全文：<https://github.com/dragonflydb/dragonfly/blob/main/LICENSE.md>
- 源码仓库：<https://github.com/dragonflydb/dragonfly>
- v1.39.0 发布：<https://github.com/dragonflydb/dragonfly/releases/tag/v1.39.0>
