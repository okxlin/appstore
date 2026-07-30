# SilverBullet

## 产品介绍

SilverBullet 是一个可编程、私有、基于浏览器的个人知识库。内容以普通 Markdown 文件保存在 Space 中，并提供双向链接、任务、查询和 Space Lua 扩展能力。

## 主要功能

- 在浏览器中创建和编辑 Markdown 页面
- 支持 Wiki 风格链接、反向链接和页面检索
- 提供任务、对象、查询和模板能力
- 通过 Space Lua 扩展命令和页面行为
- 使用普通文件保存内容，便于备份和迁移

## 访问说明

- Web 端口由安装表单设置，默认 `3000`。
- 使用安装时填写的用户名和随机生成的密码登录。
- 上游要求远程访问时使用 TLS；对公网开放前应通过 1Panel 反向代理启用 HTTPS。

## 数据持久化

- `SPACE_DIR` 挂载到容器内的 `/space`，保存 Markdown 页面和 SilverBullet 的索引状态。
- 升级、迁移或卸载前应备份该目录。
- 重启和版本更新会复用同一 Space 目录。

## 安全说明

- 安装表单会生成认证密码，不使用固定默认凭据。
- 不要将未启用 TLS 的服务直接暴露到不可信网络。
- Space 中保存的是用户笔记和索引状态，应限制目录权限并纳入备份策略。

## Introduction

SilverBullet is a programmable, private, browser-based personal knowledge base built around plain Markdown pages.

## Features

- Create and edit Markdown pages in a browser
- Navigate with wiki-style links, backlinks, and search
- Use tasks, objects, queries, and templates
- Extend behavior with Space Lua
- Back up and migrate content as ordinary files

## Links

- Website: https://silverbullet.md
- Project: https://github.com/silverbulletmd/silverbullet
- Docker guide: https://silverbullet.md/Install/Docker
- Image: https://github.com/silverbulletmd/silverbullet/pkgs/container/silverbullet
