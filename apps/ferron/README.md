# Ferron

## 产品介绍

Ferron 是一个使用 Rust 编写的现代 Web 服务器，支持静态文件、反向代理、HTTP/2、实验性 HTTP/3、自动 TLS 和可扩展模块。本应用默认提供一个安全收敛的单服务 HTTP 拓扑，适合通过 1Panel HTTPS 反向代理发布。

## 主要功能

- 提供静态网站托管、反向代理和负载均衡
- 支持 HTTP/1.1、HTTP/2 和实验性 HTTP/3
- 支持自动 TLS、自定义证书和多虚拟主机
- 使用 KDL 配置并支持模块化扩展

## 访问说明

默认地址为 `http://127.0.0.1:8080`。建议在 1Panel 中创建 HTTPS 反向代理后再向不受信任网络开放服务。

## 默认部署

- 默认监听宿主机 `127.0.0.1:8080`，容器内部使用 HTTP 端口 `80`。
- `APP_DATA_DIR/www` 保存网站文件，初次安装时仅在缺失时写入示例首页。
- `APP_DATA_DIR/config/ferron.kdl` 是主配置文件，升级和重复初始化不会覆盖已有配置。
- `APP_DATA_DIR/acme` 保留可选自动 TLS 缓存，目录归属上游 `nobody` 用户（UID/GID `65534:65534`）。
- 访问日志和错误日志分别写入容器标准输出和标准错误，可直接通过 1Panel 查看。

## 安全说明

- 容器使用上游 `nobody` 用户运行，根文件系统只读，丢弃全部 Linux capabilities，并启用 `no-new-privileges`。
- 网站和 KDL 配置在容器内只读挂载；通过 1Panel 文件管理器或宿主机编辑后，重启应用以应用配置变更。
- 默认配置不启用 TLS，也不公开 `443/tcp` 或 `443/udp`。如需 Ferron 直接管理证书，请根据官方文档修改 KDL 和 Compose 端口，并确保域名解析、ACME 挑战和防火墙配置正确。
- 静态网站通常不提供身份认证。不要在公开目录中放置密钥、备份或其他敏感文件。

## 备份与升级

升级前备份整个 `APP_DATA_DIR`。恢复时应同时恢复 `config`、`www` 和 `acme`，并保持 `acme` 目录归属 UID/GID `65534:65534`。

## Introduction

Ferron is a modern Rust web server with static hosting, reverse proxying, HTTP/2, experimental HTTP/3, automatic TLS, and extensible modules. This package uses a constrained single-service HTTP topology intended for publication through a 1Panel HTTPS reverse proxy.

## Features

- Host static websites and configure reverse proxies with load balancing
- Serve HTTP/1.1, HTTP/2, and experimental HTTP/3
- Use automatic TLS, custom certificates, and multiple virtual hosts
- Extend a KDL-based configuration with modules

## Default Deployment

- The host bind defaults to `127.0.0.1:8080`, mapped to container port `80`.
- Website files live under `APP_DATA_DIR/www`; the starter page is written only when missing.
- The main configuration is `APP_DATA_DIR/config/ferron.kdl` and is never overwritten by upgrades or repeated initialization.
- Optional automatic-TLS state is retained under `APP_DATA_DIR/acme`, owned by upstream UID/GID `65534:65534`.
- Access and error logs use the container standard streams for direct viewing in 1Panel.

## Security And Operations

- The container runs as upstream `nobody`, with a read-only root filesystem, all Linux capabilities dropped, and `no-new-privileges` enabled.
- Website and KDL mounts are read-only inside the container. Edit them with the 1Panel file manager or on the host, then restart the app for configuration changes.
- Direct TLS is disabled and port 443 is not published by default. Follow upstream documentation before enabling automatic TLS or HTTP/3.
- Back up the complete `APP_DATA_DIR` before upgrades and retain UID/GID `65534:65534` on the `acme` directory when restoring.

## References

- Project: <https://github.com/ferronweb/ferron>
- Stable release: <https://github.com/ferronweb/ferron/releases/tag/2.8.1>
- Docker installation: <https://ferron.sh/docs/installation/docker>
- Configuration: <https://ferron.sh/docs/configuration/fundamentals>
- License: <https://github.com/ferronweb/ferron/blob/2.8.1/LICENSE> (MIT)
