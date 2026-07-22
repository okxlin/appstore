# UUSEC WAF

## 产品介绍
UUSEC WAF（原 uuWAF / 南墙）是一款通过反向代理保护网站的 Web 应用防火墙，提供攻击检测、访问控制、证书管理和安全日志能力。

## 主要功能
- Web 攻击检测与拦截
- 站点反向代理与访问控制
- TLS 证书和 ACME 账户管理
- 攻击日志与安全规则管理

## Introduction
UUSEC WAF, formerly uuWAF or NanQiang, is a reverse-proxy web application firewall with attack detection, access control, certificate management, and security logging.

## Features
- Web attack detection and blocking
- Site reverse proxy and access control
- TLS certificate and ACME account management
- Attack logs and security rule management

## 访问说明
安装完成后，通过 `https://<服务器 IP>:<PANEL_APP_PORT_CONSOLE>` 访问管理控制台。默认用户名为 `admin`，上游默认密码为 `Passw0rd!`；首次登录后应立即修改密码，并将管理端口限制为可信来源访问。

## 部署说明
- 本应用使用 UUSEC 发布的 `uusec/nanqiang` Docker Hub 镜像，以 Docker Compose 在 1Panel 中部署；上游 6.8.0 compose 使用同一厂商的华为云镜像源。
- 镜像仅提供 `amd64` 架构。商店保留 `6.2.0`，并新增 6.x LTS 末版 `6.8.0`。
- HTTP、HTTPS 和管理端口都可在安装表单中设置。管理控制台使用 HTTPS，默认地址为 `https://<服务器 IP>:4443`。
- 6.8.0 商店包继续使用 bridge 网络和可配置端口，以兼容已有 1Panel 安装；访问宿主机上的上游服务时，请填写容器可达的宿主机地址，不要使用容器内的 `127.0.0.1`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | WAF HTTP 入口 | 80 | 是 |
| PANEL_APP_PORT_HTTPS | WAF HTTPS 入口 | 443 | 是 |
| PANEL_APP_PORT_CONSOLE | HTTPS 管理控制台 | 4443 | 是 |

## 数据持久化
| 卷 | 用途 |
| --- | --- |
| `wafdata` | Percona Server 5.7 数据目录，沿用 6.2.0 的卷名 |
| `wafshared` | 6.2.0 的完整 `/uuwaf` 旧卷；升级后只读保留，作为迁移来源和人工回退资料 |
| `${CONTAINER_NAME}-config` | 6.8.0 运行配置 |
| `${CONTAINER_NAME}-accounts` | ACME 账户数据 |
| `${CONTAINER_NAME}-certificates` | ACME 证书数据 |
| `${CONTAINER_NAME}-initdb` | 6.8.0 数据库初始化文件 |

1Panel 卸载应用时不会自动删除上述 named volumes。确认不再需要数据后，才应由管理员手动删除对应卷。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| PANEL_DB_USER_PASSWORD | 内置数据库 root 密码 | Safe3.WAF | 是 |
| MYSQL_MAX_CONNECTIONS | 数据库最大连接数 | 512 | 是 |

新安装应将默认数据库密码改为独立的高强度密码。重新安装并复用旧 `wafdata` 时，必须填写旧数据库密码。

## 升级说明
- 商店支持从 `6.2.0` 直接升级到 `6.8.0`。升级首次启动时会把旧 `wafshared` 中的配置复制到新的配置、ACME 账户和证书卷；迁移带有完成标记，重启和重试不会覆盖迁移后的用户修改。
- 升级过程不会改写或删除旧 `wafshared`，数据库继续使用原 `wafdata`。升级前仍应使用 `mysqldump` 导出 `uuwaf` 数据库，并在停止应用后备份 `wafshared` 和 `wafdata`。
- 上游 `7.0.0` 明确要求重装，`7.2.0` 又声明与旧版本不兼容，因此本商店不支持从 6.x 原地升级到 7.x。需要 7.x 时，请新建部署并按上游支持范围人工迁移。
- 6.8.0 上游仍使用 MySQL/Percona 5.7。该数据库版本已经 EOL，但没有官方证据支持本应用原地升级到 Percona/MySQL 8.x，因此本版本不接入商店 MySQL runtime，也不采用关闭 PR #2848 的数据库大版本更新。

## 安全说明
- WAF 位于业务流量入口，开放 80/443 前请确认反向代理目标、证书和防火墙规则正确。
- 管理端口应仅允许可信来源访问，首次登录后立即修改默认管理员凭据。
- `uusec/nanqiang:6.8.0` 是固定的官方发布镜像，但 6.x 已不是上游当前主线；该多服务应用及其 EOL 数据库依赖不加入 Renovate 自动合并白名单。

## 参考资料
- 官网: <https://waf.uusec.com/>
- 官方源码: <https://github.com/Safe3/uusec-waf>
- 官方 6.8.0 发布说明: <https://github.com/Safe3/uusec-waf/releases/tag/v6.8.0>
- 官方 7.0.0 不兼容说明: <https://github.com/Safe3/uusec-waf/releases/tag/v7.0.0>
- 官方 7.2.0 不兼容说明: <https://github.com/Safe3/uusec-waf/releases/tag/v7.2.0>
- Docker Hub 镜像: <https://hub.docker.com/r/uusec/nanqiang>
