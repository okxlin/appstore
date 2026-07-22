# Yaak

## 产品介绍
Yaak 是一个由 LinuxServer.io 提供容器镜像的桌面 API 客户端，可通过浏览器管理和执行 REST、GraphQL 与 gRPC 请求。

## 主要功能
- 组织和调试 REST、GraphQL 与 gRPC API 请求
- 通过浏览器访问容器化桌面界面
- 使用 Basic Auth 保护 Web 入口

## 访问说明
- HTTP 入口默认使用 `PANEL_APP_PORT_HTTP`，容器端口为 `3000`。
- HTTPS 入口默认使用 `PANEL_APP_PORT_HTTPS`，容器端口为 `3001`。
- 实际访问端口以安装表单和 1Panel 应用详情为准。

## Introduction
Yaak is a desktop API client distributed through a LinuxServer.io container image and exposed through a browser-accessible interface.

## Features
- Organize and execute REST, GraphQL, and gRPC requests
- Access the containerized desktop interface from a browser
- Protect the web entry point with Basic Auth

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64、arm64。
- 可选版本：`latest` 与仓库当前提供的固定版本；固定版本目录会随上游发布更新。
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
| TITLE | 浏览器页面标题 | Yaak | 否 |
| DASHBOARD | Selkies 仪表盘界面 | selkies-dashboard | 否 |
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像已启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 安全提示
- LinuxServer 桌面镜像包含图形桌面、基础系统和配套工具，镜像扫描器可能报告继承自这些组件的 High 或 Critical 漏洞；固定镜像版本不代表不存在已知漏洞。
- 请及时更新应用，仅向可信网络开放访问端口，使用随机生成的强 Basic Auth 密码，并优先通过 HTTPS 反向代理提供外部访问。

## 参考资料
- 官网: <https://yaak.app/>
- 文档: <https://docs.linuxserver.io/images/docker-yaak/>
- 源码: <https://github.com/linuxserver/docker-yaak>
