# PairDrop

## 应用简介
PairDrop 局域网文件传输。

英文说明：Local file transfer service maintained by LinuxServer.io.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`1.11.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 3000 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| RATE_LIMIT | 启用 100 次/5 分钟客户端请求限流 | false | 否 |
| WS_FALLBACK | WebRTC 不可用时启用 WebSocket 回退 | false | 否 |
| RTC_CONFIG | 自定义 STUN/TURN JSON 配置文件路径 | - | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://pairdrop.net/>
- 文档: <https://docs.linuxserver.io/images/docker-pairdrop/>
- 源码: <https://github.com/linuxserver/docker-pairdrop>
