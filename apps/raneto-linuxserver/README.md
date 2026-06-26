# Raneto

## 产品介绍
Raneto 是一个 Markdown 知识库应用，本应用使用 LinuxServer.io 镜像部署。

## 主要功能
- 使用 Markdown 文件维护知识库页面。
- 使用 `/config` 持久化配置和内容。
- 通过浏览器访问 Web UI。

## 访问说明
安装完成后，通过应用表单中的 HTTP 端口访问 Raneto。

## Introduction
Raneto is a Markdown knowledge base app. This app deploys the LinuxServer.io image.

## Features
- Maintain knowledge base pages with Markdown files.
- Persist configuration and content under `/config`.
- Access the Web UI from a browser.

## 应用简介
Raneto 知识库。

英文说明：Knowledge base maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64、arm64、armv7。
- 可选版本：`latest`、`0.18.1`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3000 | 是 |

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
- Markdown 内容和配置保存在 CONFIG_PATH 对应目录中。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://raneto.com/>
- 文档: <https://docs.linuxserver.io/images/docker-raneto/>
- 源码: <https://github.com/linuxserver/docker-raneto>
