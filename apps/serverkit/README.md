# ServerKit

## 产品介绍

ServerKit 是一个自托管的远程服务器管理与运维面板，提供服务器接入、集群视图、终端、部署、监控、备份、安全和站点相关功能。

本应用包使用上游发布的 all-in-one Docker 镜像 `jhd3197/serverkit`，包含 API、前端 SPA 和 Socket.IO 服务。

## 主要功能

- 接入和管理远程服务器及服务器集群。
- 提供终端、部署、监控、备份和安全相关能力。
- 通过浏览器提供统一的 Web 面板和实时 Socket.IO 通信。

## 适配说明

这是 ServerKit 的容器化部署。容器默认不挂载 Docker Socket、宿主机文件系统或特权权限，因此它不能管理当前 1Panel 宿主机的 systemd、宿主机 Nginx、宿主机软件包或本机站点。它适合评估、管理其他已接入的远程服务器，以及放在反向代理后使用。

## 首次使用

1. 安装时填写三个唯一密钥：`SECRET_KEY`、`JWT_SECRET_KEY` 和 Fernet 格式的 `SERVERKIT_ENCRYPTION_KEY`。
2. Fernet 密钥可用以下命令生成：

   ```bash
   python3 -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
   ```

   前两个密钥可用 `openssl rand -hex 32` 生成。密钥应妥善保存；更换它们会使已有会话或加密数据失效。
3. 通过安装时配置的 HTTP 端口打开 ServerKit。首次打开时使用注册页面创建第一个用户；第一个用户会被授予管理员角色。
4. 如果使用反向代理，请填写 `SERVERKIT_PUBLIC_URL`，并仅在请求一定经过可信反向代理时将 `TRUST_PROXY_HEADERS` 设为 `true`。需要同时允许多个浏览器来源时，在 `CORS_ORIGINS` 中用逗号分隔填写。

SQLite 数据库持久化在应用安装目录的 `data/serverkit.db`，并以 bind mount 映射到容器内的 `/app/instance`。该目录位于 1Panel 应用目录中，便于随应用数据一起备份。不要删除该目录，否则会丢失 ServerKit 数据。由旧版 `serverkit-data` 卷升级时，目标版本会在新目录为空时自动迁移 SQLite 文件；旧卷会保留，不会自动删除。

## 安全提示

维护侧使用 Trivy 对 `serverkit` 的每个版本镜像进行了漏洞扫描；当前每个扫描报告包含 Critical=5、High=77、Total=82（两个版本标签解析到相同镜像内容）。这些风险来自上游镜像及其基础系统组件，本应用包未对其进行修复。请优先在可信内网中使用，并关注上游镜像更新。

高风险示例：

- Critical `CVE-2025-7458`（`libsqlite3-0`）：当前暂无修复版本。
- Critical `CVE-2026-13221`、`CVE-2026-42496`、`CVE-2026-8376`（`perl-base`）：当前暂无修复版本。
- Critical `CVE-2023-45853`（`zlib1g`）：当前暂无修复版本。

## 版本

应用同时提供 `latest` 和固定版本 `1.11.4`，两者均来自上游 Docker Hub 发布镜像，并支持 amd64 与 arm64。

## 相关链接

- [上游项目](https://github.com/jhd3197/ServerKit)
- [Docker 部署文档](https://github.com/jhd3197/ServerKit/blob/v1.11.4/docs/INSTALLATION.md#quick-install-docker)
- [上游 Compose 文件](https://github.com/jhd3197/ServerKit/blob/v1.11.4/docker-compose.yml)

ServerKit 上游项目采用 MIT License，详细条款见[上游许可证](https://github.com/jhd3197/ServerKit/blob/v1.11.4/LICENSE)。
