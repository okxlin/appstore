# Thunderbird

## 应用简介
开源的电子邮件客户端。

英文说明：Open-source email client.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：邮件。
- 支持架构：amd64。
- 可选版本：`latest`、`26.03.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 端口 | 40327 | 是 |
| VNC_PORT | VNC 端口 | 40328 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| VNC_PASSWORD | VNC 密码 | password | 是 |
| USER_ID | 用户 ID | 1000 | 是 |
| GROUP_ID | 用户组 ID | 1000 | 是 |
| SUP_GROUP_IDS | 补充用户组 ID | - | 否 |
| LANG | 语言环境 | en_US.UTF-8 | 是 |
| KEEP_APP_RUNNING | 保持应用运行 | 0 | 是 |
| APP_NICENESS | 应用优先级 | 0 | 是 |
| INSTALL_PACKAGES | 安装包 | - | 否 |
| PACKAGES_MIRROR | 软件包镜像 | - | 否 |
| CONTAINER_DEBUG | 容器调试 | 0 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://www.thunderbird.net>
- 文档: <https://support.mozilla.org/en-US/products/thunderbird>
- 源码: <https://github.com/thunderbird>
