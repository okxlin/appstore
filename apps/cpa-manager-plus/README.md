# CPA Manager Plus

## 产品介绍
CPA Manager Plus 是面向 Cli-Proxy-API 的增强管理与观测面板，支持管理页面、请求监控、兼容接口和本地数据加密存储。

## 主要功能
- 独立部署的管理与观测面板
- 支持通过 UI 连接现有 CPA 实例
- 管理员密钥、SQLite 数据和加密密钥本地持久化
- 支持 `auto`、`subscribe`、`http`、`resp` 四种采集模式

## 访问说明
安装完成后访问：

```text
http://服务器IP:端口/management.html
```

如果未在表单中填写 `CPA_MANAGER_ADMIN_KEY`，应用首次启动时会在容器日志中输出一次随机生成的管理员密钥。登录后再填写 CPA URL 和 CPA Management Key 即可接入现有网关。

## 数据持久化
- `APP_DATA_DIR`：持久化 `/data`，保存 `usage.sqlite`、`data.key` 和其他本地运行数据

## Introduction
CPA Manager Plus is an enhanced management and observability panel for Cli-Proxy-API. It provides the management UI, request monitoring, compatibility endpoints, and local encrypted data storage.

## Features
- Standalone management and observability panel
- Connects to an existing CPA instance through the UI
- Persists the admin key, SQLite data, and encryption key locally
- Supports `auto`, `subscribe`, `http`, and `resp` collector modes

## 参考资料
- 源码: <https://github.com/seakee/CPA-Manager-Plus>
- 文档: <https://github.com/seakee/CPA-Manager-Plus/blob/main/README.md>
- Docker Compose: <https://github.com/seakee/CPA-Manager-Plus/blob/main/docker-compose.manager.yml>
