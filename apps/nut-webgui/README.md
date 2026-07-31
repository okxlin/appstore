# NUT Web GUI

## 产品介绍

NUT Web GUI 是 Network UPS Tools（NUT）的轻量级 Web 界面，用于查看 UPS 状态、变量和事件。

## 主要功能

- 自动刷新 UPS 状态和变量
- 提供 JSON API、事件 WebSocket 和 OpenMetrics 指标
- 支持多个 NUT 服务器、TLS 和可选身份认证
- 可按 NUT 用户权限执行 `INSTCMD`、`SET VAR` 和 FSD 操作

## 访问说明

本应用不包含 NUT 服务端，也不直接访问 UPS 硬件。安装前需要准备一个从 1Panel 容器网络可访问的 `upsd` 地址和端口；如果 `upsd` 需要认证，请同时填写用户名和密码。

默认使用普通 Docker bridge 网络，不启用 host network。若 NUT 服务运行在同一宿主机，请填写宿主机在 Docker 网络中可访问的地址，不能使用容器内的 `127.0.0.1`。

配置文件和会话签名密钥保存在版本目录的 `data` 目录。卸载时是否删除该目录由 1Panel 的数据删除选项决定。卸载不会向外部 NUT 服务发送控制命令。

## 安全说明

用于只读监控的 NUT 账号不应授予 `INSTCMD` 或 FSD 权限。仅在明确需要远程控制 UPS 时才提升外部 NUT 用户权限。

## Introduction

NUT Web GUI is a lightweight interface for viewing status, variables, and events from Network UPS Tools servers.

## Features

- Refreshes UPS status and variables automatically
- Provides JSON, WebSocket event, and OpenMetrics endpoints
- Connects to an external NUT server over an ordinary container network
- Persists configuration and the generated session-signing key
