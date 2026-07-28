# Gokapi

## 产品介绍

Gokapi 是一个带自动过期、下载次数限制和加密功能的自托管文件分享服务。

## 主要功能

- 按时间或下载次数自动删除分享文件
- 支持本地加密和端到端加密
- 提供用户、API 密钥、文件请求和热链接管理
- 使用本地存储，也可在完成初始化后配置兼容 S3 的对象存储

## 访问说明

默认仅绑定到 `127.0.0.1`。通过 1Panel 反向代理或 SSH 端口转发访问 `http://127.0.0.1:<安装端口>/setup`，完成初始化后使用同一入口访问服务。

## 首次设置

默认仅绑定到 `127.0.0.1`。安装后先通过 1Panel 反向代理或 SSH 端口转发访问 `/setup`，立即完成官方初始化向导并创建管理员账号。初始化完成前该向导没有登录保护，不要把端口绑定到公网地址。

在向导中保持内部端口 `53842`，关闭 Gokapi 内建 TLS，并将公开 URL 设置为最终的 HTTPS 访问地址。由 1Panel 反向代理负责 TLS。

## Introduction

Gokapi is a self-hosted file sharing service with automatic expiration, download limits, and encryption.

## Features

- Expire shared files by time or download count
- Encrypt local files or use end-to-end encryption
- Manage users, API keys, file requests, and hotlinks
- Store files locally or configure S3-compatible object storage after setup

## Deployment And Security

- The package uses the official `f0rc3/gokapi` image and runs it as UID/GID `100:101`.
- The host port binds to `127.0.0.1` by default because the first-run setup wizard is unauthenticated until configuration is complete.
- Keep Gokapi's built-in TLS disabled and terminate HTTPS at the 1Panel reverse proxy.
- Automatic trust of the Docker subnet is disabled. Add only specific reverse-proxy addresses through Gokapi's documented configuration when forwarded client IPs are required.
- The container drops Linux capabilities, prevents privilege escalation, and uses a read-only root filesystem.
- Uploads are limited to 10 GB per file, in-memory upload buffering is limited to 50 MB, and at least 400 MB of free space is reserved.
- The current official `v2.2.4` and `latest` images use Alpine 3.19, which is end-of-life. Review the published image scan evidence and update promptly when upstream publishes a maintained base image.

## Data Persistence

Configuration and the SQLite database are stored below `data/config`. Uploaded files and logs are stored below `data/files`. Back up both directories before upgrades. Uninstalling the app does not remove them.

## References

- Source: <https://github.com/Forceu/Gokapi>
- Documentation: <https://gokapi.readthedocs.io/>
- Docker setup: <https://gokapi.readthedocs.io/en/latest/setup.html#docker>
- Environment variables: <https://gokapi.readthedocs.io/en/latest/advanced.html#available-environment-variables>
