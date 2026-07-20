# OCI Mirror

## 产品介绍

OCI Mirror 是一个只读 OCI 拉取缓存和固定源代理。Gateway 负责公网入口、访问策略、配额、缓存和调度；Egress 负责从独立出口节点连接 Docker Hub。同一个应用包可分别安装为 Gateway 或 Egress，默认使用 mTLS 保护公网节点间通信。

## 主要功能

- Gateway 提供只读 Registry API、清单与 Blob 缓存、访问策略和配额。
- Egress 使用指定的宿主机公网 IPv4/IPv6 地址池访问 Docker Hub。
- 命名节点快照让 Gateway 与独立 Egress 节点保持一致的目标和源地址配置。
- Gateway 持久化 SQLite 状态、缓存对象、用量和健康状态。
- 初始化脚本可生成节点 CA、Gateway 身份和多个 Egress 证书包，并保留已有证书。
- Gateway 安装时可从 APNIC 官方数据自动生成中国大陆 IPv4/IPv6 CIDR 文件。

## 访问说明

```text
Docker 客户端 -> Gateway 公网 TLS -> Egress 公网 mTLS -> Docker Hub
                                ^
                                └── Egress 通过 Gateway 公网 TLS 拉取节点快照
```

1. 先在入口服务器安装 `Gateway` 角色。
2. Gateway 初始化后，把 `OCI_MIRROR_PKI_DIR/egress/<节点 ID>/` 证书包通过可信管理通道复制到远端 Egress 的相同目录结构。
3. 再安装 `Egress` 角色；两次安装必须使用相同的 Gateway 身份 ID、Egress 节点 ID 和 Egress Token。
4. Gateway 的 `Egress 代理 URL` 填 Egress 的公网 HTTPS 地址，例如 `https://egress.example.com:8443`。
5. Egress 的 `Gateway 快照 URL` 填 Gateway 的公网 HTTPS 地址，例如 `https://mirror.example.com:8443`。mTLS 模式不使用 Gateway 私有管理端口拉取快照。
6. `Egress 公网源地址` 填写已分配或路由到 Egress 主机的具体公网 IPv4/IPv6 地址，多个地址使用英文逗号分隔。Gateway 使用它生成出口池；受 1Panel 单表单无条件必填的限制，安装 Egress 角色时也需填写，但 Egress 运行配置不会直接使用它。

应用不限制同一主机的安装数量。Gateway 与 Egress 可以安装在同一主机，但必须使用不同服务端口；由于 1Panel 会把所有 `paramPort` 表单值都纳入端口占用检查，两次安装还必须填写不同的 `Gateway 管理端口` 占位值，即使 Egress 不使用该端口。需要共享自动生成的证书时，两次安装应填写同一个绝对 `OCI_MIRROR_PKI_DIR`。相对路径按各自应用安装目录解析，不会自动共享。

## 出口地址池

- 地址清单支持仅 IPv4、仅 IPv6 或双栈，最多 256 个具体地址；不能填写 CIDR、接口 zone 或 IPv4-mapped IPv6。
- 多个 IPv4 地址必须唯一；用于轮换的 IPv6 地址必须来自不同的 `/64`。地址必须先由服务商路由到 Egress 主机并在主机上配置。
- Egress 严格按目标地址族选择源地址：IPv4 目标只使用 IPv4 源，IPv6 目标只使用 IPv6 源，不会跨地址族回落。
- 仅 IPv6 部署还需确认 Docker Hub Registry、认证服务和重定向目标均能在实际网络中解析 AAAA 记录并连通。

## mTLS 证书

- `Egress mTLS 证书清单` 使用逗号分隔的 `节点ID=DNS或IP`，例如 `egress-a=egress-a.example.com,egress-b=203.0.113.20`，最多 32 个节点。
- 增加清单项只创建缺失的证书；减少清单项不会删除旧目录；修改已有节点的 DNS/IP 会失败而不是覆盖私钥和证书。
- CA 私钥仅保存在 `OCI_MIRROR_PKI_DIR/authority/`，不会复制进容器配置。远端 Egress 只需要自己的 `egress/<节点 ID>/` 目录，不能复制 `authority/nodes-ca.key`。
- Gateway 留空 `Gateway TLS 源目录` 时会生成覆盖 `Registry 主机名` 的服务证书。该证书由节点 CA 签发，Docker 客户端需要信任 `authority/nodes-ca.crt`；也可以提供受公网 CA 信任的 `server.crt` 和 `server.key`。
- 当前 Gateway 运行配置只启用表单选择的一个 Egress 节点；额外证书包用于后续节点部署，不会自动扩展 Gateway 的节点调度配置。

## CIDR 数据

- `中国大陆 CIDR 文件` 留空时，Gateway 首次初始化会下载 APNIC delegated 数据并生成 `OCI_MIRROR_DATA_DIR/china-mainland.cidr`。
- 已存在且非空的 CIDR 文件会原样保留，不会在升级或重新初始化时自动覆盖。
- 自动生成需要安装主机能够通过 HTTPS 访问 APNIC；离线环境应预先提供经过验证的 IPv4/IPv6 CIDR 文件。
- APNIC 自动数据的来源和更新日期由初始化脚本生成，不在 1Panel 安装表单中重复询问。单独使用 Compose 时可在 `.env` 中覆盖这两项元数据。

## 私网模式

WireGuard 或可信内网部署可把传输模式改为 `private`。此时 `Egress 代理 URL` 和 `Gateway 快照 URL` 必须使用私有地址的 `http://` URL，Egress 监听 IP 必须是私有或回环 IPv4，`Gateway IP/CIDR 限制`必须填写 Gateway 的私网地址段。private 模式不能把 Bearer Token 当作公网传输保护。

## 持久化与升级

- Gateway 的 SQLite、缓存对象、用量和健康状态保存在 `OCI_MIRROR_DATA_DIR` 宿主机目录。
- Egress 不保存业务数据；Compose 保留相同数据挂载以维持单一服务模板，但 Egress 运行模式不会使用该目录。
- 备份 Gateway 时同时保存数据目录、CIDR 文件、TLS/mTLS 证书和安装表单参数。不要在 Gateway 运行时单独复制或删除 SQLite WAL 文件。
- `init.sh` 与 `upgrade.sh` 会按当前角色和表单重新生成 `config/runtime.json`；手工修改生成配置不属于稳定升级接口。

## 安全与部署风险

> **高风险网络权限：Gateway 和 Egress 都使用宿主机网络。**

host network 是上游绑定真实出口源地址、私网控制地址及 Gateway 公网监听器的核心要求，不能移除。应用保留只读根文件系统、非 root UID `65532`、`cap_drop: ALL` 和 `no-new-privileges`，不挂载 Docker Socket，也不启用 privileged 模式。商店包固定使用 `/tmp` 工作目录，因为上游程序拒绝把持久化状态目录作为进程工作目录；上游 Compose 的 `pids_limit` 与 1Panel 自动注入的资源限制冲突，因此商店包不重复声明该字段。

Gateway 管理 Token 与每个 Egress Token 必须互不相同，长度为 32-4096 字节，仅允许 `A-Z a-z 0-9 . _ ~ + / -`，`=` 只能作为末尾填充。可用 `openssl rand -base64 48 | tr -d '\n'` 分别生成。Gateway 管理监听器默认绑定 `127.0.0.1`；公网 mTLS 节点通过 Gateway 公网监听器的受证书保护快照路径通信，不应把私有管理端口暴露到公网。

## Introduction

OCI Mirror is a read-only OCI pull-through cache and fixed-origin proxy. Each 1Panel installation runs one Gateway or Egress role. Public inter-node communication defaults to mutually authenticated TLS.

## Features

- Deploys Gateway and Egress independently on different 1Panel hosts.
- Caches Docker Hub manifests and blobs with persistent Gateway state.
- Distributes node-scoped configuration snapshots from Gateway to Egress.
- Supports IPv4-only, IPv6-only, and dual-stack Egress source pools.
- Generates an idempotent node CA, Gateway identity, and bounded Egress certificate inventory.
- Generates the mainland-China IPv4/IPv6 CIDR file from official APNIC delegated data when no file exists.

## Security and Deployment Risks

> **High-risk network permission: both roles use host networking.**

Host networking is required to bind real outbound source addresses, private control addresses, and the public Gateway listener. It cannot be removed without breaking core behavior. The package keeps a read-only root filesystem, UID `65532`, `cap_drop: ALL`, and `no-new-privileges`; it uses `/tmp` as the process working directory because the upstream binary rejects a state directory used as its working directory. The upstream `pids_limit` is omitted because it conflicts with resource limits injected by 1Panel. The package does not mount the container-engine socket or use privileged mode.

The generated node CA private key remains outside the container under the configured PKI directory. Transfer only the selected Egress bundle to a remote node. Public deployments must use HTTPS and mTLS; the optional peer CIDR is an additional filter, not a replacement for certificate authentication.

## 资料

- 项目：<https://github.com/okxlin/oci-mirror>
- 部署指南：<https://github.com/okxlin/oci-mirror/blob/main/docs/deployment.zh-CN.md>
- CIDR 指南：<https://github.com/okxlin/oci-mirror/blob/main/docs/china-cidr.zh-CN.md>
- 镜像：<https://hub.docker.com/r/moelin/oci-mirror>
