# Autobrr

## 产品介绍

Autobrr 是面向种子和 Usenet 的下载自动化工具。它监控索引站的实时公告，并将符合条件的发布内容发送到 qBittorrent、Deluge、Radarr、Sonarr 等下载客户端。

## 主要功能

- 通过 Web UI 配置 IRC 索引站、过滤规则和下载客户端。
- 使用内置 SQLite 数据库，不需要额外的数据库服务。
- 保留配置、SQLite 数据库和日志，重启后继续使用。

## 访问说明

- 默认 Web 端口：`7474`
- 容器内部端口：`7474`
- 安装完成后在浏览器打开 1Panel 中配置的端口，并完成 Autobrr 的初始设置。

## 数据与备份

- 配置和 SQLite 数据库位于应用的 `Data Directory` 中。
- 升级或迁移前请备份整个数据目录，包括 `autobrr.db`、`autobrr.db-wal` 和 `autobrr.db-shm`。
- 卸载会停止并移除容器，但不会删除数据目录。

## 版本

- `latest` 跟随官方 Autobrr 最新发布镜像。
- 固定版本目录用于可重复部署。

## 许可证

Autobrr 上游项目采用 GPL-2.0-only 许可证。

## Introduction

Autobrr is download automation for torrents and Usenet. It watches real-time indexer announcements and sends matching releases to clients such as qBittorrent, Deluge, Radarr, and Sonarr.

## Features

- Configure IRC indexers, filters, and download clients from the Web UI.
- Use the built-in SQLite database without an additional database service.
- Retain configuration, SQLite data, and logs across restarts.

## Access

- Default web port: `7474`
- Container port: `7474`
- Open the port configured in 1Panel after installation and complete Autobrr's initial setup.

## Data and Backup

- Configuration and the SQLite database are stored in the application `Data Directory`.
- Before upgrading or migrating, back up the entire data directory, including `autobrr.db`, `autobrr.db-wal`, and `autobrr.db-shm`.
- Uninstall stops and removes containers but keeps the data directory.
