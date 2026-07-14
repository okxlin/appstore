# Vikunja

## 产品介绍

Vikunja 是一个开源、自托管的任务和项目管理应用，支持列表、看板、甘特图、提醒、共享、附件和 CalDAV。

## 主要功能

- 列表、看板、甘特图和表格等多种任务视图
- 到期时间、提醒、重复任务、优先级和标签
- 项目共享、团队协作、附件和评论
- CalDAV、API 与数据导入

## 访问说明

- 默认 Web 端口为 `3456`，可在安装表单中修改。
- 首次访问后注册管理员使用的普通账户。创建所需账户后，建议把“允许注册”改为 `false`。
- 默认关闭 CORS，适用于浏览器和 API 使用同一访问地址的常见部署。如果需要跨域访问，请同时启用 CORS 并填写带 `http://` 或 `https://` 的公开 URL。

## 数据与安全

- 本应用包使用官方镜像的 SQLite 模式，数据库和附件分别保存在数据目录下的 `db` 与 `files` 子目录。Vikunja 官方建议较大规模部署改用 PostgreSQL 或 MySQL；本首版应用包暂不提供数据库服务联动。
- 安装脚本会生成并持久化服务密钥。数据根目录中的 `.vikunja_service_secret` 用于防止 1Panel 升级回放安装参数时轮换密钥，请与数据库一并备份，不要手动删除或提交到版本库。
- 官方镜像以 UID `1000` 运行。应用内的默认相对数据目录会自动设置为 `1000:1000`；若使用已有绝对数据目录，请先保证其 `db` 与 `files` 子目录属主为 `1000:1000`。
- SQLite 适合小型部署。升级、迁移或更换数据库前应先备份数据库和附件目录。

## Introduction

Vikunja is an open-source, self-hosted task and project management application with list, Kanban, Gantt, reminder, sharing, attachment and CalDAV features.

This package uses the official image in SQLite mode and persists the database and attachments separately. Keep `.vikunja_service_secret` with your backups so upgrades do not rotate the service secret. Disable registration after creating the required accounts. If CORS is enabled, configure a public URL including the `http://` or `https://` scheme.

## Features

- List, Kanban, Gantt and table task views
- Due dates, reminders, recurring tasks, priorities and labels
- Project sharing, team collaboration, attachments and comments
- CalDAV, API access and data imports

## 参考资料

- 安装文档：<https://vikunja.io/docs/installing/>
- Docker 完整示例：<https://vikunja.io/docs/full-docker-example/>
- 配置选项：<https://vikunja.io/docs/config-options/>
- 源码仓库：<https://github.com/go-vikunja/vikunja>
- 官方镜像：<https://hub.docker.com/r/vikunja/vikunja>
