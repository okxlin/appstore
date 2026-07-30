# TrailBase

## 产品介绍

TrailBase 是一个基于 Rust、SQLite 和 WebAssembly 构建的轻量级应用后端。它以单个可执行程序提供数据库、身份认证、实时记录 API、管理界面和扩展运行时，适合为 Web、移动端和桌面应用快速搭建自托管后端。

## 主要功能

- 内置 SQLite 数据库和可视化管理界面
- 提供身份认证、记录 API 和实时订阅能力
- 支持通过管理界面创建表、索引、视图和数据记录
- 支持 WebAssembly 服务端扩展
- 以非 root 用户运行，应用数据集中保存在 TrailBase 数据目录

## 访问说明

安装完成后访问：

```text
http://服务器地址:端口/_/admin/
```

TrailBase 首次启动时会自动创建 `admin@localhost` 管理员，并将随机生成的初始密码输出到容器日志。请在 1Panel 的容器日志中查找 `Created new admin user`，使用该账号登录，然后立即在管理界面中修改邮箱和密码。应用包不会保存或预设管理员密码。

## 数据与备份

安装表单中的“数据目录”会挂载到容器的 `/app/traildepot`。该目录保存数据库、配置、密钥、迁移和上传内容，卸载应用时不会删除。升级前应完整备份此目录；TrailBase 当前仍处于快速迭代阶段，跨版本升级前还应阅读上游发行说明。

## 安全建议

- 不要公开初始管理员密码，首次登录后立即更换凭据。
- 公网部署时建议通过 1Panel 反向代理启用 HTTPS，并限制管理界面的访问来源。
- TrailBase 默认允许较宽的 API 跨域来源；请根据实际客户端和上游文档收紧部署边界。
- 数据目录包含数据库和认证密钥，应限制宿主机访问权限并纳入备份。

## Introduction

TrailBase is a lightweight application backend built with Rust, SQLite, and WebAssembly. It provides a database, authentication, real-time record APIs, an administration dashboard, and an extension runtime from a single executable.

On first start, TrailBase creates the `admin@localhost` administrator and prints a randomly generated password to the container logs. Sign in at `/_/admin/`, then change the initial email and password immediately. The selected data directory contains databases, configuration, secrets, migrations, and uploaded data and is preserved when the app is uninstalled.

## Features

- SQLite database and administration dashboard
- Authentication and real-time record APIs
- Table, index, view, and row management
- WebAssembly server extension runtime
- Non-root execution with one persistent data directory

## 来源

- 项目主页：https://trailbase.io
- 安装文档：https://trailbase.io/getting-started/install/
- 源代码：https://github.com/trailbaseio/trailbase
- 官方镜像：https://hub.docker.com/r/trailbase/trailbase
