# Ech0

## 产品介绍

Ech0 是轻量、开源、自托管的个人想法发布平台，可发布短文本、图片和链接，并提供 RSS、PWA、Webhook、MCP 与多语言界面。

## 主要功能

- 发布和管理个人想法、图片与外部链接。
- 提供 RSS 订阅、PWA、Webhook 和 MCP 接口。
- 支持 Owner、管理员和普通用户角色。
- 使用本地数据目录保存数据库和上传内容。

## 访问说明

- Web 端口由安装表单设置，默认 `6277`。
- 首次注册的账号会成为 Owner，请在安装后立即完成注册。
- 默认只有特权账号可以发布内容，其他用户需要由 Owner 或管理员授权。

## 数据持久化

- `APP_DATA_DIR` 挂载到 `/app/data`，保存数据库、配置和上传文件。
- 升级或迁移前应完整备份数据目录。
- `JWT_SECRET` 用于签发登录会话；升级时不要更换，否则现有会话会失效。

## 安全说明

- 安装表单会随机生成 JWT 密钥，不使用上游示例中的固定测试值。
- 对公网开放时应通过 1Panel 反向代理启用 HTTPS，并限制注册策略与管理员权限。
- 上传和发布内容可能包含私人信息，请设置适当的访问范围和备份策略。

## Introduction

Ech0 is a lightweight, open-source, self-hosted platform for publishing personal ideas, images, and links.

## Features

- Publish short posts, images, and links.
- Provide RSS, PWA, webhook, and MCP integrations.
- Manage Owner, administrator, and regular user roles.
- Persist database and uploaded content under `/app/data`.

## Links

- Website: https://ech0.app
- Project: https://github.com/lin-snow/Ech0
- Deployment guide: https://github.com/lin-snow/Ech0/blob/main/DEPLOYMENT.md
- Image: https://hub.docker.com/r/sn0wl1n/ech0
