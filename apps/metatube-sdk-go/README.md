# MetaTube SDK Go

## 应用简介
MetaTube 服务的后端。

英文说明：Backend of the MetaTube service.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`1.2.8`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40302 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | postgresql | 是 |
| PANEL_DB_NAME | 数据库名 | metatube | 是 |
| PANEL_DB_USER | 数据库用户 | metatube | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | metatube | 是 |
| HTTP_PROXY | HTTP 代理 | - | 否 |
| HTTPS_PROXY | HTTPS 代理 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://metatube-community.github.io>
- 源码: <https://github.com/metatube-community/metatube-sdk-go>
