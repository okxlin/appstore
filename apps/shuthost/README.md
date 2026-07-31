# ShutHost

## 产品介绍

ShutHost 使用 Wake-on-LAN 和轻量主机代理统一管理局域网内 Linux、macOS 和 Windows 主机的启动、关机与在线状态。

## 主要功能

- 通过 Web 界面和 API 管理多台主机。
- 发送 Wake-on-LAN 广播并向主机代理发送经过认证的关机请求。
- 使用 Token 保护 Web 界面，并将配置、会话和状态保存到 SQLite。
- 支持租约、Webhook、OIDC 和自定义生命周期钩子。

## 访问说明

- 为了发送 Wake-on-LAN 广播，本应用按上游要求使用 `host` 网络模式；配置的 HTTP 端口会直接监听在宿主机上。
- 首次登录使用安装表单生成的 Token。
- 实际控制主机前，需要按上游文档在目标主机安装代理，并妥善保存双方共享密钥。
- 卸载应用不会删除配置目录和 SQLite 数据库。

## Introduction

ShutHost manages the startup, shutdown, and online state of Linux, macOS, and Windows hosts using Wake-on-LAN and lightweight host agents.

## Features

- Manage multiple hosts through a web interface and API.
- Send Wake-on-LAN broadcasts and authenticated shutdown requests.
- Protect the web interface with token authentication and persist state in SQLite.
- Supports leases, webhooks, OIDC, and lifecycle hooks.

## 参考资料

- 源码：<https://github.com/9SMTM6/shuthost>
- 部署示例：<https://github.com/9SMTM6/shuthost/tree/main/docs/examples>
- 安全说明：<https://github.com/9SMTM6/shuthost/blob/main/docs/security_considerations.md>
