# Snipo

## 产品介绍

Snipo 是一个面向单用户的轻量级代码片段管理器，支持在一个自托管实例中组织、搜索和分享多文件代码片段。

## 主要功能

- 多文件代码片段、语法高亮、文件夹、标签、搜索和历史记录
- 公开链接、软删除、过期时间和备份恢复
- 可按权限创建读、写和管理 API Token
- 使用内置 SQLite 数据库，无需外部数据库

## 访问说明

安装时设置主密码，随后通过 `http://<服务器 IP>:<端口>` 访问并登录。Snipo 只有一个共享的主密码和数据库，不提供多用户或租户隔离。默认绑定 `127.0.0.1`；远程访问应通过 1Panel 的 HTTPS 反向代理发布。

## 数据与安全

- 数据库、自动生成的加密盐和备份数据保存在 `APP_DATA_DIR` 中。相对路径会在安装时解析到应用级 `retained-data` 目录并按容器名隔离，卸载实例后仍会保留；绝对路径保持不变。升级或迁移前应备份 SQLite 数据库、WAL/SHM 文件和 `.encryption_salt`。
- 容器以 UID/GID `1000:1000` 运行，根文件系统只读，丢弃全部 Linux capabilities，并只提供一个小型可写 `/tmp`。
- 默认启用公开片段、API Token 和备份恢复功能，可在安装表单中关闭不需要的功能。
- 公开片段可由持有链接的任何人访问。对公网部署时应启用 HTTPS，并避免绕过反向代理直接访问应用端口。
- Snipo 启动时自动执行内置数据库迁移。升级后应检查 `/health` 并验证常用片段的读写和持久化。

## Introduction

Snipo is a lightweight, single-user snippet manager for organizing, searching, and sharing multi-file code snippets in one self-hosted instance.

## Features

- Multi-file snippets, syntax highlighting, folders, tags, search, and history
- Public links, soft deletion, expiration, and backup/restore
- Read, write, and administrative API tokens
- Embedded SQLite storage without an external database

## Usage And Security

- Set the master password during installation, then sign in at `http://<server-ip>:<port>`. Snipo has one shared password and database; it does not provide multi-user isolation.
- The service binds to `127.0.0.1` by default. Publish it remotely through a 1Panel HTTPS reverse proxy.
- `APP_DATA_DIR` stores the SQLite database, generated encryption salt, and backups. Relative paths are resolved into a per-container directory under the app-level `retained-data` directory so uninstalling an instance preserves them; absolute paths remain unchanged.
- The container runs as UID/GID `1000:1000`, uses a read-only root filesystem, drops all Linux capabilities, and receives only a small writable `/tmp`.
- Public snippets are accessible to anyone with their link. Review the public-sharing, API-token, and backup switches before exposing the service.

## References

- Project: <https://github.com/MohamedElashri/snipo>
- Stable release: <https://github.com/MohamedElashri/snipo/releases/tag/v1.7.4>
- Deployment guide: <https://github.com/MohamedElashri/snipo/blob/v1.7.4/docs/deployment.md>
- Security model: <https://github.com/MohamedElashri/snipo/blob/v1.7.4/SECURITY.md>
- License: <https://github.com/MohamedElashri/snipo/blob/v1.7.4/LICENSE> (AGPL-3.0)
