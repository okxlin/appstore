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
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOCKER_SOCK_PATH | Docker Socket 路径 | /var/run/docker.sock | 是 |
| VOLUMES | 卷接口 | 0 | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| LOG_LEVEL | 日志级别 | info | 是 |
| CONTAINERS | 容器接口 | 0 | 是 |
| IMAGES | 镜像接口 | 0 | 是 |
| NETWORKS | 网络接口 | 0 | 是 |
| POST | 允许 POST API | 0 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.linuxserver.io/>
- 文档: <https://docs.linuxserver.io/images/docker-socket-proxy/>
- 源码: <https://github.com/linuxserver/docker-socket-proxy>
