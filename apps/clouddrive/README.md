# CloudDrive

## 应用简介
一个强大的多云盘管理工具。

英文说明：A powerful multi-cloud drive management tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：存储。
- 支持架构：amd64。
- 可选版本：`latest`、`1.0.10`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40275 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CLOUDDRIVE_HOME | CloudDrive 根目录 | /Config | 是 |
| CLOUD_MOUNTS_PATH | 云挂载路径 | ./data/CloudNAS | 是 |
| APP_DATA_PATH | 应用数据路径 | ./data/Config | 是 |
| SHARED_MEDIA_PATH | 共享媒体路径 | ./data/media | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PRIVILEGED_MODE | 特权模式 | true | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.clouddrive2.com>
- 源码: <https://hub.docker.com/r/cloudnas/clouddrive2>
