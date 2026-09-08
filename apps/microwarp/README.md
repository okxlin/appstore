# MicroWARP（1Panel v2）

基于 `ghcr.io/ccbkkb/microwarp` 的轻量级 Cloudflare WARP 代理封装，统一收敛为 `microwarp` 单 key，并提供官方原版与定时轮换变体。

## 产品介绍

MicroWARP 将 Cloudflare WARP 封装为可在 1Panel 中直接部署的 SOCKS5 代理；HTTP 变体通过 GOST 额外提供 HTTP 代理端口，rotator 变体负责定时重建 WARP 身份。

## 主要功能

- 支持 SOCKS5 代理及可选用户名、密码认证
- 支持 SOCKS5-only、SOCKS5 + HTTP、定时轮换三类组合
- 轮换前后通过代理检查真实出口 IPv4，并在同 IP 或检查失败时重试
- 重试耗尽后恢复上一次可用 WireGuard 配置

## 访问说明

- SOCKS5 端口由 `PANEL_APP_PORT_SOCKS5` 配置
- HTTP 变体的 HTTP 代理端口由 `PANEL_APP_PORT_HTTP_PROXY` 配置
- 代理服务不提供 Web 管理界面；请使用对应端口和 SOCKS5/HTTP 客户端连接
- 默认不启用认证；`ALLOW_NO_AUTH` 已在安装表单中提供，默认值为 `1` 以兼容旧版行为。设置为 `0` 时必须同时设置 `SOCKS_USER` 与 `SOCKS_PASS`，公网部署建议启用认证。
- `SOCKS_USER` 与 `SOCKS_PASS` 必须成对设置；表单中的 `ALLOW_NO_AUTH` 会原样传入容器。

## 版本说明

### latest
- 官方原版
- 仅提供 SOCKS5 代理
- 不做自动 IP 轮换，适合需要稳定出口身份的场景

### http-latest
- 官方原版增强变体
- 在 SOCKS5 基础上额外提供 HTTP 代理端口
- 通过 `gogost/gost` sidecar 将 HTTP 转发到 SOCKS5

### 固定轮换变体
- 基于官方原版增加定时 WARP 身份重建
- 使用固定版本镜像，避免滚动标签变化影响已有部署
- 轮换通过删除旧 `wg0.conf` 与账号缓存后重新执行上游初始化完成
- 每次轮换都会通过 SOCKS5 代理读取出口 IPv4；出口未变化或无法确认时自动重试
- 达到尝试次数仍没有新出口时恢复上一次可用配置，避免留下不可用代理
- 轮换时会有秒级短暂中断

### 固定轮换 HTTP 变体
- 在固定轮换变体基础上额外提供 HTTP 代理端口

## 安装建议

- 只需官方 SOCKS5：安装 `latest`
- 需官方 SOCKS5 + HTTP：安装 `http-latest`
- 需要定时切换 WARP 身份：安装 `rotator-latest`
- 需要定时切换并同时提供 HTTP：安装 `rotator-http-latest`

## 核心参数

- `PANEL_APP_PORT_SOCKS5`：SOCKS5 对外端口
- `PANEL_APP_PORT_HTTP_PROXY`：HTTP 代理端口，仅 HTTP 变体使用
- `APP_DATA_DIR_1`：WireGuard 持久化目录，保存 `wg0.conf` 与 `wgcf` 注册信息
- `SOCKS_USER` / `SOCKS_PASS`：启用 SOCKS5 认证
- `ENDPOINT_IP`：手动覆盖 WARP Endpoint
- `GH_PROXY`：辅助 `wgcf` 下载
- `TAILSCALE_CIDR`：Tailscale 回程路由 CIDR，默认 `100.64.0.0/10`
- `MTU`：WireGuard MTU，默认 `1280`
- `WARP_WGCF_CONF`：可选完整 WireGuard 配置内容；也可直接将 `wg0.conf` 放入持久化目录
- `ROTATE_INTERVAL_MINUTES`：轮换间隔（分钟），仅 `rotator-*` 版本使用，`0` 表示关闭
- `ROTATE_MAX_ATTEMPTS`：单次轮换最多重建身份的次数，默认 `5`
- `ROTATE_RETRY_DELAY_SECONDS`：轮换重试间隔（秒），默认 `5`
- `TEST_URL`：启动时通过 SOCKS5 探测代理的 URL
- `IP_CHECK_URL`：读取出口 IPv4 的 URL，响应需要包含 `ip=<IPv4>`，默认使用 Cloudflare trace

## 使用说明

- 默认使用外部网络 `1panel-network`
- 首次启动会自动注册 WARP 设备并生成 `/etc/wireguard/wg0.conf`
- 建议保留 `APP_DATA_DIR_1` 持久化目录，避免每次重启都重新注册
- 官方镜像内部支持通过 GitHub token 缓解 `wgcf` 版本查询的 API 限流，但本应用默认不在 1Panel 表单中暴露该参数，优先保持默认安装简洁稳定
- 如果设置了 `WARP_WGCF_CONF`，`rotator-*` 版本会自动关闭定时轮换，因为该配置已固定出口身份
- `rotator-*` 版本的轮换逻辑是完整重建 WARP 身份，而不是调用上游并不存在的 rotate API；会比较轮换前后的真实出口 IPv4
- 配置了 `SOCKS_USER` 和 `SOCKS_PASS` 时，轮换检查会使用相同的 SOCKS5 认证

## 安全提示

维护侧使用 Trivy 对 `microwarp` 镜像做过漏洞扫描，当前报告包含 Critical=1、High=12、Total=13。请优先在可信内网中使用，并关注上游镜像更新。

高风险示例：
- CRITICAL CVE-2026-56854 / golang.org/x/crypto：修复版本 0.55.0；golang.org/x/crypto/ssh: golang.org/x/crypto/ssh: Authentication bypass due to unenforced source-address restrictions
- HIGH CVE-2026-56852 / golang.org/x/text：修复版本 0.39.0；golang.org/x/text: golang.org/x/text: Denial of Service via invalid UTF-8 input
- HIGH CVE-2026-27145 / stdlib：修复版本 1.25.11, 1.26.4；crypto/x509: golang: golang crypto/x509: Denial of Service via excessive processing of DNS SAN entries
- HIGH CVE-2026-33818 / stdlib：修复版本 1.25.13, 1.26.6, 1.27.0-rc.3；encoding/asn1: golang: Go encoding/asn1: Denial of Service via excessive recursion in Unmarshal
- HIGH CVE-2026-39821 / stdlib：修复版本 1.25.13, 1.26.6, 1.27.0-rc.3；golang.org/x/net/idna: golang: net/http: golang.org/x/net/idna: Privilege escalation via incorrect Punycode label processing

## 升级说明

- 升级旧安装时，如果 `.env` 尚未有 `ALLOW_NO_AUTH`，升级脚本会补写 `ALLOW_NO_AUTH=1`；已有 `0` 或 `1` 会保留，不会覆盖用户选择。
- 已有 `rotator-latest` 与 `rotator-http-latest` 安装可直接升级到对应的固定轮换变体，不需要中间版本；固定版本目录用于确保 1Panel 提供升级入口
- 升级会保留 `APP_DATA_DIR_1` 中的 `wg0.conf`、WARP 注册信息和用户自定义环境变量；升级前仍建议使用 1Panel 备份该目录
- 1Panel 升级脚本会将当前版本的 `rotate.sh` 原子替换到已安装目录；若安装目录仍是旧脚本且无法定位新版载荷，升级会失败而不会继续运行旧轮换逻辑，重复执行则保持幂等
- 新增的 `ROTATE_MAX_ATTEMPTS`、`ROTATE_RETRY_DELAY_SECONDS` 与 `IP_CHECK_URL` 在旧 `.env` 缺失时使用安全默认值，不会覆盖旧的轮换间隔、端口或认证配置
- 升级后首次轮换可能产生秒级中断；若出口 IP 无法变化或无法确认，程序会恢复上一份可用配置

## Introduction

MicroWARP packages Cloudflare WARP as a 1Panel-ready SOCKS5 proxy. The HTTP variants add an HTTP proxy through GOST, while the rotator variants rebuild the WARP identity on a schedule and verify the real egress IPv4 through the proxy.

## Features

- SOCKS5 proxy with optional username/password authentication
- SOCKS5-only, SOCKS5 + HTTP, and scheduled-rotation variants
- Egress IPv4 verification before and after each rotation
- Retries for unchanged or unverifiable egress, with rollback to the last working WireGuard configuration

## Access

- Authentication is disabled by default; `ALLOW_NO_AUTH` is exposed in the installation form and defaults to `1` for legacy compatibility. When set to `0`, both `SOCKS_USER` and `SOCKS_PASS` must be provided; authentication is recommended for public deployments.
- `ALLOW_NO_AUTH` is passed through from the form, and `SOCKS_USER` and `SOCKS_PASS` must be configured together.

## Upgrade notes

- When upgrading an existing installation whose `.env` lacks `ALLOW_NO_AUTH`, the upgrade script adds `ALLOW_NO_AUTH=1`; an existing `0` or `1` is preserved.
- Existing `rotator-latest` and `rotator-http-latest` installations can upgrade directly to the corresponding fixed rotator variants; no intermediate version is required. The fixed package directories ensure that 1Panel exposes a real upgrade path.
- The upgrade preserves `APP_DATA_DIR_1`, including `wg0.conf`, WARP registration data, and existing user-defined environment values. Back up that directory through 1Panel before upgrading.
- The 1Panel upgrade script atomically replaces the installed `rotate.sh` with the target-version payload. If the installed script is still old and that payload cannot be located, the upgrade fails instead of continuing with the old rotation logic; reruns are idempotent.
- The new `ROTATE_MAX_ATTEMPTS`, `ROTATE_RETRY_DELAY_SECONDS`, and `IP_CHECK_URL` variables have safe Compose defaults when they are absent from an older `.env`; existing rotation interval, ports, and authentication settings are not overwritten.
- The first rotation after an upgrade may briefly interrupt the proxy. If a new or verifiable egress IP cannot be obtained, the last working configuration is restored.
