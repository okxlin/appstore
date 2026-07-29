# drawDB

## 产品介绍

drawDB 是一个在浏览器中使用的数据库实体关系图（ERD）编辑器。它无需注册账号，适合设计数据库结构和整理表之间的关系。

## 主要功能

- 创建数据库关系图并编辑表、字段和关系。
- 导入和导出 SQL，生成数据库迁移内容。
- 使用官方静态 Web 镜像，无需数据库、缓存或高风险主机权限。
- 提供 `amd64` 和 `arm64` 镜像。

## 访问说明

安装完成后，通过 1Panel 显示的 HTTP 端口访问 Web 界面。数字固定版本目录对应官方同名 `v` 前缀镜像标签，`latest` 跟随上游最新镜像。

服务端容器只提供静态 Web 应用，不挂载持久化目录，也不保存账号或数据库。请使用 drawDB 的导入、导出和下载功能保存重要设计；清理浏览器数据前应先导出项目。

## Introduction

drawDB is a browser-based entity relationship diagram editor for designing database schemas without creating an account.

## Features

- Create tables, fields, and relationships in a browser-based editor.
- Import and export SQL and generate migration content.
- Run the official static web image without a database, cache, or host-level permissions.
- Support both `amd64` and `arm64` images.

## 参考资料

- 官网：<https://drawdb.app/>
- 源码：<https://github.com/drawdb-io/drawdb>
- Docker 构建说明：<https://github.com/drawdb-io/drawdb/blob/main/README.md#docker-build>
