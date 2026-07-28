# MeshChatX

## 产品介绍

MeshChatX 是基于 Reticulum 的网状通信客户端，提供浏览器界面、消息、通话及相关工具。

## 主要功能

- Reticulum 网状通信与联系人管理
- 浏览器界面的消息、通话和工具
- 持久化的身份、TLS 和本地通信数据

## 访问说明

安装后通过 `https://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTPS` 为准。上游默认生成自签名证书，首次访问会出现浏览器证书提示；生产环境应使用可信 TLS 终端并限制网络暴露范围。

应用固定启用上游认证。首次访问时在 Web UI 中设置强密码，之后使用该密码登录。首次部署时，先仅从受信任网络完成此设置，再开启 1Panel 的端口外部访问。请只向受信任的用户开放服务；上游明确不建议将其直接暴露到公共互联网。

## 数据持久化

`APP_DATA_DIR` 挂载到容器的 `/config`，保存 Reticulum 身份、TLS 证书、认证配置、消息和其他应用数据。该路径必须位于应用版本目录内（默认 `./data`）；安装与升级脚本会拒绝绝对路径及目录外路径，避免误改宿主机文件权限。脚本将目录设置为镜像要求的 UID/GID `1000:1000`。卸载不会删除绑定目录中的用户数据，升级、迁移或卸载前请备份该目录。

## 安全说明

- 容器显式使用上游的非 root UID/GID `1000:1000`，根文件系统只读，丢弃全部 Linux capabilities，并启用 `no-new-privileges`。仅 `/config` 数据卷及上游要求的 `/tmp`、`/home/meshchat` tmpfs 可写。
- 2026-07-28 对固定镜像的 Trivy 扫描未发现 Critical 或 High 漏洞；仍应在后续镜像更新前重新扫描。
- 插件和通信数据属于用户信任边界。仅安装可信插件，并保护包含身份和消息数据的 `/config` 备份。

## Introduction

MeshChatX is a Reticulum mesh communications client with a browser interface for messaging, calls, and related tools.

## Features

- Reticulum mesh communications and contact management
- Browser-based messaging, calls, and tools
- Persistent identity, TLS, and local communications data

## Usage Notes

- Access the service at `https://<server-ip>:<port>`. The upstream self-signed certificate triggers a browser warning on first access; use a trusted TLS endpoint and restrict network exposure for production use.
- Upstream authentication is enabled by default. Set a strong password in the Web UI from a trusted network before enabling 1Panel external port access, then use it for later sign-in. Do not expose the service directly to the public internet.
- `APP_DATA_DIR` persists Reticulum identity, TLS material, authentication settings, messages, and other application data. It must remain relative to the application version directory (default `./data`); absolute and outside paths are rejected. The initialization script assigns it to UID/GID `1000:1000`.
- The container explicitly runs as upstream UID/GID `1000:1000`, uses a read-only root filesystem, drops all Linux capabilities, and enables `no-new-privileges`. Only `/config` and the upstream-required `/tmp` and `/home/meshchat` tmpfs mounts are writable.

## References

- Project: <https://github.com/Quad4-Software/MeshChatX>
- Docker deployment: <https://github.com/Quad4-Software/MeshChatX#docker>
- Security architecture: <https://github.com/Quad4-Software/MeshChatX/blob/master/docs/en/architecture.md>
- License: <https://github.com/Quad4-Software/MeshChatX/blob/master/LICENSE> (0BSD and MIT)
