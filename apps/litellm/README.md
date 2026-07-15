# LiteLLM

## 产品介绍

LiteLLM 是一个兼容 OpenAI API 的 AI 网关，可统一接入多种大模型提供商，并提供模型路由、认证、虚拟密钥、预算和用量追踪能力。

## 主要功能

- 通过一个 OpenAI 兼容端点访问多种大模型提供商。
- 在 Admin UI 中管理模型、提供商凭据、虚拟密钥、预算和用量。
- 使用 PostgreSQL 持久化管理数据，并通过独立盐值加密提供商凭据。

## 访问说明

默认 Web 和 API 端口为 `4000`。安装后访问 `http://服务器地址:安装端口/ui` 打开 Admin UI，客户端使用同一地址作为 OpenAI 兼容 API Base URL。

## 部署拓扑

- 应用包只运行一个 LiteLLM service，使用上游为数据库部署发布的 `ghcr.io/berriai/litellm-database` 官方镜像。
- 安装时必须选择同一 1Panel 中已运行的 PostgreSQL Runtime。1Panel 会为本应用创建独立数据库和独立用户，LiteLLM 不复用 PostgreSQL 管理员账号。
- 上游 Docker Compose 还提供 PostgreSQL 和 Prometheus service；本包改为联动 1Panel PostgreSQL Runtime，Prometheus 不属于核心启动依赖，因此不随包部署。
- Redis 仅在多实例部署、跨实例限流、路由状态或共享缓存场景中需要。当前单实例包不包含 Redis。

## 使用说明

安装完成后访问 `http://服务器地址:安装端口/ui`。默认用户名为 `admin`，密码为安装表单中的 `LITELLM_MASTER_KEY`。登录 Admin UI 后，可添加模型及其提供商凭据，并创建虚拟密钥供客户端调用。

本包设置 `STORE_MODEL_IN_DB=True`，模型配置、加密后的提供商凭据、虚拟密钥和用量数据保存在所选 PostgreSQL Runtime 中，不需要挂载 `config.yaml`。数据库连接使用独立的 `DATABASE_*` 环境变量，由 LiteLLM 组装并转义连接串中的用户名和密码。

## 密钥和备份

- `LITELLM_MASTER_KEY` 是代理管理密钥，可以按上游轮换流程更换。
- `LITELLM_SALT_KEY` 用于加密数据库里的提供商凭据。添加模型后不能更改，否则已有凭据无法解密。
- 初始化脚本会把最终密钥分别保存为 `${APP_DATA_DIR}/.litellm-master-key` 和 `${APP_DATA_DIR}/.litellm-salt-key`，权限为 `0600`。升级时优先恢复这两个文件，避免 1Panel 重放原始安装参数导致密钥意外变化。
- 备份或迁移时必须同时保存 PostgreSQL 数据库、`.litellm-master-key` 和 `.litellm-salt-key`。不要把这些文件提交到 Git 或发送给他人。

## 安全与镜像说明

- 固定版本和 `latest` 当前解析到同一官方 OCI 镜像；镜像标签关联的源码 revision 与对应上游 release commit 一致，支持 `amd64` 和 `arm64`。
- 该镜像约 1.09 GB，默认以 `root` 用户运行。Compose 不授予 `privileged`、host network、额外 capability、设备或 Docker Socket。
- Trivy 对固定版本和当前 `latest` 的准入扫描结果为 Critical=0、High=2。两项 High 都来自 Wolfi 的 `python-3.13` / `python-3.13-base`，漏洞编号为 `CVE-2026-11940`；镜像内版本为 `3.13.14-r1`，上游安全包修复版本为 `3.13.14-r2`。升级镜像前请关注新的扫描结果。
- 未授权请求访问受保护的代理 API 会返回 `401`；`/health/liveliness` 用作容器健康检查。

## 许可证

LiteLLM 仓库中 `enterprise/` 目录之外的核心代码采用 MIT 许可证。`enterprise/` 目录采用单独的 BerriAI Enterprise License，生产使用相关企业功能需要有效订阅。本包只引用上游公开镜像，不附带或修改上游源码；使用企业功能前请自行确认许可条件。

## 参考资料

- 官网：<https://www.litellm.ai/>
- Docker 与数据库部署：<https://docs.litellm.ai/docs/proxy/docker_quick_start>
- 生产部署和密钥说明：<https://docs.litellm.ai/docs/proxy/prod>
- 源码：<https://github.com/BerriAI/litellm>

## Introduction

LiteLLM is an OpenAI-compatible AI gateway for routing requests to multiple model providers with centralized authentication, virtual keys, budgets, and usage tracking.

## Features

- One OpenAI-compatible endpoint for multiple model providers.
- Admin UI management for models, provider credentials, virtual keys, budgets, and usage.
- PostgreSQL-backed persistence with a stable, dedicated credential-encryption key.
