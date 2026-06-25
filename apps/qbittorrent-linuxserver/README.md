# qBittorrent

## 应用简介
qBittorrent 下载客户端。

英文说明：qBittorrent download client.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`5.2.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 8080 | 是 |
| PANEL_APP_PORT_BT_DOWNLOAD_LISTENER | BT下载监听端口 | 6881 | 是 |
| PANEL_APP_PORT_BT_DOWNLOAD_DHT_LISTENER | BT下载DHT监听端口(UDP) | 6881 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| DOWNLOAD_PATH | 下载文件路径 | ./data/downloads | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.linuxserver.io/blog>
- 文档: <https://docs.linuxserver.io/images/docker-qbittorrent/>
- 源码: <https://github.com/linuxserver/docker-qbittorrent>
