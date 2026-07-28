# Owncast

## 产品介绍

Owncast 是一个自托管的直播视频与聊天服务器，可通过 OBS 或其他 RTMP
编码器推流，并向浏览器提供视频、聊天、管理和联邦功能。

## 主要功能

- 接收 OBS 等编码器的 RTMP 推流
- 向浏览器提供自适应直播视频与内置聊天
- 提供管理界面、访问控制、Webhook 和联邦功能
- 使用本地 SQLite 与文件目录持久化完整实例状态

## 访问说明

Web 端口默认只允许本机访问，请先在 1Panel 中配置 HTTPS 反向代理。
远程编码器通过配置的 RTMP 端口和安装时生成的推流密钥连接。

## 安全与首次使用

- Web 端口默认只绑定 `127.0.0.1`。请通过 1Panel 反向代理提供 HTTPS，管理入口为 `/admin`。
- RTMP 端口默认绑定所有接口，以便远程编码器连接。请在防火墙中仅允许可信的推流来源，并使用安装表单生成的随机推流密钥。
- 安装时会在无网络、无公开端口的 bootstrap 容器中替换上游公开的默认管理员密码和推流密钥。完成后该容器清除进程环境中的秘密并仅保持健康门禁。随机值会写入权限为 `0600` 的 `.env`，升级和重启不会旋转。
- 推流地址为 `rtmp://<服务器地址>:<RTMP 端口>/live`，密钥使用安装表单中的 Owncast 推流密钥。
- 应用以 UID/GID `101:101` 运行，根文件系统只读，丢弃全部 Linux capabilities，并禁止权限提升。

## 数据

数据库、视频片段、缩略图、日志和备份保存在安装版本目录下的 `data` 中。
卸载不会删除该目录。升级前请备份整个目录。

## Introduction

Owncast is a self-hosted live video streaming and chat server. It accepts RTMP
from OBS and other encoders and serves video, chat, administration, and
federation features to browsers.

## Features

- Accept RTMP broadcasts from OBS and other encoders
- Serve adaptive live video with integrated browser chat
- Provide administration, access controls, webhooks, and federation
- Persist complete instance state in local SQLite and media files

## Deployment And Security

- The web port binds to `127.0.0.1` by default. Publish it through the 1Panel reverse proxy with HTTPS; the administrator interface is at `/admin`.
- The RTMP port binds to all interfaces by default for remote encoders. Restrict it to trusted source addresses with the firewall and use the generated stream key.
- A network-isolated, unpublished bootstrap service replaces Owncast's public default administrator password and stream key before the main service starts. It then clears the secrets from its process environment and remains only as a healthy startup gate. Generated values persist in the mode `0600` `.env` and are not rotated by restart or upgrade.
- Stream to `rtmp://<server>:<RTMP port>/live` with the Owncast stream key shown in the install form.
- The application runs as UID/GID `101:101`, uses a read-only root filesystem, drops every Linux capability, and prevents privilege escalation.
- This package intentionally supports only amd64 and arm64. OpenSSL's CNA states that `CVE-2026-31789` affects only 32-bit platforms; the official image's arm/v7 and 386 variants are excluded.

## Data And Backups

The SQLite database, video segments, thumbnails, logs, and backups are stored in
`data` below the installed version directory. Uninstall does not remove this
directory. Back up the complete directory before upgrades.

## References

- Source: <https://github.com/owncast/owncast>
- Documentation: <https://owncast.online/docs/>
- Container setup: <https://owncast.online/docs/quickstart/container/>
- Broadcasting: <https://owncast.online/docs/broadcasting/>
