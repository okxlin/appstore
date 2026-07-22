# Telegram Desktop

## 产品介绍
Telegram Desktop 是 Telegram 的桌面客户端，本应用通过 LinuxServer.io 镜像提供浏览器访问的 Telegram 桌面环境。

## 主要功能
- 通过浏览器访问 Telegram Desktop。
- 使用 `/config` 持久化用户目录和登录状态。
- 通过 Basic Auth 保护 Web 桌面入口。

## 访问说明
安装完成后，通过应用表单中的 HTTP 或 HTTPS 端口访问 Web 桌面，并使用安装时填写的 Basic Auth 用户名和密码登录。

## Introduction
Telegram Desktop is the desktop client for Telegram. This app packages the LinuxServer.io image as a browser-accessible Telegram desktop environment.

## Features
- Access Telegram Desktop from a browser.
- Persist the user home and login state under `/config`.
- Protect the Web desktop entrypoint with Basic Auth.

## 应用简介
Telegram 桌面客户端。

英文说明：Telegram desktop client maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 商店同时提供 `latest` 和固定版本目录；升级前请备份 `/config` 数据。
- 安装后按应用表单中的端口访问 Web 桌面。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3000 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 3001 | 是 |

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
| TITLE | 浏览器页面标题 | Telegram Desktop | 否 |
| DASHBOARD | Selkies 仪表盘界面 | selkies-dashboard | 否 |
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |
| SHM_SIZE | 共享内存大小 | 1gb | 是 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像默认无认证，本适配启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
- 如需公网访问，请优先放在带强认证的反向代理之后。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 安全说明
- 该完整桌面镜像包含浏览器、桌面环境和容器工具组件，镜像扫描可能报告与 Telegram 主程序无直接关系的 High 漏洞；固定版本标签不能消除这些上游依赖风险。
- 本应用不需要 Docker Socket、`privileged` 或 host network。请及时升级镜像，仅向可信来源开放 Web 端口，并保留 Basic Auth 或更强的反向代理认证。

## 参考资料
- 官网: <https://telegram.org/>
- 文档: <https://docs.linuxserver.io/images/docker-telegram/>
- 源码: <https://github.com/linuxserver/docker-telegram>
