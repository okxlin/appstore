# Grocy

## 应用简介

Grocy 是一款自托管的家用 ERP 系统，帮助家庭管理食品库存、购物清单、家务计划和物资消耗。

## 产品介绍

Grocy 基于 PHP 构建，使用 SQLite 作为默认数据库。本应用使用 LinuxServer 社区维护的多架构 Docker 镜像，开箱即用。

## 主要功能

- 食品库存管理与过期提醒
- 购物清单
- 家务计划与跟踪
- 物资消耗记录
- 食谱与膳食计划
- 多用户支持

## 访问说明

- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 默认端口为 `80`，可通过 `PANEL_APP_PORT_HTTP` 自定义。
- 首次访问时，使用默认管理员账号登录（具体请参考 Grocy 官方文档）。
- 数据保存在 `APP_DATA_DIR` 映射的 `/config` 目录中。

## 数据持久化

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 数据目录（映射到容器 /config） | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web UI 端口 | 80 | 是 |
| APP_DATA_DIR | 数据目录 | ./data | 是 |
| PUID | 用户 ID | 1000 | 是 |
| PGID | 用户组 ID | 1000 | 是 |
| TZ | 时区 | Asia/Shanghai | 是 |

## Introduction

Grocy is a self-hosted home ERP system for managing groceries, household chores, and inventory.

## Features

- Food stock management with expiration tracking
- Shopping list
- Chore planning and tracking
- Consumption logging
- Recipes and meal planning
- Multi-user support

## References

- 官网 / Website：<https://grocy.info>
- GitHub：<https://github.com/grocy/grocy>
- Docker 镜像 / Image：<https://github.com/linuxserver/docker-grocy>
