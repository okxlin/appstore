# MicroWARP（1Panel v2）

基于 `ghcr.io/ccbkkb/microwarp` 的轻量级 Cloudflare WARP 代理封装，统一收敛为 `microwarp` 单 key，并提供官方原版与定时轮换变体。

## 版本说明

### latest
- 官方原版
- 仅提供 SOCKS5 代理
- 不做自动 IP 轮换，适合需要稳定出口身份的场景

### http-latest
- 官方原版增强变体
- 在 SOCKS5 基础上额外提供 HTTP 代理端口
- 通过 `gogost/gost` sidecar 将 HTTP 转发到 SOCKS5

### rotator-latest
- 基于官方原版增加定时 WARP 身份重建
- 轮换通过删除旧 `wg0.conf` 与账号缓存后重新执行上游初始化完成
- 轮换时会有秒级短暂中断

### rotator-http-latest
- 在 `rotator-latest` 基础上额外提供 HTTP 代理端口

## 安装建议

- 只需官方 SOCKS5：安装 `latest`
- 需官方 SOCKS5 + HTTP：安装 `http-latest`
- 需要定时切换 WARP 身份：安装 `rotator-latest`
- 需要定时切换并同时提供 HTTP：安装 `rotator-http-latest`

## 核心参数

- `PANEL_APP_PORT_SOCKS5`：SOCKS5 对外端口
- `PANEL_APP_PORT_HTTP_PROXY`：HTTP 代理端口，仅 `*-http-latest` 版本使用
- `APP_DATA_DIR_1`：WireGuard 持久化目录，保存 `wg0.conf` 与 `wgcf` 注册信息
- `SOCKS_USER` / `SOCKS_PASS`：启用 SOCKS5 认证
- `ENDPOINT_IP`：手动覆盖 WARP Endpoint
- `GH_PROXY`：辅助 `wgcf` 下载
- `TAILSCALE_CIDR`：Tailscale 回程路由 CIDR，默认 `100.64.0.0/10`
- `MTU`：WireGuard MTU，默认 `1280`
- `WARP_WGCF_CONF`：可选完整 WireGuard 配置内容；也可直接将 `wg0.conf` 放入持久化目录
- `ROTATE_INTERVAL_MINUTES`：轮换间隔（分钟），仅 `rotator-*` 版本使用，`0` 表示关闭

## 使用说明

- 默认使用外部网络 `1panel-network`
- 首次启动会自动注册 WARP 设备并生成 `/etc/wireguard/wg0.conf`
- 建议保留 `APP_DATA_DIR_1` 持久化目录，避免每次重启都重新注册
- 官方镜像内部支持通过 GitHub token 缓解 `wgcf` 版本查询的 API 限流，但本应用默认不在 1Panel 表单中暴露该参数，优先保持默认安装简洁稳定
- 如果设置了 `WARP_WGCF_CONF`，`rotator-*` 版本会自动关闭定时轮换，因为该配置已固定出口身份
- `rotator-*` 版本的轮换逻辑是完整重建 WARP 身份，而不是调用上游并不存在的 rotate API
