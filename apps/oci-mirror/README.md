# OCI Mirror

## 产品介绍

OCI Mirror 是一个只读 OCI 拉取缓存和固定源代理。本应用采用上游支持的单机双服务部署：Gateway 负责公网入口、访问策略、配额、缓存和状态，Egress 通过本机真实公网 IPv4 访问 Docker Hub。

## 主要功能

- 为 Docker Hub 提供只读 Registry API、清单与 Blob 缓存。
- 使用独立 Egress 服务和指定的宿主机公网 IPv4 访问上游。
- 提供中国大陆 CIDR、额外放行名单、访客配额和全局并发限制。
- 持久化 SQLite 状态、缓存对象、用量和健康状态。

## 安装前提

本应用不是通用的一键镜像加速器。安装前必须准备：

1. 一个解析到服务器的 Registry 域名；受控测试可以使用服务器 IPv4。
2. 一个真实分配到服务器网卡的公网 IPv4，不能填写 NAT 出口探测值或未绑定地址。
3. 按上游文档生成的中国大陆 IPv4/IPv6 CIDR 文件。应用不会下载或内置可能过期的数据集。
4. 正式对外服务时，准备包含 `server.crt` 和 `server.key` 的目录，证书必须覆盖 Registry 域名。
5. 两个不同且长度为 32-4096 字节的高强度 Token，分别用于管理接口和 Gateway/Egress 通信。

当前包只配置 Docker Hub。GHCR、Quay、GCR、固定下载源、多 Egress、IPv6 出口池、WireGuard 和 mTLS 节点需要按上游部署文档进行专门规划，不应直接修改生成配置后期待面板升级保留。

## 访问说明

- Gateway 使用 host network，直接监听安装表单中的公网端口。
- 管理和 Egress 端口只绑定 `127.0.0.1`，不应对公网开放。
- 为避免依赖安装前已存在的证书文件，表单默认关闭 TLS。正式对外服务应启用 TLS 并填写证书目录；无 TLS 模式仅适用于受控测试，或由宿主机反向代理终止 TLS 且已正确配置客户端身份传递的场景。
- Docker 客户端需要信任 Gateway 证书，并按上游文档配置 Registry Mirror 或显式 Registry 地址。

## Introduction

OCI Mirror is a read-only OCI pull-through cache and fixed-origin proxy. This package deploys the upstream-supported single-host Gateway and Egress topology for Docker Hub.

## Features

- Proxies Docker Hub Registry API requests through a dedicated Egress service.
- Caches manifests and blobs with persistent SQLite state and usage accounting.
- Enforces mainland China CIDR policy, an optional allowlist, quotas, and concurrency limits.
- Supports an explicit Gateway TLS certificate directory for production deployments.

## 持久化与升级

- SQLite、缓存对象和运行状态保存在 `APP_DATA_DIR`。
- 备份时同时保存数据目录、外部 CIDR 文件、TLS 证书/私钥和安装表单参数。
- `init.sh` 与 `upgrade.sh` 会根据表单重新生成 Gateway/Egress 配置；手工修改生成的 `config/*.json` 不属于稳定升级接口。
- 镜像采用固定标签 `moelin/oci-mirror:0.1.2`。当前公开仓库没有可用的 `latest` 标签。

## 安全与网络风险

> **高风险网络权限：Gateway 与 Egress 使用宿主机网络。**

host network 是上游绑定真实出口源地址、回环控制端口及公网 Gateway 监听器的核心要求。应用保留上游的只读根文件系统、非 root UID `65532`、`cap_drop: ALL` 和 `no-new-privileges`，不挂载 Docker Socket，也不启用 privileged 模式。

错误的域名、证书、出口地址、CIDR 或防火墙配置可能导致服务不可用、意外暴露或访问策略失效。正式使用前请完成上游的 Registry API、Docker 客户端、出口源地址和控制平面检查。

## 资料

- 项目：<https://github.com/okxlin/oci-mirror>
- 部署指南：<https://github.com/okxlin/oci-mirror/blob/main/docs/deployment.zh-CN.md>
- CIDR 指南：<https://github.com/okxlin/oci-mirror/blob/main/docs/china-cidr.zh-CN.md>
- 镜像：<https://hub.docker.com/r/moelin/oci-mirror>
