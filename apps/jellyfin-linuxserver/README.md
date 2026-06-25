# Jellyfin

## 产品介绍
Jellyfin 是一个自托管媒体服务器，本应用使用 LinuxServer.io 镜像部署。

## 主要功能
- 通过浏览器和 Jellyfin 客户端管理、播放媒体库。
- 使用 `/config` 持久化服务器配置和元数据。
- 默认映射电视剧和电影两个媒体目录。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问 Web UI，并按 Jellyfin 初始化向导完成配置。

## Introduction
Jellyfin is a self-hosted media server. This app deploys the LinuxServer.io image.

## Features
- Manage and stream media libraries from browsers and Jellyfin clients.
- Persist server settings and metadata under `/config`.
- Map separate TV shows and movies media folders by default.

## 应用简介
Jellyfin 媒体服务器。

英文说明：Media server maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：多媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`10.11.11`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 8096 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| TVSHOWS_PATH | 电视剧媒体目录 | ./data/tvshows | 是 |
| MOVIES_PATH | 电影媒体目录 | ./data/movies | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| PUBLISHED_SERVER_URL | 自动发现返回地址 | 空 | 否 |

## 使用说明
- 默认仅开放 HTTP Web 端口；HTTPS、DLNA/发现 UDP 端口和硬件加速设备未默认映射。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://jellyfin.org/>
- 文档: <https://docs.linuxserver.io/images/docker-jellyfin/>
- 源码: <https://github.com/linuxserver/docker-jellyfin>

