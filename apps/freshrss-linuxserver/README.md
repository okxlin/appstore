# FreshRSS

## 产品介绍
FreshRSS 是一个自托管 RSS 阅读器，本应用使用 LinuxServer.io 镜像部署。

## 主要功能
- 订阅和阅读 RSS/Atom 源。
- 使用 `/config` 持久化配置和数据。
- 通过浏览器访问 Web UI。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问 Web UI，并按 FreshRSS 初始化页面完成配置。

## Introduction
FreshRSS is a self-hosted RSS reader. This app deploys the LinuxServer.io image.

## Features
- Subscribe to and read RSS/Atom feeds.
- Persist configuration and data under `/config`.
- Access the Web UI from a browser.

## 应用简介
FreshRSS RSS 阅读器。

英文说明：RSS reader maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64、armv7。
- 可选版本：`latest`、`1.29.1`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 80 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 首次访问时按 FreshRSS 页面向导完成初始化。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://freshrss.org/>
- 文档: <https://docs.linuxserver.io/images/docker-freshrss/>
- 源码: <https://github.com/linuxserver/docker-freshrss>
