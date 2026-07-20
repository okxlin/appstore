# Kutt

## 产品介绍

Kutt 是一个自托管短链接服务，可创建、管理和统计短链接。

## 主要功能

- 首次启动时在网页创建管理员账号。
- 创建和管理短链接，支持自定义短链接地址。
- 默认使用 SQLite，不需要额外数据库服务。
- 数据库和自定义界面目录均可在安装表单中配置。

## 配置说明

- `公开访问域名` 必须填写用户实际访问 Kutt 的主机名或 `主机名:端口`，例如 `short.example.com` 或 `short.example.com:3000`；不要填写协议前缀。
- `JWT 密钥` 由 1Panel 随机生成，不应在升级时随意修改。
- 默认禁用注册和匿名短链接。需要开放这些功能时，可在安装表单中明确调整。
- 直接通过 HTTP 端口访问时，请保持 `信任反向代理` 为 `false`。仅在可信反向代理正确传递客户端地址时启用它。

## 访问说明

安装完成后，请使用 1Panel 显示的 HTTP 端口访问 Kutt。第一次打开会显示管理员创建页面；完成创建后即可登录并创建短链接。

## 数据与卸载

SQLite 数据保存在数据目录，界面定制文件保存在自定义目录。卸载应用会停止并移除容器，但不会删除这些主机目录；删除前请自行备份短链接数据。

## 参考资料

- 官网：<https://kutt.it/>
- 源码：<https://github.com/thedevs-network/kutt>
- Docker Compose：<https://github.com/thedevs-network/kutt/blob/main/docker-compose.yml>

## Introduction

Kutt is a self-hosted URL shortener for creating and managing short links.

## Features

- Create the administrator account in the browser on first start.
- Use SQLite by default without a separate database service.
- Keep link data and interface customizations in configurable host directories.
