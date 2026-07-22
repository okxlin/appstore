# SshWifty

## 应用简介

SshWifty 是一款基于浏览器的 SSH 与 Telnet 客户端，允许通过 Web 浏览器直接访问 SSH 和 Telnet 服务。

## 产品介绍

SshWifty 使用 Go 构建后端、JavaScript 构建前端。无需在本地安装 SSH 客户端，打开浏览器即可连接远程服务器。

## 主要功能

- 通过 Web 浏览器连接 SSH 服务
- 通过 Web 浏览器连接 Telnet 服务
- 无需本地 SSH 客户端
- 支持 TLS（可通过反向代理或环境变量配置）

## 访问说明

- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 默认端口为 `8182`，可通过 `PANEL_APP_PORT_HTTP` 自定义。
- 打开 Web UI 后，输入目标主机地址、端口和凭据即可建立 SSH/Telnet 连接。
- 建议通过反向代理或防火墙限制访问，避免将 Web SSH 客户端直接暴露到公网。

## 数据持久化

SSHwifty 默认通过环境变量加载运行配置，不需要持久化数据目录。

## 配置说明

| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web UI 端口 | 8182 | 是 |
| TZ | 时区 | Asia/Shanghai | 是 |

## Introduction

SshWifty is a browser-based SSH and Telnet client that allows accessing SSH and Telnet services from the web browser.

## Features

- Connect to SSH services through the web browser
- Connect to Telnet services through the web browser
- No local SSH client required
- TLS support via reverse proxy or environment variables

## References

- GitHub：<https://github.com/nirui/sshwifty>
- Docker Hub：<https://hub.docker.com/r/niruix/sshwifty>
