# SSCMS 内容管理系统

## 应用简介
开源免费、企业级、可商用的CMS内容管理系统。

英文说明：Open source free, enterprise-class, commercially available CMS content management system.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`7.4.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40221 | 是 |

## 数据持久化
- `./data:/app/wwwroot`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | sscms | 是 |
| PANEL_DB_USER | 数据库用户 | sscms | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | sscms | 是 |
| SSCMS_SECURITY_KEY | 通信密钥 (GUID 字符串) | e2a3d303-ac9b-41ff-9154-930710af0845 | 是 |
| SSCMS_REDIS_CONNECTION_STRING | Redis 连接信息 (redis:6379,password=123456) | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://sscms.com>
- 文档: <https://sscms.com/docs>
- 源码: <https://github.com/siteserver/cms>
