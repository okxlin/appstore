# SyncLounge

## 应用简介
SyncLounge Plex 同步观看。

英文说明：Plex watch party service maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`5.2.35`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 8088 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| AUTH_LIST | 允许的 Plex 用户 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://synclounge.tv/>
- 文档: <https://docs.linuxserver.io/images/docker-synclounge/>
- 源码: <https://github.com/linuxserver/docker-synclounge>
