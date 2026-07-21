# WineGUI

## 产品介绍

WineGUI 是由 LinuxServer.io 维护的 Wine 管理桌面，可通过浏览器访问图形界面并运行兼容的 Windows 应用。

## 主要功能

- 通过浏览器使用 Wine 图形桌面。
- 使用 Basic Auth 保护 Web 访问。
- 持久化桌面配置和应用数据。
- 支持自定义页面标题、侧边栏和桌面语言。

## 访问说明

- 本应用使用 Docker Compose 在 1Panel 中部署。
- 支持架构：amd64。
- 安装后通过应用表单设置的 HTTP 或 HTTPS 端口访问 Web UI。
- 使用安装时配置的 `CUSTOM_USER` 和 `PASSWORD` 登录。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3000 | 是 |
| PANEL_APP_PORT_HTTPS | Https 端口 | 3001 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| CUSTOM_USER | Basic Auth 用户名 | admin | 是 |
| PASSWORD | Basic Auth 密码 | 随机生成 | 是 |
| TITLE | 浏览器页面标题 | WineGUI | 否 |
| DASHBOARD | Selkies 仪表盘界面 | selkies-dashboard | 否 |
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像已启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 安全提示

- 本应用使用上游官方 `linuxserver/winegui` 镜像。该镜像包含完整图形桌面和 Wine 运行环境，镜像扫描结果可能包含较多继承自基础系统和桌面组件的 High / Critical 漏洞条目。
- 建议仅在可信网络中部署，及时更新镜像，并通过 Basic Auth、反向代理访问控制和最小端口暴露降低风险。

## Introduction

WineGUI is a browser-accessible Wine management desktop maintained by LinuxServer.io for running compatible Windows applications.

## Features

- Browser-based Wine desktop.
- Basic Auth protection for web access.
- Persistent desktop configuration and application data.
- Configurable page title, sidebar, dashboard, and locale.

## Access

Open the configured HTTP or HTTPS port and sign in with the `CUSTOM_USER` and `PASSWORD` values chosen during installation. Keep the service behind trusted-network or reverse-proxy access controls when possible.

The upstream image includes a full graphical desktop and Wine environment. Image scanners may report inherited High or Critical vulnerabilities from base-system and desktop components; keep the image updated and minimize external exposure.

## 参考资料
- 官网: <https://gitlab.melroy.org/melroy/winegui>
- 文档: <https://docs.linuxserver.io/images/docker-winegui/>
- 源码: <https://github.com/linuxserver/docker-winegui>
