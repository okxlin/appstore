# Jellyfin

## 应用简介
多媒体应用程序软件套装。

英文说明：Multimedia application software suite.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`10.11.11`、`nyanmisaka-latest`、`unstable`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 网页端口 | 8096 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MEDIA_FOLDER_PATH | 媒体文件夹路径 | ./data/media | 是 |
| CACHE_FOLDER_PATH | 缓存文件夹路径 | ./data/cache | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://jellyfin.org/>
- 文档: <https://jellyfin.org/docs/>
- 源码: <https://github.com/jellyfin/jellyfin>
