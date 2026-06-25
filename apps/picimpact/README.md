# PicImpact

## 应用简介
摄影佬专用相片集。

英文说明：Photo Album for Photographers.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`3.3.7`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40251 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| AUTH_SECRET | 认证密钥 | secret | 是 |
| PANEL_DB_TYPE | 数据库服务 | postgresql | 是 |
| PANEL_DB_NAME | 数据库名 | picimpact | 是 |
| PANEL_DB_USER | 数据库用户 | picimpact | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | picimpact | 是 |

## 使用说明
默认账号：`admin@qq.com`，默认密码：`666666`，**登录后请先去设置里面修改密码！**

## 参考资料
- 官网: <https://pic.besscroft.com>
- 文档: <https://github.com/besscroft/PicImpact>
