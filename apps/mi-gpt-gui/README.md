# MiGPT GUI

## 应用简介
安全、快速的给你的小爱音箱接入人工智能。

英文说明：Securely and Quickly Access Artificial Intelligence for Xiaomi Speaker.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`1.12.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40305 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| LOGIN_USER | 用户名 | admin | 是 |
| LOGIN_PASSWORD | 密码 | password | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://migptgui.com>
- 源码: <https://github.com/lmk123/migpt-cli>
