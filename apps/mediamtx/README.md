# MediaMTX

## 产品介绍

MediaMTX 是一款开源、即用型媒体服务器和媒体代理，可发布、读取、代理、转发和录制视频与音频流。

本应用使用上游官方镜像，默认以 Docker bridge 网络运行，仅启用并发布 RTSP TCP 端口。该默认配置避免了 RTSP UDP 对真实客户端地址和端口的要求，也不会默认启用 RTMP、HLS、WebRTC、SRT、MoQ 等额外协议服务。

## 主要功能

- 通过 RTSP/TCP 接收与分发实时音视频流
- 使用上游官方镜像和默认媒体路径配置
- 保持单服务、单端口的最小默认部署

## 访问说明

- 默认 RTSP 地址：`rtsp://<服务器地址>:<RTSP 端口>/<流路径>`
- 可使用 FFmpeg、GStreamer、VLC 或摄像机向该地址推流，并从同一路径读取。
- 默认配置不保存媒体或配置状态，容器重启后需要重新推流。
- 上游默认允许匿名推流和读取。将端口暴露到不可信网络前，请按照官方认证文档配置用户、权限和网络访问控制。
- 如需 RTMP、HLS、WebRTC、SRT、录制或自定义配置，请根据官方文档扩展应用编排，并只开放实际使用的端口。

官方文档：[mediamtx.org](https://mediamtx.org/docs/kickoff/install)

## Introduction

MediaMTX is an open-source, ready-to-use media server and media proxy that can publish, read, proxy, forward, and record video and audio streams.

This package uses the official upstream image, runs on a Docker bridge network, and enables and publishes only the RTSP TCP port. The default avoids the client-address requirements of RTSP UDP and does not enable the additional RTMP, HLS, WebRTC, SRT, or MoQ services.

## Features

- Receives and distributes live audio and video streams over RTSP/TCP
- Uses the official upstream image and its default media-path configuration
- Keeps the default deployment to one service and one published port

## Usage

- Default RTSP URL: `rtsp://<server-address>:<RTSP-port>/<stream-path>`
- Publish with FFmpeg, GStreamer, VLC, or a camera, then read from the same path.
- The default package does not persist media or configuration state. Streams must be published again after a container restart.
- Upstream defaults allow anonymous publishing and reading. Configure users, permissions, and network access controls from the official authentication documentation before exposing the port to untrusted networks.
- To enable RTMP, HLS, WebRTC, SRT, recording, or custom configuration, extend the application compose definition according to the official documentation and publish only the ports you actually use.

Documentation: [mediamtx.org](https://mediamtx.org/docs/kickoff/install)
