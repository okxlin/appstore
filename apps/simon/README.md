# Simon

> **高权限提示**：Simon 的核心 Docker 监控功能需要只读挂载 `/var/run/docker.sock`。Docker socket 即使以只读文件挂载，也能访问具有宿主机控制能力的 Docker API。只应将此应用部署在受信任的服务器上，并使用强 bcrypt 密码哈希保护界面。

## 产品介绍

Simon 是一个轻量级系统监控面板，提供实时主机指标、历史趋势、Docker 容器状态和日志查看。

## 主要功能

- 查看 CPU、内存、磁盘、网络和磁盘 I/O 指标
- 查看 Docker 容器状态、资源使用和日志
- 在 SQLite 中保存历史指标和告警配置
- 支持 Telegram、ntfy 和自定义 Webhook 告警

## 访问说明

安装表单要求填写 bcrypt 密码哈希。可在受信任的终端中使用兼容的 bcrypt 工具生成成本为 12 的哈希；不要填写明文密码。

本包只读挂载 `/sys` 和 Docker socket，并将 SQLite 数据保存在版本目录的 `data` 目录。默认不挂载宿主机根目录，也不启用文件浏览，避免向 Web 界面暴露任意宿主文件。

卸载时是否删除监控历史由 1Panel 的数据删除选项决定。卸载不会停止、删除或修改被监控的其他容器。

## Introduction

Simon is a lightweight monitoring dashboard for live host metrics, historical trends, Docker container status, and logs.

## Features

- Displays host CPU, memory, disk, network, and I/O metrics
- Lists Docker containers and exposes their resource usage and logs
- Stores monitoring history and alert configuration in SQLite
- Keeps host-root file browsing disabled in this package
