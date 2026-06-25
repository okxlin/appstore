# Plex Media Server

## 应用简介
Plex 媒体服务器。

英文说明：Plex Media Server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.43.2`、`official-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 32400 (TCP) | 32400 | 是 |
| PANEL_APP_PORT_TCP_3005 | 端口 3005 (TCP) | 3005 | 是 |
| PANEL_APP_PORT_TCP_8324 | 端口 8324 (TCP) | 8324 | 是 |
| PANEL_APP_PORT_TCP_32469 | 端口 32469 (TCP) | 32469 | 是 |
| PANEL_APP_PORT_UDP_1900 | 端口 1900 (UDP) | 1900 | 是 |
| PANEL_APP_PORT_UDP_32410 | 端口 32410 (UDP) | 32410 | 是 |
| PANEL_APP_PORT_UDP_32412 | 端口 32412 (UDP) | 32412 | 是 |
| PANEL_APP_PORT_UDP_32413 | 端口 32413 (UDP) | 32413 | 是 |
| PANEL_APP_PORT_UDP_32414 | 端口 32414 (UDP) | 32414 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| LIBRARY_PATH | Library 路径 | ./data/library | 是 |
| TVSERIES_PATH | 电视剧路径 | ./data/tv | 是 |
| MOVIES_PATH | 电影路径 | ./data/movies | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIMEZONE | 时区 | Asia/Shanghai | 是 |
| VERSION | Plex 版本来源 | docker | 是 |
| PLEX_CLAIM | Plex 认证令牌 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.plex.tv>
- 文档: <https://support.plex.tv>
- 源码: <https://github.com/plexinc/pms-docker>
