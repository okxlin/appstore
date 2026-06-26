# Headscale

## 应用简介
Tailscale 控制服务器的开源自托管实现。

英文说明：An open source, self-hosted implementation of the Tailscale control server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`0.23.0-alpha3`、`0.26.1`、`0.27.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 (对应内部 8080) | 40183 | 是 |

## 数据持久化
- `./data/config:/etc/headscale`
- `./data/data:/var/lib/headscale`

升级或迁移前，请在 1Panel 中备份上述数据目录。

升级到 `0.27.1` 前请特别注意：

- Headscale `0.27.x` 会执行 SQLite 数据库结构迁移；升级前请备份 `./data/data/db.sqlite`、`./data/data/db.sqlite-wal`、`./data/data/db.sqlite-shm`（如存在）以及 `./data/config`。
- `0.27.1` 最低支持的 Tailscale 客户端版本为 `v1.64.0`，旧客户端需要先升级。
- 版本目录内的 `scripts/upgrade.sh` 会自动备份并迁移旧版 `config.yaml`；如手动改过 Postgres、DNS、ACL 等配置，升级后请核对 `database`、`dns`、`policy` 配置块。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SUBNET | 1panel-network 子网 IP (查看docker网络获取网段) | 172.18.0.241 | 是 |

## 使用说明
### 宿主机可通过以下命令创建、获取所需
- 容器名按需修改

```shell
# 创建名为 "username" 的用户
docker exec -it headscale headscale users create username

# 创建一个有效期为 10000 天的 API 密钥
docker exec -it headscale headscale apikeys create -e 10000d

# 创建一个有效期为 10000 天、可重复使用的预授权密钥，并关联到特定的用户名 "username"
docker exec -it headscale headscale preauthkeys create -e 10000d --reusable -u username
```
### 1Panel 容器管理页面连接容器终端

```shell
# 创建名为 "username" 的用户
headscale users create username

# 创建一个有效期为 10000 天的 API 密钥
headscale apikeys create -e 10000d

# 创建一个有效期为 10000 天、可重复使用的预授权密钥，并关联到特定的用户名 "username"
headscale preauthkeys create -e 10000d --reusable -u username
```

## 参考资料
- 官网: <https://headscale.net>
- 源码: <https://github.com/juanfont/headscale>
