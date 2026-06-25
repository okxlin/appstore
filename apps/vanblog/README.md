# VanBlog

## 应用简介
一款简洁实用优雅的个人博客系统。

英文说明：A simple, practical and elegant personal blog system.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`0.54.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40233 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 40234 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| EMAIL | 用于自动申请 https 证书的邮箱 | - | 否 |
| VAN_BLOG_CDN_URL | CDN 地址 | - | 否 |
| VAN_BLOG_WALINE_DB | 内嵌评论系统的数据库名 | waline | 否 |
| MONGO_HOST | 数据库服务 | - | 是 |
| MONGO_DB | 数据库名 | vanblog | 是 |
| PANEL_DB_ROOT_USER | 数据库用户名 | - | 是 |
| PANEL_DB_ROOT_PASSWORD | 数据库密码 | - | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://vanblog.mereith.com>
- 源码: <https://github.com/Mereithhh/vanblog>
