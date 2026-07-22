# 雷池 Web 应用防火墙（SafeLine WAF）

## 产品介绍
雷池是一款开源 Web 应用防火墙，通过反向代理接入网站流量并提供攻击检测、访问控制和人机验证能力。

## 主要功能
- Web 攻击检测与拦截
- 访问控制、人机验证和防爬虫能力
- 多站点反向代理与证书管理
- 管理控制台、检测引擎和防护引擎协同运行

## 访问说明
安装完成后，通过 `https://<服务器 IP>:<PANEL_APP_PORT_HTTP>` 访问管理控制台。首次访问可能看到自签名证书警告，请核对访问地址后继续，或配置受信任证书。

## Introduction
SafeLine is an open source web application firewall that protects websites through a reverse-proxy deployment with attack detection, access control, and human verification.

## Features
- Web attack detection and blocking
- Access control, human verification, and bot mitigation
- Multi-site reverse proxy and certificate management
- Coordinated management, detection, and traffic-processing services

## 部署说明
- 本应用使用长亭官方 SafeLine 镜像，并以 Docker Compose 在 1Panel 中部署。
- 普通版本复用 `1panel-network` 并占用一组固定容器地址，安装前必须确认 `SUBNET_PREFIX` 与该网络一致且地址未冲突。
- `newnet-*` 版本创建独立的 `safeline-ce` 网络，通常更不容易与其他商店应用发生地址冲突，推荐新安装优先选择。
- 安装后不要在普通版本和 `newnet-*` 版本之间直接切换；升级时应保持原有网络变体。
- 本应用支持 `amd64`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTPS 管理端口 | 40080 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SAFELINE_DIR | SafeLine 配置、日志和内置 PostgreSQL 数据目录 | ./data | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| POSTGRES_PASSWORD | 内置 PostgreSQL 用户密码 | - | 是 |
| SUBNET_PREFIX | Docker 网络的前三段 IPv4 地址 | 依版本而定 | 是 |

## 安全与部署风险
- `safeline-tengine` 使用主机网络模式，可直接访问主机网络栈，并可能占用主机上的业务端口。这是 WAF 反向代理流量所需的核心部署方式。
- 管理服务将主机 `/var/run` 挂载到容器内，以支持官方运行时协作。请仅在可信主机上部署，并限制 1Panel 和 Docker 的管理权限。
- 对外开放管理端口前，请使用防火墙或安全组限制可信来源。

## Security and Deployment Risks
- `safeline-tengine` uses host networking and can access the host network stack or bind host service ports. This is required for the WAF reverse-proxy path.
- The management service mounts host `/var/run` for the official runtime integration. Deploy only on a trusted host and restrict 1Panel and Docker administrative access.
- Restrict the management port to trusted source addresses before exposing it externally.

## 升级说明
- 升级前使用 `pg_dump` 备份内置 PostgreSQL 数据库，并在停止应用后备份整个 `SAFELINE_DIR`。仅复制正在运行的 PostgreSQL 数据目录不能替代数据库原生备份。
- 保持 `POSTGRES_PASSWORD`、`SAFELINE_DIR`、`SUBNET_PREFIX` 和普通版/`newnet-*` 变体不变。
- SafeLine 的管理、检测、Tengine、Luigi、FVM 和 Chaos 六个组件必须使用同一发布版本，不要单独替换其中一个镜像。
- 商店包继续使用既有的 PostgreSQL 15.8 镜像和数据目录，避免老用户在升级时切换数据库镜像谱系或发生版本倒退。
- 当前官方部署以应用内 PostgreSQL 为基线，尚无足够的官方迁移和升级证据支持改接共享商店数据库，因此本应用暂不提供数据库应用选择器。
- 升级脚本只补齐缺失的数据目录，不修改目录所有者、不重写配置，也不删除持久化数据。

## 参考资料
- 官网: <https://waf-ce.chaitin.cn/>
- 官方文档: <https://waf-ce.chaitin.cn/posts/guide_install>
- 官方源码: <https://github.com/chaitin/SafeLine>
- 官方发布记录: <https://github.com/chaitin/SafeLine/releases>
