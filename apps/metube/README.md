# MeTube

## 应用简介
媒体下载工具。

英文说明：Media downloader tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40289 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOWNLOAD_DIR | 下载目录 | ./data | 是 |
| AUDIO_DOWNLOAD_DIR | 音频下载目录 | /downloads/audio | 否 |
| STATE_DIR | 状态目录 | /downloads/.metube | 是 |
| TEMP_DIR | 临时目录 | /downloads/temp | 否 |
| DOWNLOAD_DIRS_INDEXABLE | 目录可索引 | false | 是 |
| CUSTOM_DIRS | 自定义目录 | true | 是 |
| CREATE_CUSTOM_DIRS | 创建自定义目录 | true | 是 |
| URL_PREFIX | URL 前缀 | / | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| UID | 用户 ID | 1000 | 是 |
| GID | 用户组 ID | 1000 | 是 |
| DEFAULT_THEME | 默认主题 | auto | 是 |
| DELETE_FILE_ON_TRASHCAN | 删除文件 | false | 是 |
| PUBLIC_HOST_URL | 公共主机 URL | - | 否 |
| PUBLIC_HOST_AUDIO_URL | 公共音频主机 URL | - | 否 |
| DEFAULT_OPTION_PLAYLIST_STRICT_MODE | 严格播放列表模式 | false | 是 |
| DEFAULT_OPTION_PLAYLIST_ITEM_LIMIT | 播放列表项限制 | 0 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/alexta69/metube>
