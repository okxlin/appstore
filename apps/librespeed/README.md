# LibreSpeed

## 应用简介
开源速度测试工具。

英文说明：Open-source speed test tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`6.1.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40262 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MODE | 模式 | standalone | 是 |
| TITLE | 标题 | LibreSpeed | 是 |
| TELEMETRY | 遥测 | false | 是 |
| ENABLE_ID_OBFUSCATION | 启用 ID 混淆 | true | 是 |
| REDACT_IP_ADDRESSES | 隐藏 IP 地址 | false | 是 |
| PASSWORD | 密码 | password | 否 |
| EMAIL | GDPR 请求的电子邮件地址 (启用遥测时必须指定) | - | 否 |
| DISABLE_IPINFO | 禁用 IPInfo | false | 是 |
| DISTANCE | 距离 | km | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 安全风险
- 本应用使用 LibreSpeed 官方镜像。该镜像包含完整的 Debian、PHP 和 Web 运行环境，漏洞扫描器可能报告继承自基础系统组件的 High 或 Critical 漏洞；升级可以减少已知漏洞，但不代表镜像不存在漏洞。
- 部署前请重新扫描目标镜像，持续跟踪上游更新，并限制不必要的公网暴露。

## Security Risks
- This app uses the official LibreSpeed image. Its Debian, PHP, and web runtime may contain High or Critical vulnerabilities inherited from base-system packages; upgrading can reduce known findings but does not make the image vulnerability-free.
- Re-scan the target image before deployment, track upstream releases, and avoid unnecessary public exposure.

## 参考资料
- 官网: <https://librespeed.org/>
- 文档: <https://github.com/librespeed/speedtest>
