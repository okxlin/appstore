# Wiki-Go

## 产品介绍

Wiki-Go 是一个使用 Go 构建的轻量级自托管 Wiki。内容以 Markdown 文件保存，无需外部数据库，支持全文搜索、页面层级、版本历史、附件、评论、用户角色和访问规则。

## 主要功能

- 创建、编辑和组织 Markdown 页面
- 全文搜索、页面版本历史和附件管理
- 管理员、编辑者和查看者角色
- 按路径设置公开、私有或用户组访问规则
- 支持 Mermaid、数学公式、看板和评论

## 访问说明

- 默认仅监听服务器回环地址；建议通过加入 `1panel-network` 的 1Panel 反向代理访问
- 初始管理员用户名和密码均为 `admin`
- 首次登录后必须立即修改管理员密码，然后再开放远程访问
- 默认配置允许 HTTP 登录 Cookie，仅适用于回环地址或可信反向代理链路
- 公网部署应使用 HTTPS，并在 `data/config.yaml` 中将 `allow_insecure_cookies` 改为 `false` 后重启应用
- Wiki 配置、账户、页面、附件、版本和会话均持久化在当前安装目录的 `data` 目录

## Introduction

Wiki-Go is a lightweight self-hosted wiki written in Go. It stores content as Markdown files without an external database and provides search, page hierarchies, version history, attachments, comments, user roles and access rules.

## Features

- Create, edit and organize Markdown pages
- Full-text search, page history and attachment management
- Administrator, editor and viewer roles
- Public, private and group-based path access rules
- Mermaid diagrams, math, Kanban boards and comments

## First Access

- The package binds to the server loopback address by default; use a 1Panel reverse proxy on `1panel-network`
- The initial administrator username and password are both `admin`
- Change the administrator password immediately after the first login, before enabling remote access
- HTTP login cookies are enabled only for the default loopback or trusted reverse-proxy topology
- For public deployment, use HTTPS, set `allow_insecure_cookies` to `false` in `data/config.yaml`, and restart the app
- Configuration, accounts, pages, attachments, history and sessions persist in the selected installation's `data` directory

Upstream documentation: <https://github.com/leomoon-studios/wiki-go/blob/master/README.md>
