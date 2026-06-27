# Pingap

## 产品介绍
Pingap 是基于 Cloudflare Pingora 的高性能反向代理和应用网关，支持 TOML 配置、热更新、Web 管理界面和多种网关插件。

## 主要功能
- 提供 HTTP/HTTPS 反向代理和应用网关能力
- 支持配置热更新，适合容器化部署
- 内置 Web 管理界面，可管理路由、上游和插件配置

## 访问说明
安装后通过 `http://<服务器 IP>:15079/pingap` 访问管理界面，实际 HTTP 端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Pingap is a high-performance reverse proxy and application gateway powered by Cloudflare Pingora, with hot reload, TOML configuration and a web admin interface.

## Features
- HTTP/HTTPS reverse proxy and application gateway
- Hot reload for containerized configuration changes
- Web admin interface for routes, upstreams and plugins

## 部署说明
- 本应用使用官方 Docker 镜像 `vicanso/pingap` 部署。
- 默认按官方 Compose 示例启用 `pingap --autoreload`。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 与管理界面端口，容器内映射到 `80` | 15079 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 代理端口，容器内映射到 `443` | 15443 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Pingap 配置和运行数据目录，挂载到容器 `/opt/pingap` | ./data | 是 |

升级、迁移或批量调整代理配置前，请先在 1Panel 中备份 `APP_DATA_DIR`。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PINGAP_ADMIN_USER | Web 管理界面用户名 | pingap | 是 |
| PINGAP_ADMIN_PASSWORD | Web 管理界面密码，安装时随机生成 | 随机生成 | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 管理界面路径固定为 `/pingap`，请使用安装时生成的管理员用户名和密码登录。
- 这是反向代理/应用网关类应用，对公网开放前请先配置强密码、访问控制、防火墙、安全组、TLS 证书和路由规则。
- HTTPS 端口默认仅做端口映射；请在 Pingap 内正确配置证书、SNI 和路由后再对外开放。
- 若代理内网服务，请确认 Pingap 容器与目标服务网络可达。

## 参考资料
- 项目仓库: <https://github.com/vicanso/pingap>
- Docker Compose 快速开始: <https://github.com/vicanso/pingap#getting-started>
- 官方文档: <https://pingap.io/pingap-en/docs/getting_started>
