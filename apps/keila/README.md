# Keila

## 产品介绍

Keila 是一款开源的自托管新闻简报与邮件营销平台，可用于管理联系人、订阅表单、邮件模板和营销活动，并支持 SMTP、AWS SES、SendGrid、Mailgun 与 Postmark 等发送渠道。

## 主要功能

- 管理联系人、分组、订阅表单、模板和新闻简报活动。
- 提供可视化、Markdown 和纯文本邮件编辑能力。
- 支持公开订阅页面、活动统计和 API。
- 业务数据保存在 PostgreSQL，本地上传文件保存在独立持久化目录。

## 部署拓扑

- 本应用包只运行一个 Keila service，使用上游官方 `pentacent/keila` 镜像。
- 安装时必须选择同一 1Panel 中已运行的 PostgreSQL Runtime；1Panel 会为 Keila 创建独立数据库和独立用户。
- 上游示例 Compose 中的 PostgreSQL service 已替换为 1Panel Runtime 联动，不会在应用包中重复部署数据库。
- SMTP 是生产启动的必填依赖，但属于用户提供的外部服务，不会作为 sidecar 安装。

## 访问说明

默认 Web 端口为 `4000`。安装后访问 `http://服务器地址:安装端口/auth/login`，使用安装表单中的初始管理员邮箱和密码登录。

- `公开访问主机` 只填写域名或 IP，不包含 `http://`、`https://` 或路径。
- 直接按端口访问时，公开 URL 端口通常与 Web 端口相同。
- 通过反向代理发布 HTTPS 时，公开 URL 协议应设为 `https`，公开 URL 端口通常设为 `443`；反向代理必须正确转发 WebSocket。
- 初始管理员只在空数据库第一次启动时创建。后续修改安装参数不会重置已有管理员密码，请在 Keila 中管理账号。
- 上游要求管理员密码至少 10 个字符；会话密钥应为至少 64 个字符的强随机值。

## SMTP

Keila 在生产模式启动时必须配置系统 SMTP，用于注册、激活和密码重置等邮件。

- SMTP 用户名在上游可回退为发件邮箱；本应用包要求显式填写，以兼容用户名与发件邮箱不同的服务。
- 端口 `587` 通常配合 STARTTLS，端口 `465` 通常配合 SSL/TLS。具体组合以邮件服务商文档为准。
- SMTP 密码、数据库密码、管理员密码和会话密钥都会写入 1Panel 生成的运行时 `.env`，不得提交到 Git 或复制到公开日志。

## 数据、备份与升级

- Keila 会在启动时自动执行 PostgreSQL schema migration，并在空数据库中创建初始 root 用户。
- 联系人、活动、模板、账号和任务队列数据位于所选 PostgreSQL Runtime 的独立数据库中。
- 用户上传文件位于 `${APP_DATA_DIR}/uploads`，容器内路径为 `/opt/app/uploads`。
- 升级前必须同时备份 PostgreSQL 数据库和 `${APP_DATA_DIR}/uploads`。升级期间等待数据库 migration 完成后再停止或重启容器。
- 固定版和 `latest` 使用相同的持久化边界；回滚时应恢复与目标版本匹配的升级前数据库及上传文件备份。
- 卸载应用不会删除所选 PostgreSQL Runtime 本身；是否删除 Keila 的独立数据库和用户取决于 1Panel 卸载选项。卸载前请完成备份。

## 安全与许可证

- Compose 不启用 privileged、host network、额外 capability、设备映射或 Docker Socket。
- 建议通过 1Panel 反向代理启用 HTTPS，并限制管理入口的公网暴露范围。
- Keila 源代码采用 GNU Affero General Public License v3.0 或更高版本。部署、修改或向网络用户提供服务时，请遵守上游许可证义务。
- 上游 README 说明 Keila 标志不包含在 AGPL 授权中；标志权利归其权利人，本应用包仅将其用于识别对应产品。

## 参考资料

- 官网：<https://www.keila.io/>
- 官方安装文档：<https://www.keila.io/docs/installation>
- 官方配置文档：<https://www.keila.io/docs/configuration>
- 官方首次启动文档：<https://www.keila.io/docs/setup>
- 源码与官方 Compose：<https://github.com/pentacent/keila>

## Introduction

Keila is an open-source self-hosted newsletter and email marketing platform. This package runs one official Keila container, links it to a selectable PostgreSQL Runtime managed by 1Panel, and persists local uploads separately.

Production startup requires SMTP configuration. Keila automatically runs database migrations and creates the initial root user on an empty database. Back up both PostgreSQL and `${APP_DATA_DIR}/uploads` before upgrades.

## Features

- Contact, segment, subscription-form, template, and newsletter campaign management.
- Visual, Markdown, and plain-text email editing.
- PostgreSQL-backed application data and a persistent local upload directory.
- Explicit initial administrator, public URL, SMTP, and session-secret configuration.
