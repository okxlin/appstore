# Squid

## 产品介绍
Squid 是一个缓存代理服务，可用于 HTTP/HTTPS 代理、访问控制、缓存和网络出口管理。

## 主要功能
- 提供 HTTP/HTTPS 代理端口
- 使用 Squid 默认的本地网络访问控制
- 持久化 Squid 日志和工作目录

## 访问说明
Squid 不是 Web UI。安装后请在客户端代理设置中使用 `服务器 IP:13128`，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

直接在浏览器中打开该端口可能会看到 Squid 错误页，这是代理服务的正常表现。

## Introduction
Squid is a caching proxy service for HTTP/HTTPS proxying, access control, caching and network egress management.

## Features
- Provides an HTTP/HTTPS proxy port
- Keeps Squid's default local-network access policy
- Persists Squid logs and runtime directories

## Usage
Squid is not a Web UI. After installation, configure clients to use `server-ip:13128` as the proxy endpoint. The actual port follows the `PANEL_APP_PORT_HTTP` value in the install form.

Opening the port directly in a browser may show a Squid error page; that is expected for a proxy service.

## 部署说明
- 本应用使用 Canonical 维护的 `ubuntu/squid:6.6-24.04_beta` 镜像。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`，当前固定使用 Ubuntu 24.04 系列 Squid 6.6 镜像。
- 本应用不加入 Renovate 自动合并白名单，代理服务升级需要人工复核默认 ACL 和暴露风险。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Squid 代理端口 | 13128 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | Squid 日志和工作目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 安全提醒
- Squid 是代理服务，不建议直接暴露到公网。
- 默认 Canonical 配置允许本地和私有网络来源，随后拒绝其他访问；请配合防火墙、反向代理访问控制或自定义 ACL 使用。
- 如果需要公网代理，请先自行评估认证、允许网段、日志合规和滥用风险。
- 本应用在启动时保留官方默认配置，仅将监听地址调整为 `0.0.0.0:3128`，以确保 Docker/1Panel 端口映射可用。

## Security Notes
- Squid is a proxy service and should not be exposed directly to the public Internet by default.
- The Canonical default configuration allows local/private network clients and then denies other access. Use firewall rules, access control or custom ACLs for production exposure.
- For public proxy use, review authentication, allowed CIDRs, logging compliance and abuse risk first.
- The app keeps the upstream default configuration and only changes the listen address to `0.0.0.0:3128` for Docker/1Panel port publishing.

## 参考资料
- 官网: <https://www.squid-cache.org/>
- 项目仓库: <https://github.com/squid-cache/squid>
- Ubuntu Squid 镜像: <https://hub.docker.com/r/ubuntu/squid>
- 官方文档: <https://www.squid-cache.org/Doc/>
