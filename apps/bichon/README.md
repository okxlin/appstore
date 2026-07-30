# Bichon

## 产品介绍

Bichon 是使用 Rust 构建的自托管邮件归档服务，可从多个 IMAP 账户下载邮件，在本地建立全文索引，并通过内置 Web 界面和 REST API 提供统一检索。它是归档工具，不是用于撰写或发送邮件的客户端。

## 主要功能

- 多账户 IMAP 增量归档与定时同步
- 邮件、附件和联系人全文检索
- 内嵌元数据、索引和压缩对象存储，无外部数据库依赖
- 多用户 RBAC、账户级权限和 API token
- EML、MBOX、Thunderbird 和 PST 导入工具

## Features

- Incremental archiving and scheduled synchronization for multiple IMAP accounts
- Full-text search across messages, attachments, and contacts
- Embedded metadata, index, and compressed object stores with no external database
- Multi-user RBAC, account-level permissions, and API tokens
- Import tools for EML, MBOX, Thunderbird, and PST data

## Introduction

Bichon is a self-hosted email archiving service written in Rust. It downloads mail from multiple IMAP accounts, builds local full-text indexes, and exposes a unified WebUI and REST API. It is an archive, not a mail client for composing or sending messages.

## 访问说明

安装后通过 `http://<服务器 IP>:15630` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。首次登录用户名为 `admin`，密码为 `admin@bichon`。请登录后立即在设置页面修改默认密码，并通过 1Panel 网站反向代理启用 HTTPS 后再向不受信任网络开放服务。

## 参数说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| `PANEL_APP_PORT_HTTP` | Web 界面和 API 的 HTTP 端口 | `15630` | 是 |
| `APP_DATA_DIR` | 元数据、全文索引和邮件对象存储目录 | `./data` | 是 |
| `BICHON_ENCRYPT_PASSWORD` | 用于加密保存的 IMAP/OAuth 凭据 | 安装时随机生成 | 是 |
| `BICHON_PUBLIC_URL` | OAuth 回调和文档使用的公开 URL | 空 | 否 |
| `BICHON_LOG_LEVEL` | 服务日志级别 | `info` | 是 |

## 数据与安全

- 使用 Bichon 官方单服务镜像，容器按上游要求以 UID/GID `1000:1000` 运行。
- `APP_DATA_DIR` 必须位于本地文件系统；上游明确不支持 NFS、CIFS/SMB 等网络文件系统作为数据目录。
- `BICHON_ENCRYPT_PASSWORD` 用于派生 AES-256-GCM 加密密钥。上游当前不支持直接轮换该口令后重新加密已有凭据，因此应妥善保管，并在恢复备份时使用相同值。
- 可选 SMTP 接收器、TLS 文件和高级存储拆分未在默认安装中启用，可在确认上游配置与端口策略后手工扩展。

## 备份与升级

升级或迁移前，应停止 Bichon 并备份 `APP_DATA_DIR` 指向的完整目录以及安装时使用的加密口令。默认 `./data` 位于 1Panel 应用版本目录内，卸载时会随应用目录移除；若需要跨卸载保留归档，请选择独立绝对路径，并预先保证其所有权为 UID/GID `1000:1000`。

本应用只打包稳定版 `1.6.2`。截至本批次适配时，上游 `latest` 已指向 `2.0.0-alpha.1` 预发布镜像，因此没有将 `latest` 作为稳定版本交付。

## 参考资料

- 项目仓库: <https://github.com/rustmailer/bichon>
- Docker 安装说明: <https://github.com/rustmailer/bichon#docker-recommended>
- API 文档: 安装后访问 `/api-docs`
