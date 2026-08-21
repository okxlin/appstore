# OxiCloud

## 产品介绍

OxiCloud 是一个使用 Rust 构建的自托管云存储平台，提供文件管理、共享、搜索、WebDAV、日历和通讯录等功能。

## 主要功能

- 在浏览器中上传、下载、整理和搜索文件
- 文件共享、回收站、收藏夹和缩略图
- WebDAV、CalDAV、CardDAV 和 Nextcloud 兼容接口
- 本地磁盘、S3 兼容存储和 Azure Blob 存储后端
- 密码、Magic Link 和 OIDC 身份验证

## 访问说明

- 安装后通过 `http://<服务器 IP>:8086` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。
- 首次打开时按页面提示创建管理员账户。
- `OXICLOUD_BASE_URL` 应填写用户实际访问 OxiCloud 的公开 HTTP 或 HTTPS 地址，以便生成正确的分享链接和回调地址。

## 数据库和存储

- 安装时选择 1Panel 中已运行的 PostgreSQL 服务。1Panel 会创建并关联独立的数据库与用户，OxiCloud 启动时自动执行数据库迁移。当前 1Panel 会将关联用户创建为 PostgreSQL 超级用户；在共享数据库实例上，这不是强隔离边界。面向不受信任用户或高价值数据时，应为 OxiCloud 使用专用 PostgreSQL 实例。
- 应用版本目录下的 `./data` 固定挂载到容器 `/app/storage`，保存文件内容、上传临时数据和自动生成的 JWT 密钥。升级、迁移或卸载前请备份该目录及 PostgreSQL 数据库。
- 数据库密码由 1Panel 生成并写入应用环境文件；不要提交或共享安装后的 `.env`。
- 当前镜像的数据库初始化模块会在 `INFO` 级别错误输出未脱敏连接串。本应用包通过 `RUST_LOG` 将该模块限制为 `WARN`，防止数据库凭据进入 Docker 日志；升级镜像后仍应复核此项。
- 应用包在容器启动时对 PostgreSQL 用户名、密码和数据库名进行 URI 编码，因此表单允许的 URL 保留字符不会改变连接凭据。

## 安全说明

- OxiCloud 支持大文件和分块上传。公开部署时应同时在反向代理中设置合适的请求体大小、超时和访问控制。
- 默认允许用户注册。仅供受控用户使用时，请在首次管理员初始化后将 `OXICLOUD_DISABLE_REGISTRATION` 改为 `true`。
- 使用 HTTPS 反向代理时，将 `OXICLOUD_BASE_URL` 设置为 HTTPS 地址，并保护应用数据目录、数据库和备份。
- 启用 S3、Azure、OIDC 或 SMTP 时，相关凭据会进入应用环境；仅授予必要权限并避免在日志或工单中泄露。

## Introduction

OxiCloud is a self-hosted cloud storage platform built with Rust, providing file management, sharing, search, WebDAV, calendar, and address-book capabilities.

## Features

- Upload, download, organize, and search files in the browser
- Share links, trash, favorites, and media thumbnails
- WebDAV, CalDAV, CardDAV, and Nextcloud-compatible APIs
- Local disk, S3-compatible, and Azure Blob storage backends
- Password, magic-link, and OIDC authentication

The version directory's `./data` is mounted at `/app/storage` for file content, upload staging data, and the generated JWT key. Back up this directory and the PostgreSQL database before upgrades, migrations, or uninstalling.

1Panel currently creates linked PostgreSQL roles as superusers. A linked role is therefore not a strong isolation boundary on a shared PostgreSQL instance; use a dedicated PostgreSQL instance for untrusted users or high-value data. The package URI-encodes PostgreSQL credential components at container startup so reserved characters accepted by the form retain their literal meaning.

## References

- Website: <https://oxicloud.app/>
- Source: <https://github.com/AtalayaLabs/OxiCloud>
- Documentation: <https://atalayalabs.github.io/OxiCloud/>
- Official deployment guide: <https://atalayalabs.github.io/OxiCloud/config/deployment.html>
