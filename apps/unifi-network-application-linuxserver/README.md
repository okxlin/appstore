# UniFi Network Application

## 应用简介
UniFi Network 网络控制器。

英文说明：UniFi Network controller maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`10.4.57`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 8443 | 是 |
| PANEL_APP_PORT_STUN | STUN 端口 | 3478 | 是 |
| PANEL_APP_PORT_DISCOVERY | 发现端口 | 10001 | 是 |
| PANEL_APP_PORT_INFORM | Inform 端口 | 8080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| MONGO_DATA_PATH | Mongo 数据目录 | ./data/mongo | 是 |
| MONGO_INIT_PATH | Mongo 初始化脚本目录 | ./data/mongo-init | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MONGO_PASS | Mongo 密码 | unifi-change-me | 是 |
| MEM_LIMIT | 内存限制 MB | 1024 | 是 |
| MEM_STARTUP | 启动内存 MB | 1024 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://ui.com/>
- 文档: <https://docs.linuxserver.io/images/docker-unifi-network-application/>
- 源码: <https://github.com/linuxserver/docker-unifi-network-application>
