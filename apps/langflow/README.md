# Langflow

## 产品介绍

Langflow 是用于构建和部署 AI 智能体与工作流的可视化平台，提供组件编排、交互式调试、API、Webhook 和 MCP 服务能力。

## 主要功能

- 使用可视化画布组合模型、工具、向量库和数据处理组件。
- 在 Playground 中测试工作流并查看步骤输出。
- 将工作流发布为 API、Webhook 或 MCP 工具。
- 保存自定义组件、项目、文件和运行历史。

## 访问说明

- Web 端口由安装表单设置，默认 `7860`。
- 默认关闭自动登录，使用安装表单生成的管理员用户名和密码登录。
- 将 `LANGFLOW_AUTO_LOGIN` 改为 `true` 会绕过登录页面，只适合受信任的隔离环境。
- 首次启动会创建 SQLite 数据库并执行迁移，大型镜像启动可能需要数分钟。

## 数据持久化

- `APP_DATA_DIR` 挂载到 `/app/langflow`，保存 SQLite 数据库、配置、日志和组件缓存。
- 本适配使用官方支持的单容器 SQLite 模式，不额外捆绑 PostgreSQL 服务。
- 升级前应备份整个数据目录，并阅读上游迁移说明。

## 安全与执行风险

Langflow 可以运行自定义 Python 组件、访问外部 API，并可能保存模型密钥和连接凭据。只向受信任用户开放编辑权限，通过 1Panel 反向代理启用 HTTPS，并谨慎导入第三方工作流或组件。

## Introduction

Langflow is a visual platform for building, testing, and deploying AI agents and workflows with API and MCP endpoints.

## Features

- Compose models, tools, data sources, and vector stores visually.
- Test workflows in an interactive playground.
- Publish workflows as APIs, webhooks, and MCP tools.
- Persist projects, SQLite state, files, logs, and component caches.

## Links

- Website: https://www.langflow.org
- Project: https://github.com/langflow-ai/langflow
- Docker deployment: https://docs.langflow.org/deployment-docker
- Image: https://hub.docker.com/r/langflowai/langflow
