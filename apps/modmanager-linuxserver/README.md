# Modmanager

## 应用简介
Docker Mods 缓存更新服务。

英文说明：Docker Mods cache updater maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`9ae6695d-ls51`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MODCACHE_PATH | Mods 缓存路径 | ./data/modcache | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DOCKER_MODS | Docker Mods 列表 | linuxserver/mods:universal-git | 是 |
| DOCKER_HOST | Docker Host 端点 | - | 否 |
| DOCKER_MODS_EXTRA_HOSTS | 额外 Docker 主机 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.linuxserver.io/>
- 文档: <https://docs.linuxserver.io/images/docker-modmanager/>
- 源码: <https://github.com/linuxserver/docker-modmanager>
