# RSSHub

## 产品介绍
RSSHub 是一个开源、简单易用、易于扩展的 RSS 生成器，可将多种网站和服务内容转换为 RSS 订阅源。

本应用依赖 1Panel 中已安装的 Redis 服务。`latest` 版本使用独立 Browserless 服务提供浏览器能力，`chromium-bundled` 版本使用内置 Chromium 的 RSSHub 镜像。

## 主要功能
- 从网站、社交媒体、新闻源等生成标准 RSS。
- 使用 Redis 缓存 RSSHub 数据。
- 提供 `latest` 与 `chromium-bundled` 两个部署变体。
- 支持通过 1Panel 的端口外部访问开关控制 Web 端口绑定范围。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问：

```text
http://<服务器 IP>:<HTTP 端口>
```

如关闭 1Panel 的端口外部访问开关，Web 端口将绑定到 `127.0.0.1`，可配合反向代理或本机访问使用。

## Introduction
RSSHub is an open-source RSS generator that converts content from many websites and services into RSS feeds.

This app requires an existing Redis service in 1Panel. The `latest` variant uses a separate Browserless service, while `chromium-bundled` uses the RSSHub image with Chromium included.

## Features
- Generate RSS feeds from websites, social media, news sources, and other services.
- Use Redis as the RSSHub cache backend.
- Provide `latest` and `chromium-bundled` deployment variants.
- Respect the 1Panel external port access toggle for the Web port binding.

## 应用简介
一个开源、简单易用、易于扩展的 RSS 生成器。

英文说明：An open-source, easy-to-use, and easy-to-scale RSS generator.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`chromium-bundled`。
- 安装后按应用表单中的 HTTP 端口访问 Web UI。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40062 | 是 |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| REDIS_HOST | Redis服务 | - | 是 |
| REDIS_PASS | Redis服务密码 | - | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://docs.rsshub.app/>
- 源码: <https://github.com/DIYgod/RSSHub>
