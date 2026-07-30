# Tinyauth

## 产品介绍

Tinyauth 是一个轻量级身份认证与授权服务，可作为 Traefik、Nginx、Caddy 等反向代理的 Forward Auth 后端，也可独立提供本地用户登录、OAuth、LDAP 和 OpenID Connect 服务。

本应用使用 Tinyauth 官方镜像和本地 SQLite 数据库。安装时输入的管理员密码会通过上游自带命令生成 bcrypt 哈希，运行容器只读取持久化的哈希用户文件，不接收管理员明文密码。

## 主要功能

- 本地用户登录与基于 Cookie 的认证会话
- 适配 Traefik、Nginx 和 Caddy 的 Forward Auth 端点
- OAuth、LDAP 和 Tailscale 身份源集成
- 作为 OpenID Connect 身份提供方服务其他应用
- 按用户、组、IP、域名和路径配置访问控制

## 访问说明

- Web 界面：安装表单中填写的外部访问地址
- 初始管理员：安装表单中的管理员用户名和随机密码
- 使用 HTTP 时保持“安全 Cookie”为 `false`；通过 HTTPS 域名访问时应将其设置为 `true`
- 外部访问地址必须使用至少两级的域名，并与浏览器实际使用的协议、域名和端口一致；Tinyauth 不接受 IP 地址或裸 `localhost`

登录后可直接使用 Tinyauth 的独立认证界面。若要保护其他应用，需要在反向代理中把认证请求转发到 Tinyauth，并按上游文档配置对应的 Forward Auth 端点和请求头。本包不会自动发现或修改其他 1Panel 应用。

## 安全边界

本包明确设置 `TINYAUTH_LABELPROVIDER=none`，不挂载 `/var/run/docker.sock`，也不启用 Docker 或 Kubernetes label provider。容器以 UID/GID `1000:1000` 运行，根文件系统只读，删除全部 Linux capabilities，并启用 `no-new-privileges`。

镜像依赖扫描会报告 Docker client 库中的三个 High 漏洞，但这些代码只由已禁用的 Docker label provider 调用；默认包没有 Docker socket、Docker API 地址或 provider 自动探测路径。请勿自行把 label provider 改为 `auto` 或 `docker`，也不要向容器添加 Docker socket。

固定版本从 `5.1.3` 开始，因为 `5.1.2` 及更早版本受 `GHSA-r27r-rr9v-vv37` 的 Forward Auth ACL 认证绕过影响。不要降级到 `5.1.2` 或更早版本。

## 数据与升级

`./data` 挂载到容器 `/data`，保存 bcrypt 用户文件、SQLite 数据库、OIDC 密钥和资源文件。卸载只移除容器和 Compose 资源，不删除该目录。升级前应备份整个 `./data` 目录，并确认外部访问地址和反向代理配置保持一致。

`latest` 使用上游 `v5` 移动标签；需要可重复部署时请选择固定版本 `5.1.3`。

## Introduction

Tinyauth is a lightweight authentication and authorization server for reverse proxies and standalone applications. It supports local users, OAuth, LDAP, OpenID Connect, and Forward Auth integrations for Traefik, Nginx, and Caddy.

This package uses the official image and a local SQLite database. The install script passes the administrator password to Tinyauth's own bcrypt generator over standard input and persists only the resulting user hash for the runtime container.

## Features

- Local users and cookie-based authentication sessions
- Forward Auth endpoints for Traefik, Nginx, and Caddy
- OAuth, LDAP, and Tailscale identity integrations
- OpenID Connect provider support for downstream applications
- User, group, IP, domain, and path-based access controls

The package explicitly disables label discovery with `TINYAUTH_LABELPROVIDER=none` and does not mount the Docker socket. The container runs as UID/GID `1000:1000` with a read-only root filesystem, all Linux capabilities dropped, and `no-new-privileges` enabled. Do not enable the Docker provider or add a Docker socket mount.

Set the external URL to the exact browser-facing protocol, domain, and port. Tinyauth rejects IP addresses and bare `localhost`; use a domain with at least two labels. Use secure cookies only with HTTPS. To protect another application, configure its reverse proxy to call the appropriate Tinyauth Forward Auth endpoint; this package intentionally does not discover or modify other 1Panel applications.

Version `5.1.3` is the oldest version packaged here because it fixes the Forward Auth ACL authentication bypass in `GHSA-r27r-rr9v-vv37`. Do not downgrade to `5.1.2` or earlier.

Persistent users, SQLite state, OIDC keys, and resources live under `./data`. Uninstall preserves this directory. Back up the entire directory before upgrades.

## References

- Website: <https://tinyauth.app/>
- Documentation: <https://tinyauth.app/docs/getting-started/>
- Source: <https://github.com/tinyauthapp/tinyauth>
- Security advisory: <https://github.com/tinyauthapp/tinyauth/security/advisories/GHSA-r27r-rr9v-vv37>
- Official image: <https://github.com/tinyauthapp/tinyauth/pkgs/container/tinyauth>
