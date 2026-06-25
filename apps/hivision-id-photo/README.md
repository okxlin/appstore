# HivisionIDPhoto

## 应用简介
一个轻量级的 AI 证件照制作工具。

英文说明：A lightweight and efficient AI ID photos tools.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`1.3.1`、`latest-gpu`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40330 | 是 |
| PANEL_APP_PORT_HTTP_INTERNAL | 内部端口 | 7860 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| COMMAND | 启动命令 | python3 -u app.py --host 0.0.0.0 --port 7860 | 是 |
| FACE_PLUS_API_KEY | FACE Plus API 密钥 | - | 否 |
| FACE_PLUS_API_SECRET | FACE Plus API 密钥 Secret | - | 否 |
| RUN_MODE | 运行模式 | - | 否 |
| DEFAULT_LANG | 默认语言 | zh | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/Zeyi-Lin/HivisionIDPhotos>
