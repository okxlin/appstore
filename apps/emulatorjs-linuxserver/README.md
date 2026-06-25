# EmulatorJS

## 应用简介
EmulatorJS 游戏模拟器前端。

英文说明：Game emulator frontend maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：游戏。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.9.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3000 | 是 |
| PANEL_APP_PORT_FRONTEND | 前端端口 | 80 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置文件路径 | ./data/config | 是 |
| DATA_PATH | ROM 数据目录 | ./data/roms | 是 |
| SUBFOLDER | 子路径 | / | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://emulatorjs.org/>
- 文档: <https://docs.linuxserver.io/images/docker-emulatorjs/>
- 源码: <https://github.com/linuxserver/docker-emulatorjs>
