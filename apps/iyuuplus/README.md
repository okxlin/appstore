# IYUUPlus

## 应用简介
自动辅种工具。

英文说明：Automatic seeding tools.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40279 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| IYUU_PATH | IYUU 路径 | ./data/iyuu | 是 |
| DATA_PATH | 数据路径 | ./data/data | 是 |
| QBITTORRENT_PATH | QBittorrent 路径 | ./data/qbittorrent | 是 |
| INTERNAL_QBITTORRENT_PATH | 内部 QBittorrent 路径 | /qbittorrent | 是 |
| TRANSMISSION_PATH | Transmission 路径 | ./data/transmission | 是 |
| INTERNAL_TRANSMISSION_PATH | 内部 Transmission 路径 | /transmission | 是 |
| EXTERNAL_MOUNT_PATH | 外部挂载路径 | ./data/mnt | 是 |
| INTERNAL_MOUNT_PATH | 内部挂载路径 | /mnt | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <http://doc.iyuu.cn>
- 源码: <https://github.com/ledccn/iyuuplus-dev>
