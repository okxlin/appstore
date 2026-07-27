# Zoraxy

## 产品介绍

Zoraxy 是面向家庭实验室和自托管环境的反向代理与网络管理平台，提供基于域名的 HTTP/HTTPS 转发、自动证书管理、访问规则、流代理、运行状态监控和 WebSSH 工具。

## 主要功能

- HTTP、HTTPS、WebSocket、TCP 和 UDP 代理
- ACME 证书申请和自动续期
- 主机名、路径、请求头、访问列表和可信代理规则
- 运行状态监控、流量统计、WebSSH 和网络诊断工具
- 可选插件和 ZorxAuth 单点登录

## 访问说明

安装后通过 `http://<服务器 IP>:<管理端口>/` 打开管理后台，使用安装时设置的管理员用户名和随机密码登录。初始化期间管理接口只监听容器回环地址；适配脚本创建唯一管理员并验证成功后，才会重启为正式监听，因此远程客户端不能抢注首个账户。

默认端口映射为：管理后台 `8000`、HTTP 代理 `8080`、HTTPS 代理 `8443`。若要从公网提供标准 Web 服务，请在路由器或上级防火墙中将外部 80/443 分别转发到安装表单中的 HTTP/HTTPS 代理端口。管理端口不应暴露到公网；Zoraxy 后台本身只提供明文 HTTP，且本适配未增加登录限速，应放在可信 HTTPS 反向代理之后并限制来源地址、增加登录限速。

本包不挂载 `/var/run/docker.sock`。因此后台可以显示 Docker 集成功能入口，但相关容器枚举 API 会失败关闭；不要为了便利添加 Docker socket，因为这会让后台获得主机级容器控制能力。`host.docker.internal` 指向宿主机网关，1Panel 网络中的其他应用可使用容器名作为上游地址。

## 数据与凭据

`APP_DATA_DIR/config` 保存数据库、代理规则、证书、日志和运行配置，`APP_DATA_DIR/plugins` 保存已安装插件。数据目录必须位于应用版本目录内，默认为 `./data`；初始化脚本拒绝绝对路径和目录逃逸。升级、迁移或卸载前请备份，卸载不会删除绑定目录中的用户数据。

1Panel 将生成的管理员密码保存在应用 `.env` 中。安装脚本另建权限为 `0600` 的一次性凭据文件；容器只在回环接口注册账户，完成后立即删除该文件，正式 Zoraxy 进程的参数和环境均不包含密码。能够读取 1Panel 应用配置的人仍能得到明文密码，应限制 1Panel 和主机文件权限，且不要复用该密码。

上游将管理密码保存为无盐 SHA-512 摘要，不具备 Argon2、scrypt 或 bcrypt 的离线破解成本。必须使用安装时生成的高强度唯一密码，并保护 `sys.db` 备份。正式进程以 UID/GID 65534 运行，有效 capability 为零，启用 `no-new-privileges`，根文件系统只读；只有启动包装器短暂保留切换用户、调整两个数据目录所有权和终止回环初始化进程所需的最小能力。

## 安全与漏洞警告

- 2026-07-28 对固定镜像的全新 Trivy 扫描结果为 `0 Critical / 23 High`，对应 22 个不同漏洞。版本 3.3.3 的标签提交日期为 2026-05-31，上游仓库最后活动时间为 2026-07-26。修复镜像发布后应重新验证并尽快升级。
- `CVE-2026-39829`、`CVE-2026-39830`、`CVE-2026-39835` 和 `CVE-2026-46597` 可影响 Zoraxy 的已认证 WebSSH 客户端：管理员连接恶意或已被入侵的 SSH 服务时，特制密钥、证书、响应或 AES-GCM 数据包可能造成 CPU、内存、资源泄漏或进程崩溃。仅连接可信 SSH 主机；WebSSH 使用 `ssh.InsecureIgnoreHostKey()`，不会验证主机密钥，因此还必须防范中间人攻击。其余 SSH High 是服务端授权、硬件密钥、agent 或 known_hosts 路径，Zoraxy 默认客户端流程不使用这些边界。
- `CVE-2026-39821` 位于 `x/net/idna` 的错误 Punycode 标签处理。该库通过 Go 网络栈间接链接，未发现 Zoraxy 将 IDNA 转换结果用于本地特权允许列表的明确路径，因此没有证明默认提权可达；但域名仍参与代理路由、证书和管理员配置。避免不受信任的国际化域名，限制后台访问，并在修复版本可用后升级。
- `CVE-2026-25681` 和 `CVE-2026-27136` 需要 `x/net/html` 的 Parse-to-Render 树转换。Zoraxy 的输入清理经 bluemonday 使用 `html.NewTokenizer`，没有走受影响的树解析再渲染模式，默认管理输入路径不满足漏洞前置条件。仍不要向不可信用户开放管理后台。
- `CVE-2026-34040`、`CVE-2026-41567` 和 `CVE-2026-42306` 针对 Docker daemon 的授权或镜像归档处理。镜像只链接 Docker 客户端 SDK，本包既不运行 daemon 也不挂载 socket；已认证的 `/api/docker/*` 请求因此失败关闭。
- `GHSA-hrxh-6v49-42gf` 位于 gRPC-Go 的 xDS RBAC/HTTP2 路径。gRPC 仅由可选且需管理员配置的 Yandex Cloud ACME DNS 提供商间接引入；Zoraxy 默认不提供 gRPC 服务或 xDS 管理面。`CVE-2026-39822` 涉及 `os.Root`，固定二进制中未发现相关易受影响符号。
- `CVE-2026-45186`、`CVE-2026-56131`、`CVE-2026-56407` 和 `CVE-2026-56408` 位于镜像的 Expat；`CVE-2026-45447` 位于 OpenSSL `PKCS7_verify()`。Zoraxy 主程序是静态 Go 二进制，不链接这些系统库；本包的 Python 初始化只通过回环 HTTP 创建管理员，不解析 XML、PKCS#7 或 S/MIME。这些休眠组件仍需由上游镜像更新。
- Zoraxy 启动时会通过明文 HTTP 请求 `checkip.amazonaws.com` 获取公网 IP，并通过 HTTPS 从 GitHub 同步官方插件索引。插件安装会下载并以 Zoraxy 的非 root 身份执行第三方二进制；只安装已核验来源和许可证的插件。mDNS、ZeroTier、快速 GeoIP、SSH 回环访问和 Docker socket 均未默认启用。

反向代理会直接处理公网不可信流量。启用 HTTPS、最小化公开路由、对上游服务保留其自身认证和限速、定期备份，并持续关注 Zoraxy 与固定镜像的安全更新。

## Introduction

Zoraxy is a reverse proxy and network management platform for homelabs and self-hosted environments. It supports domain-based HTTP/HTTPS routing, automated certificates, access rules, stream proxying, uptime monitoring, and WebSSH.

## Features

- HTTP, HTTPS, WebSocket, TCP, and UDP proxying
- ACME certificate issuance and automated renewal
- Host, path, header, access-list, and trusted-proxy rules
- Uptime monitoring, traffic analytics, WebSSH, and network diagnostics
- Optional plugins and ZorxAuth single sign-on

Open `http://<server-ip>:<management-port>/` and sign in with the administrator username and random password selected during installation. The bootstrap listener is loopback-only until the sole administrator account has been created and verified, preventing remote first-user registration races.

The default mappings are management `8000`, HTTP proxy `8080`, and HTTPS proxy `8443`. Forward external 80/443 to the selected proxy ports when publishing services. Never expose the management port directly to the Internet; it serves plain HTTP, and this adapter adds no login rate limiter. Protect it with a trusted HTTPS proxy, source restrictions, and login rate limiting.

The package does not mount `/var/run/docker.sock`. Docker integration therefore fails closed. Do not add the socket: doing so would give the administration surface host-level container control. Persistent configuration, certificates, logs, and rules live under `APP_DATA_DIR/config`; plugins live under `APP_DATA_DIR/plugins`.

1Panel retains the generated password in the app `.env`. A mode-`0600` one-time credential file is consumed over loopback and deleted before the final process starts, so the final Zoraxy environment and arguments contain no password. Upstream stores the password as an unsalted SHA-512 digest, which is weak against offline database cracking. Use the generated unique password and protect all `sys.db` backups.

The final process runs as UID/GID 65534 with zero effective capabilities, `no-new-privileges`, and a read-only root filesystem. The short-lived root wrapper retains only the capabilities needed to set data-directory ownership, drop privileges, and terminate the loopback bootstrap process.

## Security And Vulnerability Warning

- A fresh scan of the pinned image on 2026-07-28 reports `0 Critical / 23 High`, covering 22 distinct vulnerabilities. Tag 3.3.3 was committed on 2026-05-31; the repository was active on 2026-07-26. Revalidate and upgrade promptly when a fixed official image is published.
- `CVE-2026-39829`, `CVE-2026-39830`, `CVE-2026-39835`, and `CVE-2026-46597` can affect the authenticated WebSSH client. A malicious or compromised administrator-selected SSH server may cause CPU, memory, resource-leak, or process-crash denial of service with crafted keys, certificates, responses, or AES-GCM packets. Connect only to trusted SSH servers. WebSSH also uses `ssh.InsecureIgnoreHostKey()` and is vulnerable to machine-in-the-middle substitution. The other SSH High findings concern server authorization, security keys, agents, or known_hosts paths absent from the default client flow.
- `CVE-2026-39821` affects malformed Punycode handling in `x/net/idna`. The package is linked indirectly; no Zoraxy local-privilege allowlist driven by post-IDNA output was found. Practical default privilege escalation is therefore unproven, but domains still influence proxy routing, certificates, and administrator configuration. Avoid untrusted internationalized domains and restrict panel access.
- `CVE-2026-25681` and `CVE-2026-27136` require an `x/net/html` Parse-to-Render tree flow. Zoraxy sanitizes management inputs through bluemonday's `html.NewTokenizer` path instead, so the vulnerable transformation is not reached by the reviewed default input paths.
- `CVE-2026-34040`, `CVE-2026-41567`, and `CVE-2026-42306` affect Docker daemon authorization or image/archive processing. Zoraxy embeds only a client SDK, and this package runs no daemon and mounts no socket. Authenticated `/api/docker/*` calls fail closed.
- `GHSA-hrxh-6v49-42gf` affects gRPC-Go xDS RBAC/HTTP2 behavior. gRPC is linked through the optional administrator-configured Yandex Cloud ACME DNS provider; Zoraxy exposes no default gRPC server or xDS control plane. Vulnerable `os.Root` symbols for `CVE-2026-39822` were not found in the pinned binary.
- Expat `CVE-2026-45186`, `CVE-2026-56131`, `CVE-2026-56407`, and `CVE-2026-56408`, plus OpenSSL `CVE-2026-45447`, reside in image OS packages. The static Go server does not link them. The adapter's Python bootstrap performs only loopback HTTP and parses no XML, PKCS#7, or S/MIME. They still require an upstream image refresh.
- At startup, Zoraxy sends a plain-HTTP request to `checkip.amazonaws.com` for public-IP detection and retrieves the official plugin index from GitHub over HTTPS. Installed plugins are downloaded executables that run as the Zoraxy non-root user. Install only plugins with reviewed provenance and licensing. mDNS, ZeroTier, fast GeoIP, SSH loopback access, and the Docker socket are disabled by default.

The reverse proxy processes public untrusted traffic. Enforce HTTPS, publish only necessary routes, retain authentication and rate limiting on every upstream, keep backups, and monitor upstream security updates.

## References

- Project, source, and AGPL-3.0 license: <https://github.com/tobychui/zoraxy/tree/v3.3.3>
- Official Docker deployment: <https://github.com/tobychui/zoraxy/blob/v3.3.3/docker/docker-compose.yml>
- Release: <https://github.com/tobychui/zoraxy/releases/tag/v3.3.3>
- Go vulnerability database: <https://pkg.go.dev/vuln/>
- OpenSSL advisory: <https://openssl-library.org/news/secadv/20260609.txt>
