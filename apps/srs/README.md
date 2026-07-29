# SRS

## 产品介绍

SRS（Simple Realtime Server）是一个高性能的实时视频服务器，可用于直播推流、转码链路和低延迟音视频传输。

## 主要功能

- 支持 RTMP 推流和播放。
- 支持 HTTP-FLV 与 HLS 播放。
- 支持 SRT 推流与播放。
- 支持 WebRTC 实时通信。
- 提供 HTTP API 查询版本、客户端和流状态。
- 使用官方镜像，支持 `amd64`、`arm64` 和 `armv7`。

## 访问说明

- HTTP 流媒体与控制台：`http://<服务器地址>:<HTTP 端口>/`
- RTMP 推流：`rtmp://<服务器地址>:<RTMP 端口>/live/<流名称>`
- HTTP-FLV 播放：`http://<服务器地址>:<HTTP 端口>/live/<流名称>.flv`
- HLS 播放：`http://<服务器地址>:<HTTP 端口>/live/<流名称>.m3u8`
- SRT 端点：`srt://<服务器地址>:<SRT UDP 端口>`
- HTTP API：`http://<API 绑定地址>:<API 端口>/api/v1/versions`

HTTP API 默认只绑定 `127.0.0.1`，且 SRS 默认配置不提供 API 身份验证。不要在没有防火墙、反向代理访问控制或其他隔离措施时将 API 绑定地址改为公网接口。

WebRTC 使用 UDP 端口。需要从其他主机访问 WebRTC 时，请将 `CANDIDATE` 设置为客户端可到达的服务器公网 IP 或域名，并确保防火墙放行所选 UDP 端口。

默认配置不保存业务状态，不需要挂载数据目录。流媒体分片和运行状态会随容器重建而清除。

## Introduction

SRS (Simple Realtime Server) is a high-performance real-time video server for live streaming and low-latency media delivery.

## Features

- RTMP publishing and playback.
- HTTP-FLV and HLS playback.
- SRT publishing and playback.
- WebRTC real-time communication.
- HTTP APIs for version, client, and stream status.
- Official multi-architecture images for `amd64`, `arm64`, and `armv7`.

The HTTP API listens on `127.0.0.1` by default and has no authentication in the packaged SRS configuration. Keep it private or add an access-controlled reverse proxy before exposing it.

For WebRTC access from another host, set `CANDIDATE` to a client-reachable public IP address or domain and allow the selected UDP port through the firewall.

The packaged default has no persistent application state. Stream fragments and runtime state are removed when the container is recreated.

Use the app store version selector to choose between the moving and fixed upstream image tracks.

## 参考资料

- 官网：<https://ossrs.io/>
- 源码：<https://github.com/ossrs/srs>
- 入门文档：<https://ossrs.io/lts/en-us/docs/v6/doc/getting-started>
- 应用图标：来自 SRS 上游源码仓库，该仓库采用 MIT License。
