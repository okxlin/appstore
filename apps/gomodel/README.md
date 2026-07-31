# GoModel

## 产品介绍

GoModel 是一个轻量级多模型 AI 网关，为 OpenAI、Anthropic、Gemini、DeepSeek、Ollama 等模型提供统一的 OpenAI 兼容接口，并内置用量统计、审计日志、预算、限流、故障转移和管理面板。

本应用使用官方非 root 镜像和内置 SQLite 存储。默认安装只运行 GoModel 单服务，不附带上游开发 Compose 中可选的 Redis、PostgreSQL、MongoDB、Adminer 或 Prometheus。

## 主要功能

- OpenAI 与 Anthropic 兼容 API
- 多模型提供商、虚拟模型和故障转移
- API 密钥、预算、限流和访问范围管理
- 用量、成本和审计记录查询
- 内置管理面板与提供商配置界面

## 访问说明

- 管理面板：`http://服务器地址:安装端口/admin/dashboard`
- API 地址：`http://服务器地址:安装端口/v1`
- 主密钥：安装表单中的随机主密钥

管理面板的页面外壳可直接加载，但所有管理数据和写操作都要求主密钥。首次访问后，在 Providers 页面添加模型提供商及其凭据，再使用 `Authorization: Bearer <主密钥>` 调用 API。请勿把主密钥或模型提供商密钥写入脚本、日志或公开配置。

## 安全边界

容器以官方 UID/GID `65532:65532` 运行，根文件系统只读，删除全部 Linux capabilities，并启用 `no-new-privileges`。SQLite 数据仅写入 `/app/data`；模型清单缓存位于受限的临时文件系统。

本包默认启用审计与用量统计，但关闭请求/响应正文和请求头记录，避免提示词、响应和凭据进入持久化日志。需要正文级调试时，应先评估数据敏感性并限定保留时间。

镜像扫描会报告 `golang.org/x/crypto/openpgp` 的一个 UNKNOWN 级通用模块提示。固定源码显示 GoModel 仅在可选 MongoDB 审计路径通过 PKCS#8/PBKDF2 使用 `x/crypto`，没有导入或链接 OpenPGP 包；默认 SQLite 拓扑也不启用该路径。

## 数据与升级

`APP_DATA_DIR` 默认是版本目录内的 `./data`，挂载到 `/app/data` 并保存 SQLite 数据库、提供商配置、API 密钥元数据、审计日志和用量记录。初始化脚本拒绝目录外路径和符号链接，并将目录设置给 UID/GID `65532:65532`。

卸载不会删除该绑定目录。升级或迁移前应备份整个数据目录和应用 `.env`；主密钥必须保持不变，否则现有客户端将无法认证。

`latest` 跟随上游移动标签；需要可重复部署时请选择商店中提供的固定版本。

## Introduction

GoModel is a lightweight multi-provider AI gateway. It exposes OpenAI- and Anthropic-compatible APIs for providers such as OpenAI, Anthropic, Gemini, DeepSeek, and Ollama, with built-in usage tracking, audit logs, budgets, rate limits, failover, and an administration dashboard.

This package uses the official non-root image with embedded SQLite storage. Optional Redis, PostgreSQL, MongoDB, Adminer, and Prometheus services from the upstream development Compose stack are intentionally excluded.

## Features

- OpenAI- and Anthropic-compatible APIs
- Multiple providers, virtual models, and failover
- Managed API keys, budgets, rate limits, and access scopes
- Usage, cost, and audit reporting
- Built-in dashboard and provider credential management

Open `/admin/dashboard` on the installed port, authenticate management requests with the generated master key, and add provider credentials from the Providers page. Model API requests use the same master key in an `Authorization: Bearer` header unless you create a managed key. Never place the master key or provider credentials in scripts, logs, or public configuration.

The container runs as UID/GID `65532:65532` with a read-only root filesystem, all Linux capabilities dropped, and `no-new-privileges` enabled. Persistent SQLite state is restricted to `/app/data`; the model-list cache is ephemeral. Audit and usage tracking remain enabled, while request/response bodies and request headers are not persisted by default.

The image scan reports one UNKNOWN module-level notice for `golang.org/x/crypto/openpgp`. Fixed-source inspection shows no OpenPGP import or linkage; GoModel reaches `x/crypto` through PKCS#8/PBKDF2 in the optional MongoDB audit path, which is not enabled by this SQLite package.

`APP_DATA_DIR` defaults to `./data` inside the version directory and stores provider configuration, managed-key metadata, audit entries, usage records, and other SQLite state. Uninstall preserves this bind-mounted directory. Back up both it and the application `.env` before upgrades, and keep the master key stable.

Use the fixed version offered by the store for reproducible deployments; `latest` follows the upstream moving tag.

## References

- Website: <https://gomodel.enterpilot.io/>
- Documentation: <https://gomodel.enterpilot.io/docs/getting-started/quickstart>
- Source: <https://github.com/ENTERPILOT/GoModel>
- Official image: <https://hub.docker.com/r/enterpilot/gomodel>
