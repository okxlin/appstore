# HashiCorp Vault

## 产品介绍

HashiCorp Vault 用于集中存储机密信息、签发动态凭据并按策略控制访问。本应用使用官方 Community 镜像，以单节点集成 Raft 存储运行完整 Vault 服务和 Web UI，不使用仅供开发的 `server -dev` 模式。

## 主要功能

- 通过策略控制对静态机密、动态凭据、证书和加密服务的访问。
- 使用集成 Raft 存储保存加密状态，无需外部数据库。
- 通过 Web UI 完成初始化、解封、认证和机密读写。
- 使用官方多架构 Community 镜像，支持 `amd64` 和 `arm64`。

## 访问说明

1Panel 应用入口会打开 Vault Web UI；也可以在应用地址后添加 `/ui/`。容器内部只提供 HTTP，应使用 1Panel 反向代理配置 HTTPS 后再从不可信网络访问。

## 首次使用

1. 通过 1Panel 打开应用后访问 `/ui/`。
2. 选择初始化新的 Raft 集群。生产环境通常应将根密钥拆分为多份，例如 5 份中至少 3 份才能解封。
3. 立即下载并离线安全保存全部解封密钥和初始 root token。丢失达到阈值的密钥后，数据无法恢复。
4. 按页面提示依次提交达到阈值数量的密钥，完成解封后使用初始 root token 登录。
5. 登录后应尽快配置最小权限策略和正式认证方法，不要长期使用 root token 处理日常操作。

本包采用 Shamir seal。Vault 初始化后，每次容器重启都会重新进入 sealed 状态；这是 Vault 的安全设计，不是启动故障。请再次通过 `/ui/` 提交达到阈值数量的解封密钥。需要无人值守自动解封时，应另行配置受支持的 KMS、HSM 或 Transit seal；本单节点包不会替用户保存解封密钥。

## 安全、持久化与备份

- 容器内部监听 HTTP。不要把管理端口直接暴露到不可信网络；应通过 1Panel 反向代理配置 HTTPS，并限制管理入口访问。
- Raft 数据保存在所选数据目录的 `file` 子目录；`logs` 子目录预留给按需启用的文件审计设备。启用后两者均包含敏感信息，备份和迁移时必须加密并严格控制访问。
- 集成 Raft 按官方建议启用 `disable_mlock`，因此本包不申请 `IPC_LOCK` capability；宿主机应禁用或妥善保护交换空间。
- 在线备份应在 Vault 已解封时使用官方 `vault operator raft snapshot save` 流程。不要把运行中的 Raft 数据目录热复制当作一致性备份。
- 这是单节点部署，不提供高可用性。应用级 `limit` 为 1，固定节点标识不可用于拼装多节点集群。

## 升级说明

`2.0.3` 与创建本包时的 `latest` 指向同一镜像 digest。升级前仍应创建 Raft 快照并保留整个数据目录；后续 `latest` 发生变化时，应先阅读 HashiCorp 的升级说明。升级或重启后 Vault 会保持已初始化数据，但需要重新解封。

## Introduction

HashiCorp Vault centrally stores secrets, issues dynamic credentials, and controls access with policies. This package runs the official Community image as a complete single-node server with integrated Raft storage and the Web UI. It never uses the image's development-mode default.

## Features

- Control access to static secrets, dynamic credentials, certificates, and encryption services with policies.
- Persist encrypted state in integrated Raft storage without an external database.
- Initialize, unseal, authenticate, and manage secrets through the Web UI.
- Run the official multi-architecture Community image on `amd64` and `arm64`.

Open `/ui/` after installation, initialize a new Raft cluster, securely save every unseal key and the initial root token, and submit the configured threshold of key shares to unseal Vault. With the included Shamir seal, every restart seals Vault again by design. Unseal it through the UI; this package never stores your unseal keys. Use a supported KMS, HSM, or Transit seal in a separately managed deployment if unattended auto-unseal is required.

The container listens over HTTP. Put it behind an HTTPS 1Panel reverse proxy and restrict access to the administration endpoint. Raft state is stored under `file`; `logs` is reserved for a file audit device when one is enabled. Protect and encrypt backups of both directories when they contain data. Take consistent online backups with `vault operator raft snapshot save` while Vault is unsealed. This package is a single-node deployment and is not an HA cluster.

## 参考资料

- 官网：<https://www.hashicorp.com/en/products/vault>
- 文档：<https://developer.hashicorp.com/vault/docs>
- Raft 存储：<https://developer.hashicorp.com/vault/docs/configuration/storage/raft>
- Seal 与解封：<https://developer.hashicorp.com/vault/docs/concepts/seal>
- 官方镜像：<https://hub.docker.com/r/hashicorp/vault>
- 源码：<https://github.com/hashicorp/vault>
