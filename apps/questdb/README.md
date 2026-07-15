# QuestDB

## 产品介绍

QuestDB 是一个面向实时分析的开源时序数据库，提供高吞吐写入、低延迟 SQL 查询、Web Console、REST API、InfluxDB Line Protocol 和 PostgreSQL Wire Protocol。

## 主要功能

- 面向时序数据的列式存储、WAL 和分区管理
- Web Console、REST API 与 SQL 查询
- 通过 HTTP 接收 InfluxDB Line Protocol 数据
- 兼容 PostgreSQL Wire Protocol 的查询接口
- 快照、检查点和持久化数据目录

## 访问说明

- Web Console、REST API 和 ILP-over-HTTP 共用默认端口 `9000`。
- PostgreSQL Wire Protocol 默认使用端口 `8812`，数据库名为 `qdb`。
- 本应用默认启用 HTTP Basic 认证和 PGWire 密码认证，两个接口使用独立用户名与密码。
- QuestDB 的 ILP TCP 端口 `9009` 默认不提供简单的用户名/密码保护。本应用为减少未认证写入面，默认关闭且不发布该端口；常见写入场景可直接使用已受 HTTP Basic 保护的 ILP-over-HTTP。
- 内部 `9003` 端口仅用于容器健康检查，不发布到宿主机。健康状态端点不要求业务凭据，其他 HTTP 接口仍受 Basic 认证保护。

## 数据与安全

- QuestDB 的完整数据根目录持久化到安装表单选择的数据目录，其中包含 `db`、`conf`、`public`、快照和检查点等运行数据。
- HTTP 与 PGWire 密码由 1Panel 安装表单随机生成。安装脚本仅把面板值缓存到 `.questdb_http_password` 和 `.questdb_pg_password`，并在升级时恢复原值，避免 1Panel 回放安装参数造成凭据轮换。
- 官方镜像入口以 root 启动，用于检查数据目录属主，然后以 UID/GID `10001:10001` 运行 QuestDB。首次挂载既有数据目录时，上游入口可能调整其已知数据子目录的属主；迁移前应先备份并核对权限。
- Web Console 和协议端口本身不提供 HTTPS。对外访问时应使用 HTTPS 反向代理、限制端口来源，并按需配置网络层 TLS。
- 默认关闭匿名遥测，可在安装表单中按需开启。

## 升级说明

- 升级前停止写入并完整备份数据目录及两个密码缓存文件。
- 固定版与 `latest` 使用相同的数据路径和配置键，可通过 1Panel 执行跨版本升级。
- 数据格式迁移可能在启动阶段完成。生产数据应先在副本环境验证目标版本，并在升级过程中等待健康检查通过后再恢复流量。

## Introduction

QuestDB is an open-source time-series database for high-throughput ingestion and low-latency SQL analytics. This package exposes the authenticated Web/REST/ILP-over-HTTP endpoint and PGWire endpoint, while disabling unauthenticated ILP TCP by default.

Back up the full data directory, `.questdb_http_password` and `.questdb_pg_password` before upgrades. Public deployments should place the Web endpoint behind HTTPS and restrict direct access to the database ports.

## Features

- Column-oriented time-series storage, WAL and partition management
- Web Console, REST API and SQL queries
- Authenticated InfluxDB Line Protocol over HTTP
- PostgreSQL Wire Protocol compatibility
- Persistent checkpoints and snapshots

## 参考资料

- Docker 部署：<https://questdb.com/docs/deployment/docker/>
- 配置选项：<https://questdb.com/docs/configuration/>
- 安全指南：<https://questdb.com/docs/operations/secure/>
- 源码仓库：<https://github.com/questdb/questdb>
- 官方镜像：<https://hub.docker.com/r/questdb/questdb>
