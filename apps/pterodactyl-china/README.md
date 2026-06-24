# Pterodactyl (翼龙中国版)

## 应用简介
一个免费的开源游戏服务器管理面板（前端）。

英文说明：open-source game server management panel(panel).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：游戏。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.13.0.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40222 | 是 |
| MAIL_PORT | 邮件端口 | 1025 | 是 |

## 数据持久化
- `./data/var/:/app/var/`
- `./data/nginx/:/etc/nginx/http.d/`
- `./data/certs/:/etc/letsencrypt/`
- `./data/logs/:/app/storage/logs`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| USER_UID | 用户 UID | 1000 | 是 |
| USER_GID | 用户 GID | 1000 | 是 |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_NAME | 数据库名 | pterodactyl | 是 |
| PANEL_DB_USER | 数据库用户 | pterodactyl | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | pterodactyl | 是 |
| PANEL_APP_URL | 外部访问地址 | http://localhost:40222 | 是 |
| PANEL_REDIS_DB_HOST | 缓存服务服务 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | 缓存服务服务密码 | - | 是 |
| MAIL_FROM | 预设作者邮箱 | noreply@example.com | 是 |

## 使用说明
### 默认账户

- 账户：**admin**
- 密码：**123456**

**！！！请一定一定一定要进后台用户页将你的账户信息进行修改，否则很容易被他人访问！！！**

## 参考资料
- 官网: <https://pterodactyl.top/>
- 源码: <https://github.com/pterodactyl-china/panel>
