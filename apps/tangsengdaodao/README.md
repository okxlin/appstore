# TangSengDaoDao

## 应用简介
让企业轻松拥有自己的即时通讯。

英文说明：Make it easy for businesses to have their own instant messaging.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`1.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TS_DB_REDIS_PORT | Redis 服务端口 | 6379 | 是 |
| MINIO_PORT | minio 端口 | 9000 | 是 |
| PANEL_APP_PORT_WK_TCP | 悟空 IM TCP 端口 | 5100 | 是 |
| PANEL_APP_PORT_WK_WS | 悟空 IM WS 端口 | 5200 | 是 |
| PANEL_APP_PORT_WK_WEB_SERVER | 悟空 IM 监控端口 | 5300 | 是 |
| PANEL_APP_PORT_TS_APP_HTTP | 唐僧叨叨端口 | 8090 | 是 |
| PANEL_APP_PORT_TS_APP_WEB | 唐僧叨叨 WEB 端口 | 82 | 是 |
| PANEL_APP_PORT_HTTP | 唐僧叨叨管理后台端口 | 83 | 是 |

## 数据持久化
- `./wukongim:/root/wukongim`
- `WK_DATASOURCE_ADDR=http://tangsengdaodaoserver:8090/v1/datasource`
- `./tsdd:/home/tsdddata`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| EXTERNAL_IP | 外部访问 IP | - | 是 |
| PANEL_DB_HOST | 数据库服务 | - | 是 |
| PANEL_DB_NAME | 数据库名 | tsdd | 是 |
| PANEL_DB_USER | 数据库用户 | tsdd | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | tsdd@123456 | 是 |
| TS_DB_REDIS_HOST | 缓存服务 | - | 是 |
| PANEL_REDIS_ROOT_PASSWORD | Redis 密码 | - | 是 |
| MINIO_HOST | minio 对象存储服务 | - | 是 |
| MINIO_ROOT_USER | minio 用户 | - | 是 |
| MINIO_ROOT_PASSWORD | minio 用户密码 | - | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://tsdaodao.com>
- 源码: <https://github.com/TangSengDaoDao/TangSengDaoDaoServer>
