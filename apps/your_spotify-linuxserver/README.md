# Your Spotify

## 应用简介
Your Spotify 听歌统计面板。

英文说明：Spotify listening statistics dashboard maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.20.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 80 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 443 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MONGO_DATA_PATH | Mongo 数据目录 | ./data/mongo | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_URL | 应用访问 URL | http://localhost | 是 |
| SPOTIFY_PUBLIC | Spotify 客户端 ID | replace-with-client-id | 是 |
| SPOTIFY_SECRET | Spotify 客户端密钥 | replace-with-client-secret | 是 |
| SPOTIFY_API_DELAY_MS | Spotify API 延迟毫秒 | 2000 | 是 |
| CORS | CORS 来源 | all | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/Yooooomi/your_spotify>
- 文档: <https://docs.linuxserver.io/images/docker-your_spotify/>
- 源码: <https://github.com/linuxserver/docker-your_spotify>
