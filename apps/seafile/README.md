# Seafile

## 应用简介
具有隐私保护和团队合作功能的开源云存储系统。

英文说明：An open source cloud storage system with privacy protection and teamwork features.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`13.0.24`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP端口 | 40130 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mysql | 是 |
| PANEL_DB_ROOT_PASSWORD | 数据库 root 密码 | mysql_root_password | 是 |
| ADMIN_EMAIL | 管理员邮箱 | admin@localhost.com | 是 |
| ADMIN_PASSWORD | 管理员密码 | seafile | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| MEMCACHED_TYPE | Memcached 服务 | memcached | 是 |
| SERVER_HOSTNAME | 服务端主机名 (域名 或 IP) | localhost.com | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.seafile.com>
- 文档: <https://manual.seafile.com>
- 源码: <https://github.com/haiwen/seafile>
