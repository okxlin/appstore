# Thunderbird

## 产品介绍
Thunderbird 是一个开源邮件客户端，本应用通过 LinuxServer.io 镜像提供浏览器访问的 Thunderbird 桌面环境。

## 主要功能
- 通过浏览器访问 Thunderbird 邮件客户端。
- 使用 `/config` 持久化用户目录、账号配置和邮件数据。
- 通过 Basic Auth 保护 Web 桌面入口。

## 访问说明
安装完成后，通过应用表单中的 HTTP 或 HTTPS 端口访问 Web 桌面，并使用安装时填写的 Basic Auth 用户名和密码登录。

## Introduction
Thunderbird is an open-source email client. This app packages the LinuxServer.io image as a browser-accessible Thunderbird desktop environment.

## Features
- Access Thunderbird from a browser.
- Persist the user home, account settings, and mail data under `/config`.
- Protect the Web desktop entrypoint with Basic Auth.

## 应用简介
Thunderbird 邮件客户端。

英文说明：Thunderbird email client maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：邮件。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1140.12.0`。
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
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |
| SHM_SIZE | 共享内存大小 | 1gb | 是 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像默认无认证，本适配启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
- 如需公网访问，请优先放在带强认证的反向代理之后。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.thunderbird.net/>
- 文档: <https://docs.linuxserver.io/images/docker-thunderbird/>
- 源码: <https://github.com/linuxserver/docker-thunderbird>
