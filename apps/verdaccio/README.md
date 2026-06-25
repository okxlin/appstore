# Verdaccio

## 应用简介
本地私有 NPM 注册中心。

英文说明：local private NPM registry.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64。
- 可选版本：`6.7.4`、`nightly-master`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40087 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| STORAGE_PATH | 存储路径 | ./data/storage | 是 |
| CONFIG_PATH | 配置路径 | ./data/config | 是 |
| PLUGINS_PATH | 插件路径 | ./data/plugins | 是 |
| VERDACCIO_APPDIR | 应用目录 | /opt/verdaccio | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| VERDACCIO_USER_NAME | 用户名 | verdaccio | 是 |
| VERDACCIO_USER_UID | 用户 ID | 10001 | 是 |
| VERDACCIO_PROTOCOL | 协议 | http | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://verdaccio.org/>
- 文档: <https://verdaccio.org/docs/what-is-verdaccio>
- 源码: <https://github.com/verdaccio/verdaccio>
