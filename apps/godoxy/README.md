# GoDoxy

## 产品介绍

GoDoxy 是一个带有内置 WebUI 的轻量级反向代理，支持 Docker 标签发现、访问控制和 Web 路由。

## 主要功能

- 通过 WebUI 管理反向代理路由和访问控制。
- 仅发现带有显式 GoDoxy 标签的 Docker 容器。
- 此应用包发布 HTTP、HTTPS 和 HTTPS 端口上的 HTTP/3，并支持证书管理。

## 访问说明

请为安装时填写的 **WebUI 主机名** 创建 DNS 记录，并通过配置的 HTTP 或 HTTPS 端口访问。GoDoxy 根据 HTTP `Host` 头进行路由，使用其他主机名直接打开服务器 IP 不会匹配 WebUI 路由。默认绑定地址 `127.0.0.1` 仅适合同机 1Panel 网站反向代理；如需直接远程访问，请改为 `0.0.0.0`，并同时配置防火墙和 TLS。

本应用要求设置管理员用户名和密码，并始终为会话 Cookie 启用 `Secure`。请通过 HTTPS 端口登录，或在 GoDoxy 前端使用 HTTPS 反向代理终止 TLS。HTTP 端口仍可用于不需要会话的路由。

GoDoxy 的 HTTPS 监听器需要证书。首次使用前，请在 `config/config.yml` 中配置证书提供程序，或让 1Panel 网站反向代理为 WebUI 终止 TLS。

## Introduction

GoDoxy is a lightweight reverse proxy with an embedded WebUI, Docker label discovery, access controls, and web routing.

## Features

- Manage reverse-proxy routes and access controls through a WebUI.
- Discover only Docker containers carrying explicit GoDoxy labels.
- Publish HTTP, HTTPS, and HTTP/3 on the HTTPS port, with certificate support.

## Access

Create a DNS record for the configured **WebUI Host** and open it through the configured HTTP or HTTPS port. GoDoxy routes by the HTTP `Host` header, so opening the server IP under a different hostname returns no WebUI route. The default `127.0.0.1` bind address is intended for a same-host 1Panel website reverse proxy. For direct remote access, change it to `0.0.0.0` and configure both a firewall and TLS.

The package requires an administrator username and password and always marks its session cookie `Secure`. Sign in through the HTTPS listener or through an HTTPS reverse proxy in front of GoDoxy. The HTTP listener can still serve routes that do not require a session.

GoDoxy's HTTPS listener requires a certificate. Before first login, configure a certificate provider in `config/config.yml`, or use a 1Panel website reverse proxy to terminate TLS for the WebUI.

## Published Port Scope

This package publishes only `80/tcp`, `443/tcp`, and `443/udp` from the container through the two configured host ports. GoDoxy upstream supports arbitrary TCP and UDP routes, but those routes are not externally reachable from this package unless an administrator explicitly extends the Compose port mappings and reviews the firewall exposure.

## Docker Access

The package uses GoDoxy's official socket proxy on a private Compose network. Its default policy permits only Docker container inspection, events, daemon information, ping, and version requests. Container start, stop, restart, create, exec, image, network, volume, and other write endpoints are disabled.

Docker container inspection can reveal metadata and environment variables from other containers. Treat GoDoxy administrator access as privileged and do not expose the WebUI without authentication and transport protection.

Only containers explicitly carrying GoDoxy proxy labels are discovered by default (`local!` provider mode). Existing containers are not published automatically.

## Image Security Note

The image snapshots retained by the fixed `0.30.1` package report three High findings in GoDoxy's bundled Moby client library and one Go `os.Root` High in the socket proxy. The affected daemon-side authorization, archive upload, and copy implementations are not used by the read-only socket policy, and the socket-proxy binary contains no `os.Root` call site. The `latest` package follows unpinned moving tags; reassess these findings whenever either tag resolves to a new image.

## Data

Configuration, logs, certificates, generated error pages, and runtime data are stored below the configured data directory. The initialization script preserves an existing `config/config.yml` during reinstall and upgrade.
