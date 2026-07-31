# nxv

## 产品介绍

nxv 是 Nix 软件包历史版本索引服务。它下载并验证上游预构建索引，在浏览器界面和 HTTP API 中快速查询软件包版本、出现时间及对应的 nixpkgs 提交。

## 主要功能

- 按软件包名、版本和描述检索 nixpkgs 历史
- 查看软件包版本时间线和对应提交
- 提供 Web 界面、OpenAPI 文档和 HTTP API
- 使用 SQLite 与 Bloom Filter 提供本地快速查询

## 访问说明

- 首次安装需要下载并验证约 220 MB 的压缩索引，完成前主服务不会启动；实际磁盘占用会高于下载大小。
- 索引保存在数据目录中，重启不会重复下载完整索引；重新安装前请按需要备份或清理该目录。
- nxv 本身不提供用户认证。不要直接暴露到不受信任的公网，建议通过 1Panel 网站反向代理配置访问控制。
- 固定版本用于可复现部署，`latest` 会跟随上游镜像更新。

## Introduction

nxv indexes historical nixpkgs releases and exposes fast package-version search through a web interface and HTTP API. The first installation downloads and verifies an index of about 220 MB before the server starts. Keep the data directory persistent to avoid unnecessary downloads.

## Features

- Searches package names, versions, and descriptions across nixpkgs history
- Shows version timelines and the corresponding nixpkgs commits
- Provides a web interface, OpenAPI documentation, and an HTTP API
- Uses a local SQLite index and Bloom filter for fast queries

nxv does not provide built-in authentication. Restrict public access with 1Panel reverse-proxy authentication or another trusted access-control layer.
