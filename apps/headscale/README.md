# Headscale

## 应用简介
Tailscale 控制服务器的开源自托管实现。

英文说明：An open source, self-hosted implementation of the Tailscale control server.

## 产品介绍
Headscale 是 Tailscale 控制服务器的开源自托管实现，用于集中管理自有 Tailnet 节点。

## 主要功能
- 管理用户、节点、预授权密钥和 API 密钥。
- 提供 ACL、MagicDNS、DERP 配置和节点注册能力。
- 使用 SQLite 持久化控制面数据，配置和数据目录可备份迁移。

## 访问说明
安装完成后，通过表单中的 `PANEL_APP_PORT_HTTP` 访问 Headscale HTTP 服务；CLI 管理命令可在 1Panel 容器终端中执行。

## Introduction
Headscale is an open-source, self-hosted implementation of the Tailscale control server for managing a private Tailnet.

## Features
- Manage users, nodes, pre-authentication keys, and API keys.
- Provide ACL, MagicDNS, DERP, and node registration capabilities.
- Persist control-plane data in SQLite with backup-friendly configuration and data directories.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`0.23.0-alpha3`、`0.26.1`、`0.27.1`、`0.28.0`、`0.29.2`。
- 安装后通过应用表单中的端口访问 Headscale HTTP 控制服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 (对应内部 8080) | 40183 | 是 |

## 数据持久化
- `./data/config:/etc/headscale`
- `./data/data:/var/lib/headscale`

升级或迁移前，请在 1Panel 中备份上述数据目录。

升级到 `0.27.1` 前请特别注意：

- Headscale `0.27.x` 会执行 SQLite 数据库结构迁移；升级前请备份 `./data/data/db.sqlite`、`./data/data/db.sqlite-wal`、`./data/data/db.sqlite-shm`（如存在）以及 `./data/config`。
- `0.27.1` 最低支持的 Tailscale 客户端版本为 `v1.64.0`，旧客户端需要先升级。
- 版本目录内的 `scripts/upgrade.sh` 会自动备份并迁移旧版 `config.yaml`；如手动改过 Postgres、DNS、ACL 等配置，升级后请核对 `database`、`dns`、`policy` 配置块。

升级到 `0.29.2` 前请特别注意：

- Headscale 强制按次版本顺序升级。商店内必须依次完成 `0.27.1 -> 0.28.0 -> 0.29.2`，不能从 `0.27.1` 直接跳到 `0.29.2`。
- `0.28.0` 最低支持 Tailscale 客户端 `v1.74.0`，`0.29.2` 最低支持 `v1.80.0`；请先升级所有客户端。
- 每一步升级前都应备份 `./data/config`，以及 `db.sqlite`、`db.sqlite-wal`、`db.sqlite-shm`（如存在）。`0.28.0` 会执行节点标签、预授权密钥和数据库结构迁移。
- `0.29.x` 改变了 ACL 通配符和主机名处理规则。使用自定义 ACL、非标准地址段或 `proto:icmp` 的用户必须先核对官方变更说明。
- `0.29.2` 的升级脚本会备份 `config.yaml`，并将旧的 `randomize_client_port: true` 迁移到 `policy.hujson`。如果已经使用自定义文件或数据库策略，脚本会停止而不会覆盖策略；请先在现有策略中加入 `randomizeClientPort`，再移除旧配置项后重试。

## 安全说明
- `0.28.0` 和 `0.29.2` 按上游容器部署方式使用只读根文件系统、只读配置挂载和临时 `/var/run/headscale`。
- 新版本不再申请 `NET_ADMIN`、`NET_RAW`、`SYS_MODULE`，也不设置容器网络转发 sysctl；Headscale 是控制面服务，不承担客户端数据面转发。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SUBNET | 1panel-network 子网 IP (查看docker网络获取网段) | 172.18.0.241 | 是 |

## 使用说明
### 宿主机可通过以下命令创建、获取所需
- 容器名按需修改

```shell
# 创建名为 "username" 的用户
docker exec -it headscale headscale users create username

# 创建一个有效期为 10000 天的 API 密钥
docker exec -it headscale headscale apikeys create -e 10000d

# 创建一个有效期为 10000 天、可重复使用的预授权密钥，并关联到特定的用户名 "username"
docker exec -it headscale headscale preauthkeys create -e 10000d --reusable -u username
```
### 1Panel 容器管理页面连接容器终端

```shell
# 创建名为 "username" 的用户
headscale users create username

# 创建一个有效期为 10000 天的 API 密钥
headscale apikeys create -e 10000d

# 创建一个有效期为 10000 天、可重复使用的预授权密钥，并关联到特定的用户名 "username"
headscale preauthkeys create -e 10000d --reusable -u username
```

## 参考资料
- 官网: <https://headscale.net>
- 源码: <https://github.com/juanfont/headscale>
