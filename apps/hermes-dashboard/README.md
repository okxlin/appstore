# Hermes Dashboard

## 产品介绍

Hermes Dashboard 是 Hermes Agent 的可选 Web 管理界面，用于连接已有 Hermes gateway，并管理会话、配置和 Agent 功能。

## 主要功能

- 浏览器访问 Hermes Agent 的 Web Dashboard。
- 连接已有 gateway 并复用同一份 Hermes 数据目录。
- 使用上游原生 Basic Auth 保护非本机监听地址。
- 持久化会话签名密钥，使登录状态可跨容器重启保持。

## 访问说明

- 请先部署 Hermes Agent，并将 `APP_DATA_DIR` 指向 Hermes Agent 的同一份数据目录。
- `GATEWAY_HEALTH_URL` 应填写 Hermes gateway 的完整可访问地址。
- 安装完成后，使用表单中设置的 Dashboard 用户名和密码登录。

## Introduction

Hermes Dashboard is the optional web interface for Hermes Agent. It connects to an existing gateway and provides browser access to sessions, configuration, and agent features.

## Features

- Browser-based Hermes Agent dashboard.
- Shared data directory and gateway connection.
- Upstream Basic Auth for non-loopback binds.
- Stable session signing across container restarts.

## 部署说明

- 本应用使用 Docker Compose 在 1Panel 中部署。
- 支持 `amd64`、`arm64` 架构。
- 提供滚动更新的 `latest` 和与主镜像标签一致的数字版本目录；实际版本以当前目录中的 Compose 配置为准。
- Dashboard 固定使用 `dashboard --host 0.0.0.0 --no-open` 启动。新版上游已将 `--insecure` 设为无效选项，公开绑定必须配置认证 Provider。
- 容器使用 `HERMES_UID` / `HERMES_GID` 访问共享数据目录，建议与 Hermes Agent 保持一致。

## 参数

| 参数 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Dashboard 端口 | 9119 | 是 |
| APP_DATA_DIR | Hermes Agent 数据目录 | /opt/1panel/apps/local/hermes-agent/hermes-agent/data | 是 |
| HERMES_UID | Hermes 运行用户 UID | 10000 | 是 |
| HERMES_GID | Hermes 运行用户 GID | 10000 | 是 |
| GATEWAY_HEALTH_URL | 网关健康检查 URL | http://172.18.0.240:8642 | 是 |
| DASHBOARD_USERNAME | Dashboard 用户名 | admin | 是 |
| DASHBOARD_PASSWORD | Dashboard 密码 | 随机生成 | 是 |
| DASHBOARD_SESSION_SECRET | Dashboard 会话签名密钥 | 随机生成 | 是 |

## 升级说明

- 从旧版本升级时，脚本只会为缺失或空白的认证变量生成随机值，不会覆盖已有配置。
- 自动生成的升级密码不会打印到日志。升级完成后请在 1Panel 应用参数中设置自己知道的密码，再访问 Dashboard。
- 已废弃的 `DASHBOARD_RUN_COMMAND` 可能仍保留在旧安装的 `.env` 中，但新 Compose 不再读取该变量，无需手动清理。

## 安全提示

- Dashboard 可以访问 Hermes 配置、API Key 和运行能力，请不要在无额外网络保护的情况下直接暴露到公网。
- 密码由上游 Basic Auth 插件在内存中使用 scrypt 哈希校验；明文值由 1Panel 应用参数保存，不会写入 `config.yaml` 或启动日志。
- 会话签名密钥应保持随机且稳定。修改它会使现有登录会话失效。

## 参考资料

- 官网: <https://hermes-agent.nousresearch.com/docs/>
- Docker 文档: <https://hermes-agent.nousresearch.com/docs/user-guide/docker>
- 源码: <https://github.com/NousResearch/hermes-agent>
