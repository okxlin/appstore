# Immich

## 应用简介
高性能的自托管照片和视频备份方案。

英文说明：High performance self-hosted photo and video backup solution.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`release`、`1.122.3`、`1.132.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40194 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| UPLOAD_LOCATION | 上传用文件夹路径 | ./data/upload | 是 |
| CACHE_PATH | 缓存文件夹路径 | ./data/cache | 是 |
| DB_PATH | 数据库文件夹路径 | ./data/data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

升级到 `1.132.3` 前请特别注意：

- `1.132.3` 保持 `UPLOAD_LOCATION`、`CACHE_PATH`、`DB_PATH` 持久化路径不变，但服务镜像切换为官方 `ghcr.io/immich-app/*`，缓存服务由 Redis 6.2 切换为 Valkey 8。
- Immich 官方建议升级前阅读对应版本 release notes，确认 breaking changes；请同时备份上传目录并通过数据库导出方式备份 Postgres，直接热拷贝 `DB_PATH` 不能作为可靠数据库备份。
- 如使用 Authelia OAuth，`v1.132.3` release notes 要求 Authelia 配置包含 `token_endpoint_auth_method: "client_secret_post"`。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_NAME | 数据库名 | immich | 是 |
| PANEL_DB_USER | Postgres 数据库用户 | postgres | 是 |
| PANEL_DB_USER_PASSWORD | Postgres 数据库用户密码 | immich | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://immich.app>
- 文档: <https://immich.app/docs>
- 源码: <https://github.com/immich-app/immich>
