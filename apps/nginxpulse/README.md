# Nginx Pulse

## 应用简介
轻量级 Nginx 访问日志分析与可视化面板。

英文说明：Lightweight Nginx Access Log Analysis and Visualization Dashboard.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 8088 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| LOG_PATH | Nginx日志路径 | /opt/1panel/www/sites | 是 |
| DATA_PATH | 数据文件夹路径 | ./data/data | 是 |
| CONFIGS_PATH | 配置文件夹路径 | ./data/configs | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | postgresql | 是 |
| PANEL_DB_NAME | 数据库名 | nginxpulse | 是 |
| PANEL_DB_USER | 数据库用户 | nginxpulse | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | nginxpulse | 是 |
| ACCESS_KEYS | 访问密码 | - | 是 |

## 使用说明
### 常见问题

1) 日志明细无内容  
通常是容器内无权限访问宿主机日志文件。请先阅读《Docker 部署权限说明》并按步骤处理权限。

2) 日志存在，但 PV/UV 无法统计  
默认规则会排除内网 IP。若你希望统计内网流量，请将 `PV_EXCLUDE_IPS` 设为空数组并重启：
```bash
PV_EXCLUDE_IPS='[]'
```
重启后在“日志明细”页面点击“重新解析”按钮。

3) 日志时间不正确  
通常是运行环境时区未同步导致。请确认 Docker/系统时区正确，并按“时区设置（重要）”章节调整后重新解析日志。

4) 无法启动
报错 tmp 目录无权限写入问题（旧版本可能出现），如果容器启动后出现如下所示的报错，请确认 `nginxpulse_data` 可写（具体权限问题请阅读《Docker 部署权限说明》），或设置 `TMPDIR` 到可写目录。
```bash
nginxpulse: initializing postgres data dir at /app/var/pgdata
/app/entrypoint.sh: line 91: can't create /tmp/tmp.KOdAPn: Permission denied
```
解决办法（任选其一）：
```bash
-e TMPDIR=/app/var/nginxpulse_data/tmp
```

5) 解析入库的数据会一直保留吗  
不会。入库后的访问数据会按 `system.logRetentionDays` 定时清理（默认 30 天）。  
例如你一次解析了几个月数据，后续仍会逐步清理掉保留天数之外的数据。  
注意：该参数不影响原始 Nginx 日志文件，也不等于系统运行日志（`var/nginxpulse_data/nginxpulse.log`）的轮转策略。

## 参考资料
- 官网: <https://github.com/likaia/nginxpulse>
