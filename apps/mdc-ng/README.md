# MDC-NG

## 应用简介
你的次世代媒体库管理方案。

英文说明：Yet another Movie Data Capture tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`1.36.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40300 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/config | 是 |
| MEDIA_PATH | 媒体路径 | ./data/media | 是 |
| MEDIA_PATH_INTERNAL | 容器内部媒体路径 | /media | 是 |
| MEDIA_PATH_2 | 媒体路径 2 | ./data/media2 | 是 |
| MEDIA_PATH_INTERNAL_2 | 容器内部媒体路径 2 | /media2 | 是 |

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
- 官网: <https://hub.docker.com/r/mdcng/mdc>
- 文档: <https://github.com/mdc-ng/mdc-ng>
