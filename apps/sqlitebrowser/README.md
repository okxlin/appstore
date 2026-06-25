# DB Browser for SQLite

## 应用简介
一款高质量、可视化、开源的 SQLite 文件管理工具。

英文说明：A high-quality, visual, open-source SQLite file management tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：DevTool。
- 支持架构：amd64。
- 可选版本：`latest`、`3.13.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40210 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 40211 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| HTTP_USER | HTTP 用户 | user | 是 |
| HTTP_PWD | HTTP 密码 | sqlitebrowser | 是 |
| TITLE | 浏览器页面标题 | DB Browser for SQLite | 否 |
| SELKIES_UI_TITLE | 侧边栏标题 | Selkies | 否 |
| DASHBOARD | 仪表盘界面，可选 selkies-dashboard、selkies-dashboard-zinc、selkies-dashboard-wish | selkies-dashboard | 否 |
| CUSTOM_USER | Basic Auth 用户名 | admin | 是 |
| PASSWORD | Basic Auth 密码 | 随机生成 | 是 |
| LC_ALL | 桌面语言区域，例如 zh_CN.UTF-8 | zh_CN.UTF-8 | 否 |

## 使用说明
- 浏览器/桌面类 LinuxServer 镜像已启用 Basic Auth，请使用 CUSTOM_USER 和 PASSWORD 登录。
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://sqlitebrowser.org/>
- 文档: <https://github.com/sqlitebrowser/sqlitebrowser/wiki>
- 源码: <https://github.com/sqlitebrowser/sqlitebrowser>
