# Pi-hole

## 产品介绍

Pi-hole 是面向家庭和小型可信网络的 DNS 过滤服务，可在域名解析阶段阻止广告、跟踪器和恶意域名，并通过 Web 后台展示查询统计、客户端和拦截规则。

## 主要功能

- 同时提供 TCP 与 UDP DNS 过滤
- 按域名维护允许列表、阻止列表和正则规则
- 定期更新 Gravity 广告与跟踪器列表
- 按客户端和域名查看查询统计
- 通过受密码保护的 Web 后台管理

## 访问说明

安装后访问 `http://<服务器 IP>:<管理端口>/admin/`，使用安装时生成的管理员密码登录。客户端必须把 DNS 服务器设置为 1Panel 主机的 IPv4 地址和所选 DNS 端口；路由器通常可以通过 LAN DHCP 下发该地址。

本适配只提供 DNS 与 Web 管理，不启用 Pi-hole DHCP、NTP、host network、`NET_ADMIN` 或 `NET_RAW`。DNS 同时映射 TCP 和 UDP。`DNS_BIND_ADDRESS` 默认为 `0.0.0.0`；这只适合有防火墙保护的可信局域网。必须在主机、云安全组和路由器上将所选 DNS 端口限制到明确的 LAN 网段，绝不能将其暴露为公网开放解析器。若主机有固定 LAN IPv4 地址，安装时应将绑定地址改为该地址。管理端口也应限制在可信 LAN 或放在受保护的 HTTPS 反向代理之后。

标准 DNS 端口 53 可能已被 `systemd-resolved` 或其他 DNS 服务占用。安装前应检查 TCP 和 UDP 53；发生冲突时，优先绑定主机的固定 LAN IPv4 地址，或停止并正确重新配置冲突服务。也可选择其他端口进行测试，但大多数路由器和客户端不能为普通 DNS 指定非标准端口，不能把高位端口视为完整替代方案。

Pi-hole 在 Docker 桥接网络中需要 `FTLCONF_dns_listeningMode=ALL` 才能接收经宿主端口转发的客户端查询；此设置会接受到达容器的所有来源，因此宿主侧访问控制是安全边界。停用 Pi-hole 前，应先为路由器或客户端配置可用的备用 DNS，避免整个网络失去域名解析。

`APP_DATA_DIR` 保存 `/etc/pihole` 下的配置、Gravity 数据库、查询数据和管理员密码哈希。路径必须是应用版本目录内的相对路径。卸载不会删除绑定目录中的数据；升级、迁移或卸载前应备份。管理员密码由 1Panel 保存在应用 `.env`，并作为官方 `FTLCONF_webserver_api_password` 环境变量传入，因此有权检查容器或应用配置的人可读取明文密码；限制 1Panel 与 Docker 权限，不要复用该密码。

## 安全与漏洞警告

- 2026-07-28 对固定镜像 `2026.07.2` 的扫描结果为 `0 Critical / 15 High`，共 8 个不同漏洞。镜像包含已修复版本可用但尚未纳入该固定镜像的 `bind-libs`、`bind-tools` 和 `c-ares`，上游发布更新后应重新验证并尽快升级。
- `CVE-2026-11331`、`CVE-2026-11605`、`CVE-2026-11622`、`CVE-2026-11721`、`CVE-2026-12617`、`CVE-2026-13204` 和 `CVE-2026-13321` 同时计入 BIND 库和工具，共 14 条 High。Pi-hole FTL 主程序不链接 BIND；镜像仅用 `dig` 对回环地址上的 `pi.hole` 执行无递归健康查询，默认 DNS 服务数据面不经过这些库。管理员在容器中手动对不可信 DNS 服务运行 BIND 工具仍可能触发策略绕过、DNSSEC 验证错误、资源耗尽、缓存污染或进程退出，应避免此类操作。
- `CVE-2026-33630` 是 `c-ares` 查询完成处理中的 use-after-free/double-free。FTL 不链接 `c-ares`；它由 `libcurl` 引入，可影响容器内的 `curl`、Git HTTP 工具和定期 Gravity/版本检查。默认列表来自公开 HTTPS 上游，但管理员可添加列表地址，且 DNS 或上游服务可能受攻击。只使用可信 HTTPS 列表源，限制后台访问，并在修复镜像可用后升级。
- 镜像入口以 root 执行初始化、计划任务和日志维护，再以 `pihole` 用户运行 FTL。适配丢弃默认 capability 并仅恢复初始化、绑定低端口、降权和正常终止所需集合，启用 `no-new-privileges`，但根文件系统因官方启动流程需要更新 capability、计划任务和运行文件而不能只读。不要在容器内安装额外软件，也不要增加 DHCP/NTP 权限。

## Introduction

Pi-hole provides network-wide DNS filtering for ads, trackers, and unwanted domains. Open `http://<server-ip>:<web-port>/admin/` and sign in with the generated administrator password. Configure trusted clients or your router to use the 1Panel host IPv4 address and selected DNS port.

## Features

- TCP and UDP DNS filtering
- Allowlists, blocklists, and regular-expression rules
- Scheduled Gravity list updates
- Per-client and per-domain query statistics
- Password-protected web administration

This package exposes both TCP and UDP DNS but does not enable DHCP, NTP, host networking, `NET_ADMIN`, or `NET_RAW`. `DNS_BIND_ADDRESS` defaults to `0.0.0.0` and must be protected by host, cloud, and router firewall rules that allow only explicit trusted LAN subnets. Never operate it as a public recursive resolver. Bind it to the host's fixed LAN IPv4 address when possible, and restrict the web port to the trusted LAN or a protected HTTPS proxy.

TCP and UDP port 53 may already be occupied by `systemd-resolved` or another DNS service. Check both protocols before installation. Prefer binding Pi-hole to the host's fixed LAN IPv4 address or deliberately reconfigure the conflicting resolver. A high test port avoids the collision, but most routers and clients cannot specify a non-standard plain-DNS port.

Docker bridge networking requires `FTLCONF_dns_listeningMode=ALL`; host-side filtering is therefore the security boundary. Configure fallback DNS before stopping or upgrading Pi-hole. Persistent state lives under `APP_DATA_DIR`, which must remain a relative path inside the application version directory. The administrator password remains visible to users who can inspect the 1Panel `.env` or container environment.

## Security And Vulnerability Warning

- A fresh scan of the pinned `2026.07.2` image on 2026-07-28 reports `0 Critical / 15 High`, representing eight distinct vulnerabilities in `bind-libs`, `bind-tools`, and `c-ares`. Fixed package versions exist but are not present in this pinned image; revalidate and upgrade promptly when the official image is refreshed.
- The 14 BIND records cover `CVE-2026-11331`, `CVE-2026-11605`, `CVE-2026-11622`, `CVE-2026-11721`, `CVE-2026-12617`, `CVE-2026-13204`, and `CVE-2026-13321`. Pi-hole FTL does not link BIND. Only the bundled `dig` health utility uses it, and the image health probe sends a non-recursive query to loopback. Default client DNS traffic does not enter these libraries. Avoid manually querying untrusted servers with bundled BIND tools.
- `CVE-2026-33630` is a `c-ares` use-after-free/double-free in query completion. FTL does not link it; `libcurl` brings it into `curl` and Git HTTP helpers used for scheduled Gravity and update checks. Use only trusted HTTPS ad-list sources, restrict administration, and upgrade as soon as a fixed official image is available.
- The image initializes as root and runs FTL as `pihole`. The adapter drops Docker's default capability set and restores only the capabilities required for initialization, low-port binding, privilege drop, and shutdown, with `no-new-privileges` enabled. The official startup modifies file capabilities, cron state, and runtime files, so a read-only root filesystem is not currently compatible.

## References

- Source and EUPL-1.2 license: <https://github.com/pi-hole/docker-pi-hole/tree/2026.07.2>
- Official Docker documentation: <https://docs.pi-hole.net/docker/>
- Configuration and capabilities: <https://docs.pi-hole.net/docker/configuration/>
- Release: <https://github.com/pi-hole/docker-pi-hole/releases/tag/2026.07.2>
