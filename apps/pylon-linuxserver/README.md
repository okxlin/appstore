# Pylon

## 应用简介
Pylon Web IDE。

英文说明：Web IDE maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：运维。
- 支持架构：amd64、arm64。
- 可选版本：`2.10.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3131 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CODE_PATH | 配置文件路径 | ./data/code | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| GITURL | Git 地址 | https://github.com/linuxserver/docker-pylon.git | 否 |
| PYUSER | Pylon 用户 | myuser | 否 |
| PYPASS | Pylon 密码 | mypass | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/pylonide/pylon>
- 文档: <https://docs.linuxserver.io/deprecated_images/docker-pylon/>
- 源码: <https://github.com/linuxserver/docker-pylon>
