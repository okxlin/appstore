# MDCX

## 应用简介
电影元数据搜刮器。

英文说明：Movie metadata scraper.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`20241003`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40301 | 是 |
| VNC_PORT | VNC 端口 | 40302 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/data | 是 |
| MDCX_CONFIG_PATH | MDCx 配置路径 | ./data/mdcx-config | 是 |
| MDCX_CONFIG_FILE | MDCx 配置文件 | ./data/mdcx-config/MDCx.config | 是 |
| LOGS_PATH | 日志路径 | ./data/logs | 是 |
| MEDIA_PATH | 媒体路径 | ./data/media | 是 |
| MEDIA_PATH_INTERNAL | 容器内部媒体路径 | /media | 是 |
| MEDIA_PATH_2 | 媒体路径 2 | ./data/media2 | 是 |
| MEDIA_PATH_INTERNAL_2 | 容器内部媒体路径 2 | /media2 | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DISPLAY_WIDTH | 显示宽度 | 1200 | 是 |
| DISPLAY_HEIGHT | 显示高度 | 750 | 是 |
| VNC_PASSWORD | VNC 密码 | password | 是 |
| USER_ID | 用户 ID | 1000 | 是 |
| GROUP_ID | 用户组 ID | 1000 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://hub.docker.com/r/stainless403/mdcx-builtin-gui-base>
- 文档: <https://github.com/northsea4/mdcx-docker>
