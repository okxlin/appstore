# LiveKit

LiveKit 是面向开发者的实时 WebRTC SFU，用于将音频、视频和数据能力集成到自有应用。它不提供会议网页或用户管理界面；应用服务端必须用安装时设置的 API Key 与 API Secret 签发访问令牌。

## 产品介绍

LiveKit 提供实时音视频和数据转发能力，适合由现有网站、移动应用或服务端生成访问令牌后接入。

## 主要功能

- 支持 WebRTC 音频、视频和数据通道。
- 提供单节点部署所需的信令、TCP 回退和 UDP mux 端口。
- 使用 1Panel 表单保存 API Key、API Secret 和公网 IP 发现选项。

## 网络要求

- 信令端口用于 HTTP/WebSocket 连接，可由 1Panel 反向代理提供 TLS。
- WebRTC TCP 和 UDP 端口必须直接从公网到达容器，不能放在 HTTP/TLS 负载均衡器后。
- 默认使用一个 UDP mux 端口以适配 1Panel。高并发生产部署可按 LiveKit 官方文档改用更大的 UDP 端口范围或 host network。
- 公网 NAT 环境默认启用公网 IP 发现；纯内网测试时可关闭该选项。

## 单节点与升级

本包使用官方单节点模式，不包含 Redis。Redis 是多节点部署的推荐依赖，不能仅通过新增服务就安全转换为分布式集群。升级前请备份应用侧的令牌签发配置，并确保 API Key 与 API Secret 保持不变。

## 访问说明

- 信令端口默认是 `7880`，安装后由应用服务端通过 WebSocket 或 1Panel 反向代理访问。
- WebRTC TCP 和 UDP 端口需要在主机防火墙和公网入口中单独放行。
- 使用前请在自有后端按 LiveKit 官方 SDK 签发访问令牌，不要把 API Secret 放进浏览器代码。

## LiveKit

LiveKit is a developer-facing WebRTC SFU for integrating real-time audio, video, and data into an application. It does not include a meeting web UI or user administration; the application backend must issue access tokens with the API Key and API Secret configured at install time.

## Introduction

LiveKit provides real-time media and data forwarding for an existing website, mobile app, or backend that issues access tokens.

## Features

- WebRTC audio, video, and data channels.
- Signaling, TCP fallback, and a UDP mux port for single-node deployment.
- 1Panel form fields for API credentials and public-IP discovery.

## Network requirements

- The signaling port is for HTTP/WebSocket connections and can receive TLS through a 1Panel reverse proxy.
- The WebRTC TCP and UDP ports must be publicly reachable by the container and cannot sit behind an HTTP/TLS load balancer.
- This package uses one UDP mux port for 1Panel compatibility. High-concurrency deployments can use a larger UDP range or host networking as documented by LiveKit.
- Public-IP discovery is enabled by default for NAT environments and can be disabled for private-network testing.

## Single-node operation and upgrades

The package uses the official single-node mode without Redis. Redis is the recommended dependency for multi-node deployments and cannot be safely added as an untested sidecar. Back up application-side token issuing configuration before an upgrade and preserve the API Key and API Secret.

## Access

- The signaling port defaults to `7880` and is accessed by an application backend over WebSocket or through a 1Panel reverse proxy.
- WebRTC TCP and UDP ports must be opened separately in the host firewall and public ingress.
- Issue access tokens with an official LiveKit SDK in your own backend. Never ship the API Secret to browser code.
