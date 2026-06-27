# ErisPulse

## 产品介绍
ErisPulse 是一个事件驱动的多平台机器人开发框架，内置 Dashboard，可用于集中管理适配器、插件和运行状态。

## 主要功能
- 通过 Dashboard 管理机器人框架配置
- 支持 QQ、Telegram、Kook、云湖、Matrix、邮件等多平台扩展
- 支持容器内热更新框架、适配器和插件
- 持久化配置目录和 Python packages 卷，减少重建容器后的重复安装

## 访问说明
安装后访问 `http://<服务器 IP>:8000/Dashboard`，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。首次访问时使用安装表单中生成或填写的 Dashboard 登录令牌。

## Introduction
ErisPulse is an event-driven multi-platform bot framework with a built-in Dashboard for managing adapters, plugins and runtime status.

## Features
- Manage bot framework configuration from the Dashboard
- Extend to QQ, Telegram, Kook, Yunhu, Matrix, email and other platforms
- Update the framework, adapters and plugins from inside the container
- Persist the configuration directory and Python packages volume across container rebuilds

## 部署说明
- 本应用使用镜像 `erispulse/erispulse:latest`。
- 应用分类：Tool。
- 支持架构：amd64、arm64。
- 框架更新应在 Dashboard 内完成，容器启动时不再自动切换 stable/dev 频道。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Dashboard Web 访问端口 | 8000 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | ErisPulse 配置目录 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| ERISPULSE_DASHBOARD_TOKEN | Dashboard 登录令牌 | 随机生成 | 是 |
| ERISPULSE_LANG | Docker 启动界面和日志语言，留空自动检测 | 留空 | 否 |
| CONTAINER_NAME | 容器名称和 packages 卷名前缀 | erispulse | 是 |

## 使用说明
- 安装完成后，浏览器访问 `http://<IP>:<端口>/Dashboard`。
- 使用安装时设置的 Dashboard 令牌登录。
- 在 Dashboard 中配置适配器、插件和框架更新。
- 数据路径下的配置文件会在首次启动时自动生成。
- `packages` 命名卷会绑定容器名称，用于持久化 Dashboard 热更新安装的 Python 包。
- 当前上游 Dashboard 模块会在容器启动日志中打印 Dashboard 访问令牌。请将容器日志视为敏感信息，分享日志前先脱敏，并在令牌泄露后及时修改 `DATA_PATH/config.toml` 中的 `Dashboard.token`。
- 本次维护审计中，Trivy 对 `erispulse/erispulse:latest` 的 Debian 基础层报告了若干 High/Critical CVE，主要涉及 perl、ncurses、sqlite 等系统包且暂无 fixed version。建议保持镜像更新，并按需限制 Dashboard 的公网暴露范围。

## 参考资料
- 官网: <https://www.erisdev.com>
- 项目仓库: <https://github.com/ErisPulse/ErisPulse>
- Docker Hub: <https://hub.docker.com/r/erispulse/erispulse>
