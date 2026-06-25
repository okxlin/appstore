# Nitter

## 应用简介
匿名浏览 Twitter 的开源工具。

英文说明：Alternative Twitter front-end.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40238 | 是 |
| REDIS_PORT | Redis服务端口 | 6379 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |
| STATIC_DIR | 静态文件目录 | ./public | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HOSTNAME | 主机名 | nitter.net | 是 |
| TITLE | 标题 | nitter | 是 |
| ADDRESS | 监听地址 (容器内) | 0.0.0.0 | 是 |
| HTTPS | 启用 HTTPS | false | 是 |
| HTTP_MAX_CONNECTIONS | 最大 HTTP 连接数 | 100 | 是 |
| LIST_MINUTES | 列表缓存分钟数 | 240 | 是 |
| RSS_MINUTES | RSS 缓存分钟数 | 10 | 是 |
| REDIS_HOST | Redis服务 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码 | - | 是 |
| REDIS_CONNECTIONS | Redis 连接数 | 20 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://nitter.net>
- 文档: <https://github.com/zedeus/nitter>
