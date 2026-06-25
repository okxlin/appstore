# Manyfold

## 应用简介
Manyfold 3D 模型管理。

英文说明：3D model library manager maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`0.142.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3214 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| LIBRARIES_PATH | 模型库目录 | ./data/libraries | 是 |
| REDIS_DATA_PATH | Redis 数据目录 | ./data/redis | 是 |
| DATABASE_URL | 数据库 URL | sqlite3:/config/manyfold.sqlite3 | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SECRET_KEY_BASE | 应用密钥 | b5a7a9e5b4254b3b8c858e733ecf50551819204cc8f7065f6810217202308a6f | 是 |
| REDIS_URL | Redis URL | redis://manyfold-redis:6379/0 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://manyfold.app/>
- 文档: <https://docs.linuxserver.io/images/docker-manyfold/>
- 源码: <https://github.com/linuxserver/docker-manyfold>
