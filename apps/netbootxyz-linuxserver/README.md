# netboot.xyz

## 应用简介
netboot.xyz 网络启动服务。

英文说明：Network boot service maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`0.7.6`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3000 | 是 |
| PANEL_APP_PORT_TFTP | TFTP UDP 端口 | 69 | 是 |
| PANEL_APP_PORT_ASSETS | 资源 HTTP 端口 | 8080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| ASSETS_PATH | 启动资源目录 | ./data/assets | 是 |
| SUBFOLDER | 子路径 | / | 否 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MENU_VERSION | 菜单版本 | 1.9.9 | 否 |
| PORT_RANGE | TFTP 数据端口范围 | 30000:30010 | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://netboot.xyz/>
- 文档: <https://docs.linuxserver.io/images/docker-netbootxyz/>
- 源码: <https://github.com/linuxserver/docker-netbootxyz>
