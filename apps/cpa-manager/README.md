# CPA Manager

## 产品介绍
CPA Manager 是面向 Cli-Proxy-API 的用量监控与管理面板，支持完整 Docker 模式和 CPA 面板模式，可将请求监控数据持久化到本地 SQLite。

> CPA Manager 已进入维护模式。新安装建议优先选择 CPA Manager Plus；保留本应用用于现有部署和迁移准备。

## 主要功能
- 独立部署的用量监控与管理面板
- 首次向导接入现有 CPA URL 与 Management Key
- 支持 `auto`、`subscribe`、`http`、`resp` 四种采集模式
- 本地持久化监控数据与配置

## 访问说明
安装完成后访问：

```text
http://服务器IP:端口/management.html
```

首次部署时需要在页面中填写 CPA URL 和 CPA Management Key。完成初始化后，后续浏览器只需要输入 Management Key 即可登录。

使用前需已有可访问的 CPA / Cli-Proxy-API 实例，并启用远程管理接口、设置 Management Key 和开启用量统计。

如需从其他设备访问，请在安装时开启端口外部访问，或在 1Panel 中配置反向代理。

## 数据持久化
- `APP_DATA_DIR`：持久化 `/data`，保存 `usage.sqlite` 与本地配置

## Introduction
CPA Manager is a usage monitoring and management panel for Cli-Proxy-API. It supports both full Docker mode and CPA panel mode, and persists monitoring data locally in SQLite.

CPA Manager is in maintenance mode. New installations should prefer CPA Manager Plus; this package remains available for existing deployments and migration preparation.

## Features
- Standalone usage monitoring and management panel
- First-run wizard for the CPA URL and Management Key
- Supports `auto`, `subscribe`, `http`, and `resp` collector modes
- Persists monitoring data and local configuration

## 参考资料
- 源码: <https://github.com/seakee/CPA-Manager>
- 文档: <https://github.com/seakee/CPA-Manager/blob/main/README.md>
- Docker Compose: <https://github.com/seakee/CPA-Manager/blob/main/docker-compose.usage.yml>
