# Altus

## 产品介绍
Altus 是一款支持多账号和主题的 WhatsApp 桌面客户端。本应用使用 LinuxServer.io 维护的 Web 访问镜像在 1Panel 中部署。

## 主要功能
- 通过浏览器使用 Altus 桌面界面
- 支持多 WhatsApp 账号和界面主题
- 支持 Basic Auth 访问保护
- 持久化保存桌面配置和应用数据

## 访问说明
安装后通过表单中配置的 HTTP 或 HTTPS 端口访问 Web UI。对外网提供服务时建议优先使用 HTTPS，并设置强 Basic Auth 密码。

## Introduction
Altus is a WhatsApp desktop client with multiple-account and theme support. This package deploys the web-accessible image maintained by LinuxServer.io in 1Panel.

## Features
- Use the Altus desktop interface from a web browser
- Manage multiple WhatsApp accounts and interface themes
- Protect access with Basic Auth
- Persist desktop configuration and application data

## 应用简介
Altus WhatsApp 桌面客户端。

英文说明：WhatsApp desktop client maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可用版本以 1Panel 应用商店展示为准。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

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
| TITLE | 浏览器页面标题 | Altus | 否 |
| DASHBOARD | Selkies 仪表盘界面 | selkies-dashboard | 否 |
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像已启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 安全风险
- 镜像包含完整桌面和浏览器运行环境，当前漏洞扫描仍会报告尚无上游修复版本的 Critical/High 基础系统组件漏洞。
- 本次版本审计未发现相比上一版本新增的 High/Critical 项，但这不代表镜像无漏洞。
- 请保持镜像更新，避免直接暴露到公网，并配合 HTTPS、强密码及访问控制使用。

## Security risks
- This image contains a complete desktop and browser runtime. Current vulnerability scans still report Critical/High issues in base-system packages for which no upstream fixed version is available.
- The release review found no new High/Critical findings compared with the previous packaged release, but this does not mean the image is vulnerability-free.
- Keep the image updated, avoid direct public exposure, and use HTTPS, strong credentials, and network access controls.

## 参考资料
- 官网: <https://github.com/amanharwara/altus>
- 文档: <https://docs.linuxserver.io/images/docker-altus/>
- 源码: <https://github.com/linuxserver/docker-altus>
