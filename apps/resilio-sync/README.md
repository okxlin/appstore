# Resilio Sync

## 应用简介
文件同步工具。

英文说明：File Sync Tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.1.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40237 | 是 |
| PANEL_APP_PORT_SYNC | 同步端口 | 55555 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/config | 是 |
| DOWNLOADS_PATH | 下载路径 | ./data/downloads | 是 |
| SYNC_PATH | 同步路径 | ./data/sync | 是 |
| EXTERNAL_MOUNT_PATH | 外部挂载路径 | ./data/mnt | 是 |
| INTERNAL_MOUNT_PATH | 内部挂载路径 | /mnt | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| USER_ID | 用户 ID | 1000 | 是 |
| GROUP_ID | 用户组 ID | 1000 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.resilio.com>
- 文档: <https://help.resilio.com>
