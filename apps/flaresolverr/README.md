# FlareSolverr

## 应用简介
绕过 Cloudflare 保护的代理服务器。

英文说明：Proxy server to bypass Cloudflare protection.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：DevTool。
- 支持架构：amd64。
- 可选版本：`latest`、`3.5.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40322 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| LOG_LEVEL | 日志级别 | info | 是 |
| LOG_HTML | 日志 HTML 输出 | false | 是 |
| CAPTCHA_SOLVER | CAPTCHA 解算器 | none | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| LANG | 语言 | none | 是 |
| HEADLESS | 无头模式 | true | 是 |
| BROWSER_TIMEOUT | 浏览器超时时间 | 40000 | 是 |
| TEST_URL | 测试 URL | https://www.google.com | 是 |
| HOST | 监听地址 | 0.0.0.0 | 是 |
| PROMETHEUS_ENABLED | 启用 Prometheus | false | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://github.com/FlareSolverr/FlareSolverr>
