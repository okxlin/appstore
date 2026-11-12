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
- 本应用基于官方 `opencloud-compose` 的基础服务与 Traefik TLS 部署方式，并在初始化时将随包提供的 file-provider 路由配置安全地创建到持久化目录；Compose 证据固定到提交 `8d2d89f283faa410bc9ed9f63e8247f6518d5c43`。
- 本应用使用官方版本化镜像 tag，不使用浮动 `latest` tag。
- OpenCloud 与 Traefik 镜像均提供 `linux/amd64` 和 `linux/arm64` manifest。

## 部署拓扑

本应用包含两个 service：

- `opencloud`：使用官方 OpenCloud 镜像，以 UID/GID `1000:1000` 运行并持久化配置、文件数据和 Web 扩展。
- `traefik`：使用官方 OpenCloud Compose 指定的 Traefik 版本，为 OpenCloud 提供必须的 HTTPS 入口和 HTTP 到 HTTPS 跳转。

两个 service 通过以 1Panel 实例容器名命名的专用 Docker 网络联动；OpenCloud 后端只加入该专用网络，Traefik 另行加入 `1panel-network` 作为商店入口。Traefik 从应用包内的 file-provider 配置读取路由，并通过专用网络访问 `opencloud:9200`，不需要发现或控制 Docker 容器。

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
- `${APP_DATA_DIR}/traefik/dynamic/1panel-opencloud-route.yml`：应用首次初始化时创建的 OpenCloud 路由。已存在的文件不会被覆盖。
- `${APP_DATA_DIR}/traefik/dynamic`：可选 TLS 动态配置。
- `${APP_DATA_DIR}/traefik/certs`：TLS 证书。

初始管理员密码只在空数据目录第一次启动时生效，后续修改 `.env` 不会重置密码。升级前必须整体备份 `${APP_DATA_DIR}`；配置、存储和证书应作为同一个一致性边界备份和恢复。

`scripts/upgrade.sh` 复用安装初始化逻辑：创建缺失目录和缺失的 OpenCloud Traefik 路由，并校正 OpenCloud 持久化目录顶层的 UID/GID，不递归改写已有文件、不删除数据。卸载脚本只停止 Compose service，不删除 `${APP_DATA_DIR}`。

## 权限与安全

Traefik 使用应用包生成并保存在 `${APP_DATA_DIR}` 中的静态路由配置，不挂载 Docker Socket，也不读取其他容器的标签。HTTP 请求经 Traefik 转发至同一专用网络中的 OpenCloud 服务。

OpenCloud service 不使用 privileged、host network、额外 capability 或设备映射。请使用强管理员密码、受信任 TLS 证书和主机防火墙，并限制不必要的公网入口。

## 参考资料

- 官网：<https://opencloud.eu/>
- 源码：<https://github.com/opencloud-eu/opencloud>
- 官方 Compose：<https://github.com/opencloud-eu/opencloud-compose>
- 官方 Docker Compose 文档：<https://docs.opencloud.eu/docs/admin/getting-started/container/docker-compose/docker-compose-base>
- 外部代理说明：<https://github.com/opencloud-eu/opencloud-compose/blob/8d2d89f283faa410bc9ed9f63e8247f6518d5c43/external-proxy/opencloud.yml>

## Introduction

OpenCloud is an open-source platform for file management, sharing, and collaboration. This package follows the official OpenCloud Compose service topology and creates a package-provided Traefik file-provider route in persistent app data to serve OpenCloud over HTTPS without Docker API access. Existing route files are preserved.

This package uses versioned official image tags rather than a floating `latest` tag.

A trusted certificate is required for production. Back up the complete `${APP_DATA_DIR}` before upgrading. The lifecycle scripts do not delete persisted data or recursively rewrite existing files.

## Features

- Browser, WebDAV, desktop, and mobile file access.
- User, group, space, sharing-link, and collaboration management.
- Built-in identity services without an external database or Redis dependency.
- Persistent configuration, storage, TLS material, and Web extensions.
