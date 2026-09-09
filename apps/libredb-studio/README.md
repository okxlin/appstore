# LibreDB Studio

## 产品介绍

LibreDB Studio 是一个 MIT 许可、自托管、基于浏览器的数据库 IDE，支持 PostgreSQL、MySQL、Oracle、SQL Server、SQLite、MongoDB、Redis、ClickHouse、Elasticsearch 等 16 种引擎。首次启动时管理员密码会打印到容器日志（零配置）。

这里列出的数据库引擎是应用连接目标，应用商店包本身只运行 LibreDB Studio，不会自动安装 PostgreSQL、Redis 或其他数据库服务。

## 主要功能

- 一个浏览器界面管理 16 种数据库引擎
- SSO (OIDC)、RBAC 与查询审计日志（免费版内置）
- ER 图、EXPLAIN 可视化、模式对比

## 访问说明

- 默认端口 3000（PANEL_APP_PORT_HTTP）
- 安装后访问：http://<server-ip>:<port>
- 首次登录密码见容器日志

## Introduction

LibreDB Studio is an MIT-licensed, self-hosted, browser-based database IDE and client for 16 engines: PostgreSQL, MySQL, Oracle, SQL Server, SQLite, libSQL, DuckDB, MongoDB, Redis, Couchbase, ClickHouse, Druid, Elasticsearch, OpenSearch, Apache Trino and Apache Cassandra.

The listed database engines are connection targets. This AppStore package runs LibreDB Studio as a single service and does not provision PostgreSQL, Redis, or other database servers.

## Features

- One browser interface for 16 database engines
- SSO (OIDC), RBAC and query audit logs in the free build
- ER diagrams, EXPLAIN visualization and schema comparison
- Website: https://libredb.org
- Repository: https://github.com/libredb/libredb-studio
- On first run the admin password is printed to the container log (zero-config). Default port 3000.
