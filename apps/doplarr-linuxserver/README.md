# Doplarr

## 应用简介
Doplarr Discord 媒体请求机器人。

英文说明：Discord media request bot maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`3.8.0`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DISCORD_TOKEN | Discord 机器人令牌 | replace-with-discord-bot-token | 是 |
| OVERSEERR_API | Overseerr API 密钥 | replace-with-overseerr-api-key | 否 |
| OVERSEERR_URL | Overseerr 地址 | http://localhost:5055 | 否 |
| RADARR_API | Radarr API 密钥 | - | 否 |
| RADARR_URL | Radarr 地址 | http://localhost:7878 | 否 |
| SONARR_API | Sonarr API 密钥 | - | 否 |
| SONARR_URL | Sonarr 地址 | http://localhost:8989 | 否 |
| DISCORD_MAX_RESULTS | 最大搜索结果数 | 25 | 是 |
| DISCORD_REQUESTED_MSG_STYLE | 请求消息样式 | :plain | 是 |
| PARTIAL_SEASONS | 允许部分季请求 | true | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/kiranshila/Doplarr>
- 文档: <https://docs.linuxserver.io/images/docker-doplarr/>
- 源码: <https://github.com/linuxserver/docker-doplarr>
