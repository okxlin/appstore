# Weaviate

## 产品介绍

Weaviate 是一个开源向量数据库，可保存对象与向量，并通过 HTTP 或 gRPC API 提供相似度搜索、过滤和混合检索能力。

## 主要功能

- 保存自带向量的对象并执行向量、关键词和混合搜索
- 支持集合、属性、过滤条件、聚合和多租户
- 同时提供 HTTP 与 gRPC API
- 可按需接入外部向量化或生成式模型模块

## 访问说明

- HTTP API 默认使用 `8080` 端口，gRPC API 默认使用 `50051` 端口。
- 本应用默认关闭匿名访问，并启用 API Key 认证和 RBAC。调用 HTTP API 时请发送 `Authorization: Bearer <API Key>` 请求头。
- 安装表单中的 API 用户会被设为 RBAC root 用户。请妥善保存随机生成的 API Key，不要把 API 端口直接暴露到不受信任的公网。
- 就绪探针 `/v1/.well-known/ready` 不要求认证；其他 API 仍受认证和授权控制。

## 部署拓扑

- 默认包仅运行一个 Weaviate service，不依赖 1Panel 数据库、Redis 或网站 Runtime。
- 上游 Compose 中的模型推理容器属于可选模块。本包默认使用 `DEFAULT_VECTORIZER_MODULE=none` 并禁用基于 API 的模块，调用方需要在写入对象时自行提供向量。
- 如需接入文本向量化、重排序或生成式模型，应根据对应模块的官方文档单独设计和验证，不应直接复用本包的默认单节点结论。

## 数据与升级

- 数据持久化在安装表单选择的目录中，并挂载到容器 `/var/lib/weaviate`。
- 默认配置为单节点部署。升级前请备份完整数据目录并阅读目标版本迁移说明。
- `latest` 可能先于 GitHub 的公开稳定 Release 更新；生产环境建议优先使用固定版本，经验证后再升级。

## Introduction

Weaviate is an open-source vector database for storing objects and vectors and serving semantic, keyword, and hybrid search through HTTP and gRPC APIs. This package runs a secured single-node instance with API-key authentication, RBAC, telemetry disabled, and persistent local storage.

## Features

- Vector, keyword, and hybrid search through HTTP and gRPC APIs
- API-key authentication and RBAC enabled by default
- Persistent single-node storage with telemetry disabled
- No bundled inference service or required 1Panel service dependency

The default package does not bundle model inference services. Clients provide vectors when writing objects. Back up the complete data directory and review the target release's migration notes before upgrading.

## 参考资料

- Docker Compose 安装：<https://docs.weaviate.io/deploy/installation-guides/docker-installation>
- 认证配置：<https://docs.weaviate.io/deploy/configuration/authentication>
- 授权配置：<https://docs.weaviate.io/deploy/configuration/authorization>
- 环境变量：<https://docs.weaviate.io/deploy/configuration/env-vars>
- 源码仓库：<https://github.com/weaviate/weaviate>
- 官方镜像：<https://hub.docker.com/r/semitechnologies/weaviate>
