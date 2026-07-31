# Pulse

## 产品介绍

Pulse 是一套基础设施监控与告警工具，可统一查看 Proxmox VE、Proxmox Backup Server、Docker、Kubernetes、TrueNAS 和 VMware 环境的状态、资源与历史指标。

## 主要功能

- 监控 Proxmox 节点、虚拟机、容器、存储、备份和复制任务
- 保存历史指标并提供阈值告警
- 支持 Proxmox、Docker、Kubernetes、TrueNAS 和 VMware
- 提供移动端适配界面、通知与运行状况视图

## 访问说明

安装时会创建一个 Pulse 管理员账号。管理员密码填写 `generate` 时，初始化脚本会生成一个 32 位随机密码并写入该版本目录的 `.env` 文件；也可以填写长度为 12 到 128 位的自定义密码。

安装完成后，在 Pulse 的基础设施设置中添加 Proxmox 节点。建议使用权限受限的 Proxmox API Token，并确保 Proxmox API 地址可从 `1panel-network` 访问。Pulse 默认使用端口 `7655`，状态和凭据保存在版本目录的 `data` 目录中。

本应用默认关闭 Pulse 使用情况遥测，也不挂载 Docker socket。Docker 更新操作保持禁用；卸载不会修改已连接的 Proxmox 节点。是否删除持久数据由 1Panel 卸载时的数据删除选项决定。

## Introduction

Pulse monitors Proxmox and other infrastructure platforms from one interface. It stores configuration, encrypted credentials, metrics history, and alert settings in the persistent data directory.

## Features

- Monitors Proxmox nodes, virtual machines, containers, storage, backups, and replication jobs
- Retains historical metrics and evaluates alert thresholds
- Supports Proxmox, Docker, Kubernetes, TrueNAS, and VMware
- Provides notifications and infrastructure health views
