# Blinko

## 应用简介
一款开源、自托管的个人笔记工具。

英文说明：An open-source, self-hosted personal note tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.8.8`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 1111 | 是 |
| PANEL_DB_PORT | 数据库端口号 | 5432 | 是 |

## 数据持久化
- `"./data:/app/.blinko`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| NEXTAUTH_URL | 基本 URL | http://1.2.3.4:1111 | 是 |
| NEXT_PUBLIC_BASE_URL | 公共基本 URL | http://1.2.3.4:1111 | 是 |
| NEXTAUTH_SECRET | NextAuth 密钥 | my_ultra_secure_nextauth_secret | 是 |
| PANEL_DB_HOST | PostgreSQL 数据库服务 | - | 是 |
| PANEL_DB_NAME | 数据库名 | blinko | 是 |
| PANEL_DB_USER | 数据库用户 | blinko | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | blinko | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://blinko-demo.vercel.app>
- 文档: <https://blinko-doc.vercel.app/intro.html>
- 源码: <https://github.com/blinko-space/blinko>
