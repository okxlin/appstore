# Lychee

## 应用简介
Lychee 相册管理。

英文说明：Photo gallery manager maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`7.6.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 80 | 是 |
| DB_PORT | 数据库端口 | - | 否 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| PICTURES_PATH | 图片目录 | ./data/pictures | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| APP_NAME | 相册名称 | Lychee | 否 |
| APP_URL | 对外访问 URL | - | 否 |
| TRUSTED_PROXIES | 反向代理 IP 或网段，公网环境不要填写 * | - | 否 |
| DB_CONNECTION | 数据库连接类型 | sqlite | 是 |
| DB_DATABASE | 数据库名称或路径 | /config/lychee.sqlite | 是 |
| DB_HOST | 数据库主机 | - | 否 |
| DB_USERNAME | 数据库用户名 | - | 否 |
| DB_PASSWORD | 数据库密码 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://lycheeorg.dev/>
- 文档: <https://docs.linuxserver.io/images/docker-lychee/>
- 源码: <https://github.com/linuxserver/docker-lychee>
