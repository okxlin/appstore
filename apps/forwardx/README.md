# ForwardX

## 产品介绍

ForwardX 是面向多台 Linux 服务器的端口转发、加密隧道、链路编排和流量管理面板。

## 主要功能

- 管理 TCP、UDP 与 TCP+UDP 转发规则。
- 编排 GOST、ForwardX、Nginx Stream 等隧道和多跳链路。
- 管理用户权限、套餐、流量统计、DDNS 故障转移和 Telegram 通知。

## 访问说明

安装后打开表单配置的 Web 端口，按照首次访问向导选择 SQLite 并创建管理员账号。SQLite 数据保存在配置的数据目录中。

## 部署说明

- 默认使用本地 SQLite，无需额外安装数据库。
- MySQL 与 PostgreSQL 可在应用首次设置或系统数据库迁移功能中另行配置。
- Agent 安装在需要管理的 Linux 主机上，面板容器本身不需要宿主机 Docker Socket。
- Telegram Bot Token 为可选项，也可在面板系统设置中配置。

## 安全与使用风险

ForwardX 可下发网络转发与防火墙相关操作到 Agent 主机。请妥善保护面板管理员账号、Agent Token 和第三方 API 凭据，只管理已授权的服务器，并限制管理端口的公网访问。

上游项目：https://github.com/poouo/Forwardx

## Introduction

ForwardX manages port forwarding, encrypted tunnels, link orchestration, and traffic across multiple Linux servers.

## Features

- Manage TCP, UDP, and combined forwarding rules.
- Orchestrate GOST, ForwardX, and Nginx Stream tunnels and multi-hop links.
- Manage permissions, plans, traffic statistics, DDNS failover, and Telegram notifications.

After installation, open the configured Web port, select SQLite in the first-run wizard, and create the administrator account. Protect panel credentials and Agent tokens, and only manage authorized hosts.
