# Bisq 2 Node

## 产品介绍

Bisq 2 Node 是供 Bisq Connect 移动客户端使用的自托管交易节点。它通过内置 Tor 加入 Bisq 点对点网络，使手机能够连接到自己控制的节点，而不是依赖第三方节点。它不是 Bitcoin 全节点，也不会下载 Bitcoin 区块链。

## 主要功能

- 通过内置 Tor 加入 Bisq 2 点对点网络
- 为 Bisq Connect 提供自己控制的交易节点
- 显示节点状态和限时配对二维码
- 持久保存节点身份、数据库和 Tor 状态
- 将节点 API 保留在共享回环地址，不向宿主发布

## 访问说明

管理页面固定只绑定到 1Panel 主机的 `127.0.0.1:<本地管理端口>`，不能从局域网或公网直接访问。这是强制安全边界：页面会显示配对二维码，而配对内容实际上是能够连接节点并控制交易的凭据。

可通过 SSH 隧道访问，例如 `ssh -L 8390:127.0.0.1:8390 user@server`，再在本机打开 `http://127.0.0.1:8390/`。如果使用其他端口，请同时替换命令中的两处 `8390`。也可以配置一个已有身份认证和 HTTPS 的本地反向代理，让它代理到该回环地址；绝不能直接把此端口重新绑定到 `0.0.0.0`、公网地址或未经认证的代理。

用 Bisq Connect 扫描二维码后，应关闭管理页面。配对码默认有效 86400 秒，可在 300 至 86400 秒之间调整；缩短有效期可以降低未使用二维码被窃取的窗口。配对码是一次性的，只保存在节点内存中；节点每次启动都会覆盖 `APP_DATA_DIR` 中的二维码文件，因此重启会使尚未使用的旧二维码失效。节点身份和已配对客户端资料会持久保存。二维码文件权限由节点设为仅 UID 999 可读，但 1Panel 或 Docker 管理员仍可读取挂载数据，因此必须限制主机和面板权限。

## 数据、网络与交易风险

- `APP_DATA_DIR` 必须是应用版本目录内的相对路径，保存节点身份、私钥、数据库、Tor 状态和配对材料。卸载脚本不会删除这些数据；升级、迁移或卸载前必须备份。
- API 仅监听共享容器网络命名空间的 `127.0.0.1:8090`，没有宿主端口映射。Web sidecar 只代理版本端点和只读配对文件，不代理完整 API。
- 节点通过 Tor 与公共 Bisq 网络和外部服务通信。Tor 提高网络隐私但不能消除流量关联、恶意对等节点、上游数据错误、软件漏洞或主机失陷风险。
- Bisq 是点对点金融软件。运行自己的节点不代表报价、交易对手、支付方式、争议结果或市场数据可信；确认交易细节、备份身份数据，并遵守当地法律和税务要求。

## 安全与漏洞警告

- 2026-07-28 对两个固定 `2.1.11.1` 镜像的扫描为 `0 Critical / 11 High`：节点镜像 3 条，Web 镜像 8 条，共 9 个不同漏洞。修复版本已经存在，但尚未进入这些固定的官方镜像；上游发布新镜像后应立即重新评估并升级。
- 节点镜像的 `GHSA-r7wm-3cxj-wff9` 影响 Jackson 异步非阻塞数字解析。审查到的 Bisq WebSocket JSON 路径对完整消息使用同步 `readValue(String, ...)`，未发现 `createNonBlocking*` 调用，因此缺少该漏洞的必要入口。
- 节点镜像的 `CVE-2026-54512` 和 `CVE-2026-54513` 需要带宽松 `PolymorphicTypeValidator` 规则的默认多态类型。审查未发现 `activateDefaultTyping`、`enableDefaultTyping` 或相关 validator；Bisq DTO 使用固定 `JsonTypeInfo.Id.NAME` 和显式子类型。因此在审查路径中未满足已知利用前提。
- Web 镜像的 `CVE-2026-33630` 位于 `c-ares`。它只通过 `libcurl` 被带入；sidecar 的 watchdog 使用固定数字回环地址 `127.0.0.1`，不进行 DNS 解析。
- Web 镜像的 `CVE-2026-5773` 和 `CVE-2026-6276` 分别在 `curl` 与 `libcurl` 中各计一条，共 4 条。watchdog 不使用 SMB、不复用跨目标连接、不设置自定义 `Host`，因此审查路径不满足 SMB 连接复用或自定义 Host cookie 泄漏前提。
- Web 镜像的 `CVE-2026-56131`、`CVE-2026-56407` 和 `CVE-2026-56408` 位于 `libexpat`。该库由字体/图像相关系统库带入；审查的 nginx 静态页面、固定版本代理和配对文本路径不解析 XML，未发现网络可达的 XML 输入路径。
- 上述结论是针对当前固定镜像、配置和已审查调用路径的可达性评估，不证明组件不存在其他利用方式。节点处理来自公共金融 P2P 网络的数据，残余影响可能包括远程代码执行、拒绝服务、数据泄露或错误解析。管理端只绑定回环、容器只读、最小 capability 和 `no-new-privileges` 只能降低影响，不能修复依赖漏洞。

## Introduction

Bisq 2 Node is a self-hosted trading node for Bisq Connect. It joins the Bisq peer-to-peer network over bundled Tor so your phone can use a node you control. It is not a Bitcoin full node and does not download the Bitcoin blockchain.

## Features

- Joins the Bisq 2 peer-to-peer network through bundled Tor
- Provides a self-controlled trading node for Bisq Connect
- Displays node status and a time-limited pairing QR code
- Persists node identity, databases, and Tor state
- Keeps the node API on shared loopback with no host publication

The management page is forcibly bound to `127.0.0.1:<local-management-port>` on the 1Panel host because it displays a pairing credential that can authorize node access and trade control. Reach it through an SSH tunnel, such as `ssh -L 8390:127.0.0.1:8390 user@server`, then open `http://127.0.0.1:8390/`. An existing authenticated HTTPS reverse proxy may target the loopback listener. Never rebind it to `0.0.0.0`, a public address, or an unauthenticated proxy.

Pairing codes default to 86400 seconds and may be configured from 300 through 86400 seconds. Close the page after pairing. A code is single-use and held only in node memory; every node start overwrites the QR file in `APP_DATA_DIR`, invalidating an unused code from the previous process. Node identity and paired-client records persist. Identity, keys, databases, Tor state, and the current QR file live in the project-relative data directory; uninstall does not remove them. Back up that directory and restrict 1Panel, Docker, and host access.

The node API stays unpublished on shared loopback `127.0.0.1:8090`. The Web sidecar exposes only the static UI, pairing text, and fixed version proxy. Both containers use read-only root filesystems, `no-new-privileges`, and reduced capabilities. The node still processes public financial P2P traffic over Tor; self-hosting does not make peers, offers, payment methods, dispute outcomes, or market data trustworthy.

## Security And Vulnerability Warning

- A 2026-07-28 scan of the two pinned `2.1.11.1` images reports `0 Critical / 11 High`: three node records and eight Web records, representing nine distinct vulnerabilities. Fixed versions exist but are not yet in these official images. Reassess and upgrade as soon as upstream publishes replacements.
- Node `GHSA-r7wm-3cxj-wff9` requires Jackson's asynchronous non-blocking number parser. Reviewed Bisq WebSocket JSON paths use synchronous `readValue(String, ...)` on complete messages and contain no `createNonBlocking*` calls, so the required entry point is absent.
- Node `CVE-2026-54512` and `CVE-2026-54513` require default polymorphic typing with permissive `PolymorphicTypeValidator` rules. No `activateDefaultTyping`, `enableDefaultTyping`, or relevant validator was found; reviewed DTO polymorphism uses fixed `JsonTypeInfo.Id.NAME` and explicit subtypes.
- Web `CVE-2026-33630` affects `c-ares`, which is present through `libcurl`. The watchdog calls a fixed numeric loopback URL and performs no DNS resolution.
- Web `CVE-2026-5773` and `CVE-2026-6276` each appear for both `curl` and `libcurl`, producing four records. The watchdog uses neither SMB, cross-target connection reuse, nor a custom `Host`, so the reviewed path lacks the documented prerequisites.
- Web `CVE-2026-56131`, `CVE-2026-56407`, and `CVE-2026-56408` affect `libexpat`. It is pulled through font/image system libraries; the reviewed nginx static UI, fixed version proxy, and pairing-text path parse no XML and expose no XML input path.
- This is a reachability assessment of the pinned images and reviewed paths, not proof that no exploit is possible. Residual impact can include remote code execution, denial of service, disclosure, or parser errors. Loopback-only management, read-only filesystems, least capabilities, and `no-new-privileges` reduce blast radius but do not patch vulnerable packages.

## References

- Source, release tag, and AGPL-3.0-only license: <https://github.com/bisq-network/bisq2/tree/v2.1.11>
- Official Bisq website: <https://bisq.network/>
- Bisq Connect support: <https://github.com/bisq-network/bisq-mobile/issues>
- Official Umbrel deployment submission: <https://github.com/getumbrel/umbrel-apps/pull/5850>
