# GoToSocial

## 产品介绍
GoToSocial 是一个轻量 ActivityPub 社交网络服务，适合小型或个人 Fediverse 实例。

## 主要功能
- ActivityPub 社交网络服务
- SQLite 本地数据库
- 本地媒体存储
- 适合低资源小型实例

## 访问说明
安装后通过 `http://<服务器 IP>:18084` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
GoToSocial is a lightweight ActivityPub social network server for small or personal Fediverse instances.

## Features
- ActivityPub social networking
- SQLite-backed local database
- Local media storage
- Suitable for small low-resource instances

## 部署说明
- 本应用使用官方 Docker 镜像 `docker.io/superseriousbusiness/gotosocial:0.21.3`。
- 应用分类：网站。
- 支持架构：amd64、arm64。
- 当前固定使用 GoToSocial `0.21.3`，不使用 moving `latest` 标签。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口，映射到容器内 `8080` | 18084 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | GoToSocial SQLite、媒体文件和 Wazero 缓存目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| GTS_HOST | 实例公开域名，不包含协议 | gotosocial.example.com | 是 |
| GTS_PROTOCOL | 实例公开访问协议 | https | 是 |
| GTS_TRUSTED_PROXIES | 可信反向代理 CIDR 列表 | 127.0.0.1/32,::1,172.16.0.0/12 | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- GoToSocial 生产使用通常需要真实域名和 HTTPS 反向代理；请将 `GTS_HOST` 改成实际域名。
- GoToSocial 当前不能从 Web UI 创建首个用户。安装完成后，需要进入容器执行官方 CLI 创建用户，例如：

```sh
docker exec -it <容器名或 ID> \
  /gotosocial/gotosocial \
  admin account create \
  --username <用户名> \
  --email <邮箱> \
  --password '<强密码>'
```

- 如需管理员权限，请再执行：

```sh
docker exec -it <容器名或 ID> \
  /gotosocial/gotosocial \
  admin account promote --username <用户名>
```

- 官方文档说明，升级前应备份数据目录；生产环境建议使用固定版本标签并阅读 release notes。

## 参考资料
- 官网: <https://gotosocial.org/>
- 官方源码: <https://codeberg.org/superseriousbusiness/gotosocial>
- 容器部署文档: <https://docs.gotosocial.org/en/latest/getting_started/installation/container/>
- 用户创建文档: <https://docs.gotosocial.org/en/latest/getting_started/user_creation/>
