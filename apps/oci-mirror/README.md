# OCI Mirror

## 产品介绍

OCI Mirror 是一个只读 OCI 拉取缓存和固定源代理。Gateway 负责公网入口、访问策略、配额、缓存和调度；Egress 负责从独立出口节点连接 Docker Hub。两种角色使用同一个应用包，但每次安装只启动一个服务，适合分别部署到不同的 1Panel 主机。

## 主要功能

- Gateway 提供只读 Registry API、清单与 Blob 缓存、访问策略和配额。
- Egress 使用指定的宿主机公网 IPv4 访问 Docker Hub。
- 命名节点快照让 Gateway 与独立 Egress 节点保持一致的目标和源地址配置。
- Gateway 持久化 SQLite 状态、缓存对象、用量和健康状态。

## 部署拓扑

```text
Docker 客户端 -> Gateway 节点 -> WireGuard/私网 -> Egress 节点 -> Docker Hub
```

1. 先在入口服务器安装 `Gateway` 角色。
2. 再在出口服务器安装 `Egress` 角色。
3. 两次安装必须使用相同的 Egress 节点 ID 和 Egress Token。
4. Gateway 的 Egress 私网代理 URL 必须指向 Egress 的私网监听 IP 与节点服务端口。
5. Egress 的 Gateway 私网管理 URL 必须指向 Gateway 的管理监听 IP 与端口。

一个 Gateway 可调度多个 Egress，但当前 1Panel 表单每个 Gateway 安装配置一个 Egress 节点。需要多出口节点时，应按上游文档扩展 Gateway 配置并规划独立升级维护流程。

## 访问说明

- Docker 客户端只访问 Gateway 的公网端口，不直接访问 Egress。
- Gateway 管理端口和 Egress 代理端口只应通过可信私网互通。
- Gateway 默认关闭 TLS，仅适合受控测试或由宿主机反向代理终止 TLS 的部署；正式直接对外服务应启用 TLS。
- Docker 客户端需要信任 Gateway 证书，并按上游文档配置 Registry Mirror 或显式 Registry 地址。

## 安装前提

- Gateway 节点需要 Registry 域名、中国大陆 CIDR 文件、持久化目录和管理 Token。
- Egress 节点需要实际分配到该主机的公网 IPv4；该地址同时填写到 Gateway 的 `Egress 公网源 IPv4`。
- 两个节点之间需要 WireGuard、专用网络或其他可信私网。默认 private 模式不提供控制面 TLS，不能直接暴露到公网。
- Gateway 管理监听 IP 和 Egress 监听 IP 必须已分配到各自宿主机；默认示例地址需要按实际网络修改。
- 正式公开 Gateway 时，应启用 TLS 并提供包含 `server.crt` 和 `server.key` 的目录。

## 角色字段

### Gateway

- `Gateway 管理监听 IP`：供 Egress 拉取节点配置快照的私网地址。`127.0.0.1` 仅适合本机测试。
- `Egress 私网代理 URL`：例如 `http://10.66.0.2:8443`。
- `Egress 公网源 IPv4`：实际绑定到远端 Egress 主机的公网源地址。
- `Egress 节点 ID` 与 `Egress 节点 Token`：必须和远端 Egress 安装一致。

### Egress

- `节点服务端口`：Gateway 角色下是公网 Registry 端口，Egress 角色下是私网代理端口。
- `Egress 私网监听 IP`：例如 WireGuard 地址 `10.66.0.2`。
- `Gateway 私网管理 URL`：例如 `http://10.66.0.1:19090`，应用会自动追加节点快照路径。
- `允许的 Gateway IP/CIDR`：限制可连接 Egress 的 Gateway 地址，例如 `10.66.0.1/32`。
- `Egress 节点 ID` 与 `Egress 节点 Token`：必须和 Gateway 安装一致。

## 持久化与升级

- Gateway 的 SQLite、缓存对象、用量和健康状态保存在 `APP_DATA_DIR`。
- Egress 不保存业务数据；Compose 保留相同数据挂载以维持单一服务模板，但 Egress 运行模式不会使用该目录。
- 备份 Gateway 时同时保存数据目录、外部 CIDR 文件、TLS 证书和安装表单参数。
- `init.sh` 与 `upgrade.sh` 会按当前角色和表单重新生成 `config/runtime.json`；手工修改生成配置不属于稳定升级接口。
- 镜像固定为 `moelin/oci-mirror:0.1.2`。

## Introduction

OCI Mirror is a read-only OCI pull-through cache and fixed-origin proxy. This package installs one role per 1Panel instance: Gateway for the public entry, policy, cache, and scheduling, or Egress for outbound Docker Hub access from a separate node.

## Features

- Deploys Gateway and Egress independently on different 1Panel hosts.
- Caches Docker Hub manifests and blobs with persistent Gateway state.
- Distributes node-scoped configuration snapshots from Gateway to Egress.
- Restricts the private control path by listener address, peer CIDR, node ID, and a dedicated bearer token.

## 安全与网络风险

> **高风险网络权限：两个角色都使用宿主机网络。**

host network 是上游绑定真实出口源地址、私网控制地址及 Gateway 公网监听器的核心要求。应用保留上游的只读根文件系统、非 root UID `65532`、`cap_drop: ALL` 和 `no-new-privileges`，不挂载 Docker Socket，也不启用 privileged 模式。

private 模式会校验 Gateway 管理地址、Egress 代理地址和允许的对端网段，但防火墙仍必须只允许两个节点通过可信私网互访。公网跨节点部署应按上游文档改用 mTLS，当前表单不自动配置证书身份。

## 资料

- 项目：<https://github.com/okxlin/oci-mirror>
- 部署指南：<https://github.com/okxlin/oci-mirror/blob/main/docs/deployment.zh-CN.md>
- CIDR 指南：<https://github.com/okxlin/oci-mirror/blob/main/docs/china-cidr.zh-CN.md>
- 镜像：<https://hub.docker.com/r/moelin/oci-mirror>
