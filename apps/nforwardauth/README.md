# nforwardauth

## 产品介绍

nforwardauth 是一个轻量级 Forward Auth 服务，可让 Traefik、Caddy、Nginx 和其他反向代理通过同一个登录页面保护多个站点。

## 主要功能

- 使用本地 passwd 文件验证用户名和密码
- 通过签名 Cookie 在多个受保护站点之间共享登录状态
- 可向上游应用传递 `X-Forwarded-User` 请求头
- 内置登录限速，支持安全 Cookie 和自定义 Cookie 域

## 访问说明

安装时填写认证服务对外使用的域名、管理员账号和强密码。应用会在本地生成 SHA-512 密码哈希，明文密码不会写入 passwd 文件。

nforwardauth 必须由支持 Forward Auth 或 `auth_request` 的反向代理调用。直接打开应用端口只能访问登录服务，不能自动保护其他站点。生产环境应通过 HTTPS 发布认证域名，并保持“安全 Cookie”为启用状态。

应用数据保存在版本目录的 `data` 目录中。卸载时是否删除该目录由 1Panel 的数据删除选项决定。

## 安全说明

认证域名、Cookie 域和被保护站点必须属于同一受信任域范围。仅在受控的纯 HTTP 局域网测试环境中关闭安全 Cookie。

## Introduction

nforwardauth is a lightweight forward-auth service that lets Traefik, Caddy, Nginx, and other reverse proxies protect multiple sites with one login page.

## Features

- Validates users from a locally generated passwd file
- Shares signed login sessions across protected sites
- Integrates with reverse proxies through Forward Auth or `auth_request`
- Supports secure cookies, rate limiting, and `X-Forwarded-User`
