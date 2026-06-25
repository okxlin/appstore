# Docker LXC

## 应用简介
Docker LXC 用于在 Docker 容器中运行带状态的 LXC 系统容器，并通过 1Panel 管理 SSH 端口、映射端口、数据目录和 SSH 公钥。

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 可选版本：`latest`、`1.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | SSH 端口 | 40044 | 是 |
| EXTERNAL_PORT | 外部端口 | 50000-50010 | 是 |
| INTERNAL_PORT | 内部端口 | 50000-50010 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| EXTERNAL_DATA1 | 外部文件夹路径1 | ./data/data | 是 |
| INTERNAL_DATA1 | 内部文件夹路径1 | /data | 是 |
| EXTERNAL_DATA2 | 外部文件夹路径2 | ./data/www | 是 |
| INTERNAL_DATA2 | 内部文件夹路径2 | /www | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SSH_KEY | SSH 公钥 | - | 否 |
| LXC_HOSTNAME | LXC主机名 | lxc1 | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。
