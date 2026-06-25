# Deluge

## 应用简介
跨平台的 BitTorrent 客户端。

英文说明：Cross-platform BitTorrent client.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`2.2.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40321 | 是 |
| DELUGE_PEER_PORT | Peer 端口 | 6881 | 是 |
| DELUGE_PORT_RPC | RPC 端口 | 58846 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | Deluge 配置路径 | ./data/config | 是 |
| DOWNLOAD_PATH | 下载路径 | ./data/downloads | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| DELUGE_LOGLEVEL | Deluge 日志级别 | error | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://deluge-torrent.org>
- 文档: <https://deluge.readthedocs.io>
- 源码: <https://github.com/linuxserver/docker-deluge>
