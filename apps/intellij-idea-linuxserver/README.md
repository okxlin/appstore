# IntelliJ IDEA

## 产品介绍
IntelliJ IDEA 是 JetBrains 提供的 Java IDE。本应用使用 LinuxServer.io 镜像，在浏览器中运行带 Web 桌面的 IntelliJ IDEA。

## 主要功能
- 通过浏览器访问 IntelliJ IDEA 桌面环境
- 使用 LinuxServer.io Selkies Web 桌面栈
- 支持 Basic Auth 保护访问入口
- 持久化 `/config` 目录保存 IDE 配置和用户数据

## 访问说明
安装后通过 `http://<服务器 IP>:3000` 或 `https://<服务器 IP>:3001` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 和 `PANEL_APP_PORT_HTTPS` 为准。登录账号密码使用安装表单中的 `CUSTOM_USER` 和 `PASSWORD`。

## Introduction
IntelliJ IDEA is a Java IDE by JetBrains. This app uses the LinuxServer.io image to run IntelliJ IDEA as a web-accessible desktop.

## Features
- Access the IntelliJ IDEA desktop from a browser
- Use the LinuxServer.io Selkies web desktop stack
- Protect the entry point with Basic Auth
- Persist the `/config` directory for IDE settings and user data

## 部署说明
- 本应用使用镜像 `linuxserver/intellij-idea`。
- 应用分类：Development。
- 支持架构：amd64。
- 可选版本：`latest`、`42026.1.20260505`。

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
| TITLE | 浏览器页面标题 | IntelliJ IDEA | 否 |
| SELKIES_UI_TITLE | Selkies 侧边栏标题 | Selkies | 否 |
| DASHBOARD | Selkies 仪表盘界面 | selkies-dashboard | 否 |
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像已启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
- 首次启动可能需要下载和初始化桌面环境，请等待容器日志显示服务就绪。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.jetbrains.com/idea/>
- 文档: <https://docs.linuxserver.io/images/docker-intellij-idea/>
- 源码: <https://github.com/linuxserver/docker-intellij-idea>
