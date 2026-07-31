# Anubis

## 产品介绍

Anubis 是部署在现有 Web 服务前方的反向代理，通过工作量证明挑战降低高强度爬虫和自动化采集带来的负载。一个 Anubis 实例只保护安装时配置的一个目标服务。

## 主要功能

- 根据请求特征允许、拒绝或质询访问者
- 为常见浏览器提供本地化的工作量证明挑战页面
- 可代替上游服务提供限制爬虫的 `robots.txt`
- 内置健康检查和 Prometheus 指标端点

## 访问说明

在 **受保护目标 URL** 中填写 Anubis 要转发到的完整 `http://` 或 `https://` 地址。默认值 `https://example.com` 仅用于验证安装，正式使用前必须改为自己的服务地址。目标服务必须能从 `1panel-network` 中访问；同一 Docker 网络中的服务通常可以使用容器名，例如 `http://my-app:8080`。

**允许重定向主机** 必须列出访问 Anubis 时使用的域名或 IPv4 地址，多个值以英文逗号分隔；不要包含协议、端口、路径、查询参数或用户信息。该字段没有通用安全默认值，安装时必须按实际域名填写。当前打包镜像无法安全匹配带非标准端口的白名单，因此应通过 1Panel 网站反向代理在标准 HTTP/HTTPS 端口发布，并让代理保留原始 `Host`。直接使用 `域名:非标准端口` 访问会在挑战后被拒绝。

默认仅绑定 `127.0.0.1`，并关闭 **使用直连客户端地址**，以便 Anubis 使用可信前置代理提供的客户端地址。应通过 1Panel 网站的 HTTPS 反向代理发布 Anubis，确认代理会设置正确的 `X-Real-IP`，且不会允许客户端伪造该标头。只有在标准端口直接连接 Anubis、完全不经过代理时才启用直连地址选项。若 TLS 在前置代理终止，请在确认访问始终使用 HTTPS 后启用 **仅 HTTPS 挑战 Cookie**；直接使用 HTTP 时必须保持关闭。

首次访问时，普通浏览器会看到挑战页面，完成计算后才会加载目标服务。命令行 HTTP 客户端通常不具备完成挑战所需的 JavaScript 环境。

## 策略与安全

- 应用使用镜像内置的官方默认策略。要定制策略，请参考官方 policy 文档并在独立评审后为容器挂载配置文件。
- 安装脚本会生成 64 位十六进制 Ed25519 私钥并保存在实例 `.env` 中，使签名在正常重启后保持一致；卸载实例时该密钥随实例目录删除。
- 容器以 UID/GID `1000:1000` 运行，根文件系统只读，丢弃全部 Linux capabilities，并设置 `no-new-privileges`。
- 授权 Cookie 始终使用 `HttpOnly` 和 `SameSite=Lax`；Prometheus 指标仅绑定容器回环地址，不通过共享 Docker 网络或宿主端口公开。
- 固定版镜像的预检发现 2 个 High 级 Go 依赖问题，其中 `x/text` 的无效 UTF-8 处理可能位于请求路径上。请在对公网部署前复核当前镜像，并限制可直接访问 Anubis 的来源。
- 默认内存存储不会保留未完成的挑战。重启后已签发 Cookie 仍按其有效期工作，但正在进行的挑战需要重新完成。

## Introduction

Anubis is a reverse proxy placed in front of an existing web service. It uses proof-of-work challenges to reduce load from aggressive crawlers and automated collection. Each installation protects one configured target.

## Features

- Classify requests and allow, deny, or challenge clients according to the built-in policy
- Present localized proof-of-work challenge pages to browser users
- Optionally serve a crawler-restricting `robots.txt`
- Report health and expose an internal Prometheus metrics endpoint

Set **Protected Target URL** to a complete `http://` or `https://` URL reachable from `1panel-network`. The default `https://example.com` is only an installation check and must be replaced for real use. Set **Allowed Redirect Hosts** to the actual hostnames or IPv4 addresses used to access Anubis, separated by commas and without schemes, ports, paths, query strings, or user information. There is no universal safe default, so the install form requires an explicit value. The packaged image cannot safely match a non-standard port in this allowlist; publish Anubis through a 1Panel website reverse proxy on standard HTTP/HTTPS ports and preserve the original `Host` header. Direct access through `hostname:non-standard-port` is rejected after the challenge. Direct-client address mode is disabled by default so Anubis uses the client address supplied by the trusted proxy. Ensure the proxy sets a correct `X-Real-IP` header and does not allow clients to spoof it. Enable direct-client mode only when clients connect straight to Anubis with no proxy. Enable the HTTPS-only challenge cookie only when clients always connect over HTTPS.

The package uses Anubis' built-in official policy and in-memory challenge storage. The container runs as UID/GID `1000:1000`, has a read-only root filesystem, drops all Linux capabilities, and enables `no-new-privileges`.

## References

- Project: <https://github.com/TecharoHQ/anubis>
- Stable release: <https://github.com/TecharoHQ/anubis/releases/tag/v1.26.2>
- Installation: <https://anubis.techaro.lol/docs/admin/installation>
- Docker Compose: <https://anubis.techaro.lol/docs/admin/environments/docker-compose>
- License: <https://github.com/TecharoHQ/anubis/blob/v1.26.2/LICENSE> (MIT)
