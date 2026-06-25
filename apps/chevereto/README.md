# Chevereto

## 应用简介
一个图像托管平台。

英文说明：An image hosting platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`4.5.4`、`server-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40328 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CHEVERETO_IMAGES_PATH | 图片路径 | ./data/images | 是 |
| CHEVERETO_HOSTNAME_PATH | 主机名路径 | / | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | chevereto | 是 |
| PANEL_DB_USER | 数据库用户 | chevereto | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | chevereto | 是 |
| CHEVERETO_MAX_POST_SIZE | 最大 POST 大小 | 2G | 是 |
| CHEVERETO_MAX_UPLOAD_SIZE | 最大上传大小 | 2G | 是 |
| CHEVERETO_SERVICING | 服务模式 | docker | 是 |
| CHEVERETO_HOSTNAME | 主机名 | hostname.com | 是 |
| CHEVERETO_HEADER_CLIENT_IP | 客户端 IP 标头 | X-Real-IP | 是 |
| ENCRYPTION_KEY | 加密密钥 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://chevereto.com>
- 文档: <https://chevereto.com/docs>
- 源码: <https://github.com/chevereto/chevereto>
