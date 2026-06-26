# Socket Proxy

## 应用简介
Socket Proxy Docker API 访问代理。

英文说明：Docker API access proxy maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：安全。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`3.4.0`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
本应用不声明持久化数据目录，`DOCKER_SOCK_PATH` 用于只读挂载 Docker Socket。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOCKER_SOCK_PATH | Docker Socket 路径 | /var/run/docker.sock | 是 |
| LOG_LEVEL | 日志级别 | info | 是 |
| CONTAINERS | 容器接口 | 0 | 是 |
| IMAGES | 镜像接口 | 0 | 是 |
| NETWORKS | 网络接口 | 0 | 是 |
| VOLUMES | 卷接口 | 0 | 是 |
| POST | 允许 POST API | 0 | 是 |
| ALLOW_START | 允许启动容器 | 0 | 是 |
| ALLOW_STOP | 允许停止容器 | 0 | 是 |
| ALLOW_RESTARTS | 允许重启或终止容器 | 0 | 是 |
| ALLOW_PAUSE | 允许暂停容器 | 0 | 是 |
| ALLOW_UNPAUSE | 允许取消暂停容器 | 0 | 是 |
| AUTH | Auth 接口 | 0 | 是 |
| BUILD | Build 接口 | 0 | 是 |
| COMMIT | Commit 接口 | 0 | 是 |
| CONFIGS | Configs 接口 | 0 | 是 |
| DISABLE_IPV6 | 禁用 IPv6 绑定 | 0 | 是 |
| DISTRIBUTION | Distribution 接口 | 0 | 是 |
| EVENTS | Events 接口 | 1 | 是 |
| EXEC | Exec 接口 | 0 | 是 |
| INFO | Info 接口 | 0 | 是 |
| NODES | Nodes 接口 | 0 | 是 |
| PING | Ping 接口 | 1 | 是 |
| PLUGINS | Plugins 接口 | 0 | 是 |
| SECRETS | Secrets 接口 | 0 | 是 |
| SERVICES | Services 接口 | 0 | 是 |
| SESSION | Session 接口 | 0 | 是 |
| SWARM | Swarm 接口 | 0 | 是 |
| SYSTEM | System 接口 | 0 | 是 |
| TASKS | Tasks 接口 | 0 | 是 |
| VERSION | Version 接口 | 1 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 仅启用实际需要的 Docker API 接口，写入类接口和 Secrets 接口会扩大代理权限。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.linuxserver.io/>
- 文档: <https://docs.linuxserver.io/images/docker-socket-proxy/>
- 源码: <https://github.com/linuxserver/docker-socket-proxy>
