# OpenCloud

## 产品介绍

OpenCloud 是一个开源的文件管理、共享与协作平台，提供 Web 文件管理、用户与群组、共享链接、WebDAV、桌面与移动客户端接入等能力。

## 主要功能

- 通过 Web、WebDAV、桌面和移动客户端管理文件。
- 管理用户、群组、空间、共享链接和协作权限。
- 使用内置身份服务完成登录，不依赖外部数据库或 Redis。
- 通过扩展目录加载受支持的 OpenCloud Web 扩展。

## 来源与版本

- OpenCloud 源码仓库由 `opencloud-eu` 官方组织维护，采用 Apache License 2.0。
- 本应用基于官方 `opencloud-compose` 的基础服务与 Traefik TLS 部署方式，Compose 证据固定到提交 `8d2d89f283faa410bc9ed9f63e8247f6518d5c43`。
- OpenCloud `v7.3.0` 于 2026-07-14 发布；官方在 `opencloudeu/opencloud-rolling:7.3.0` 发布该版本，镜像内报告 `Edition: rolling`。官方 production 镜像仓库在适配时仍停留于 `7.2.2`，因此这里明确使用官方 rolling 仓库的固定 `7.3.0` tag，而不是浮动 tag。
- OpenCloud 与 Traefik 镜像均提供 `linux/amd64` 和 `linux/arm64` manifest。

## 部署拓扑

本应用包含两个 service：

- `opencloud`：使用官方 OpenCloud 镜像，以 UID/GID `1000:1000` 运行并持久化配置、文件数据和 Web 扩展。
- `traefik`：使用官方 OpenCloud Compose 指定的 Traefik 版本，为 OpenCloud 提供必须的 HTTPS 入口和 HTTP 到 HTTPS 跳转。

两个 service 通过以 1Panel 实例容器名命名的专用 Docker 网络联动；OpenCloud 后端只加入该专用网络，Traefik 另行加入 `1panel-network` 作为商店入口。每个 Traefik 通过实例标签只发现对应的 OpenCloud 容器，不同安装不会互相加载或覆盖同名路由。

OpenCloud 的 IDM、IDP、NATS、存储和 Web 服务由同一个官方镜像内部管理，不需要 MySQL、PostgreSQL、Redis 或其他 1Panel Runtime。可选的 Collabora、全文检索、杀毒、外部 LDAP/Keycloak 等扩展没有包含在此基础应用中。

## 访问说明

1. 将 `OpenCloud 域名` 的 A/AAAA 记录解析到 1Panel 服务器；只填写主机名，不要填写协议、端口或路径。
2. 确认 HTTP 与 HTTPS 端口未被占用。默认端口分别为 `4080` 和 `4443`。
3. 安装后访问 `https://OpenCloud域名:HTTPS端口`，初始用户名为 `admin`，密码为安装表单中的初始管理员密码。

OpenCloud 的内置 IDP 要求公开 URL 必须使用 HTTPS；将其改为 HTTP 会导致服务以 `invalid iss value, URL must start with https://` 退出。域名和 HTTPS 端口也是 OIDC issuer 的组成部分，已有数据初始化后不要随意修改。

## TLS 证书

未配置证书时，Traefik 会提供临时自签证书，浏览器会显示证书不受信任警告。这只适合首次验证，不适合公开生产环境。

要使用正式证书，将证书文件放入 `${APP_DATA_DIR}/traefik/certs/`，并创建 `${APP_DATA_DIR}/traefik/dynamic/certs.yml`：

```yaml
tls:
  certificates:
    - certFile: /certs/fullchain.pem
      keyFile: /certs/privkey.pem
```

对应文件名为 `fullchain.pem` 和 `privkey.pem`。完成后重启应用。证书必须覆盖安装表单中的 OpenCloud 域名。

## 数据、备份与升级

- `${APP_DATA_DIR}/config`：OpenCloud 生成的配置和随机密钥。
- `${APP_DATA_DIR}/storage`：用户文件、元数据和应用状态。
- `${APP_DATA_DIR}/apps`：本地 Web 扩展。
- `${APP_DATA_DIR}/traefik`：TLS 动态配置和证书。

初始管理员密码只在空数据目录第一次启动时生效，后续修改 `.env` 不会重置密码。升级前必须整体备份 `${APP_DATA_DIR}`；配置、存储和证书应作为同一个一致性边界备份和恢复。

`scripts/upgrade.sh` 只复用安装初始化逻辑：创建缺失目录，并校正 OpenCloud 持久化目录顶层的 UID/GID，不递归改写文件、不删除数据、不重建配置。卸载脚本只停止 Compose service，不删除 `${APP_DATA_DIR}`。

## 权限与安全

Traefik 按官方 Compose 方案以只读方式挂载 Docker Socket，用于读取容器标签和发现 OpenCloud 路由。即使挂载标记为只读，Docker Socket 仍属于高权限主机接口；只应在可信主机上使用，并保持 Traefik 镜像及时更新。Compose 已关闭 `exposedByDefault`，Traefik 只处理明确标记的 OpenCloud service。

OpenCloud service 不使用 privileged、host network、额外 capability 或设备映射。请使用强管理员密码、受信任 TLS 证书和主机防火墙，并限制不必要的公网入口。

## 参考资料

- 官网：<https://opencloud.eu/>
- 源码：<https://github.com/opencloud-eu/opencloud>
- 官方 Compose：<https://github.com/opencloud-eu/opencloud-compose>
- 官方 Docker Compose 文档：<https://docs.opencloud.eu/docs/admin/getting-started/container/docker-compose/docker-compose-base>
- 外部代理说明：<https://github.com/opencloud-eu/opencloud-compose/blob/8d2d89f283faa410bc9ed9f63e8247f6518d5c43/external-proxy/opencloud.yml>

## Introduction

OpenCloud is an open-source platform for file management, sharing, and collaboration. This package follows the official OpenCloud Compose topology: one fixed-version OpenCloud container and one Traefik container providing the HTTPS endpoint required by the built-in identity provider.

The package uses the official `opencloudeu/opencloud-rolling:7.3.0` image because OpenCloud 7.3.0 was published only in the official rolling image repository at adaptation time. The tag is fixed; neither packaged version follows a floating image tag.

A trusted certificate is required for production. Back up the complete `${APP_DATA_DIR}` before upgrading. The lifecycle scripts do not delete persisted data or recursively rewrite existing files.

## Features

- Browser, WebDAV, desktop, and mobile file access.
- User, group, space, sharing-link, and collaboration management.
- Built-in identity services without an external database or Redis dependency.
- Persistent configuration, storage, TLS material, and Web extensions.
