## 产品介绍

Dify 是一个开源 LLM 应用开发平台，提供 Agent、Workflow、RAG、模型接入、插件市场和应用发布能力。

本适配基于 Dify 官方 `docker/docker-compose.yaml` 默认部署路径，包含 PostgreSQL、Redis、Weaviate、Sandbox、SSRF Proxy、Plugin Daemon、API、Worker、Web 和 Nginx 服务。默认通过 Nginx 暴露 Web 入口。

## 主要功能

- 可视化编排 Agent、Workflow 和聊天应用。
- 内置 RAG 知识库、模型供应商接入和应用发布能力。
- 支持插件市场、代码执行沙箱和 SSRF 代理隔离。
- 默认持久化 PostgreSQL、Redis、Weaviate、上传文件和插件数据。

## 访问说明

安装后访问：

```text
http://<服务器 IP>:<HTTP 端口>
```

主要数据默认保存在 `./data` 下，包括应用上传文件、PostgreSQL、Redis、Weaviate、Sandbox 依赖和 Plugin Daemon 数据。高级配置变量保留在版本目录的 `.env.sample` 中；如需覆盖更多 Dify 官方变量，可在安装后创建 `./data/custom.env`，该文件会在容器启动时作为可选 env file 读取。

常用表单项：

- `HTTP 端口`：Dify Web 访问端口。
- `数据目录`：所有持久化数据的宿主机目录。
- `初始化密码`：首次初始化管理员账号时使用。
- `数据库、Redis、Sandbox、Plugin Daemon、Weaviate 密钥`：安装时建议使用随机强密码。

升级前建议备份 `./data` 目录。

## Introduction

Dify is an open-source LLM application development platform for building agents, workflows, RAG applications, model integrations, plugins, and published AI apps.

This package follows Dify's official Docker Compose default deployment path and exposes the web entry through Nginx.

## Features

- Visual agent, workflow, and chat application orchestration.
- Built-in RAG knowledge base, model provider integrations, and app publishing.
- Plugin daemon, code execution sandbox, and SSRF proxy isolation.
- Persistent PostgreSQL, Redis, Weaviate, uploaded files, and plugin data under the configured data directory.
