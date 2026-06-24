# Faster Whisper
## 产品介绍

Faster Whisper 使用 LinuxServer.io 维护的 `linuxserver/faster-whisper` 镜像，提供 Faster Whisper 语音转写服务 能力。

## 主要功能

- 提供 Wyoming 协议语音转写服务
- 持久化保存配置和业务数据
- 使用 10300 端口供 Home Assistant 等 Wyoming 客户端连接
- 支持自定义时区

## 访问说明

安装完成后，在支持 Wyoming 协议的客户端中配置 `服务器地址:Wyoming端口`。该服务不提供传统 Web 管理界面。

## Introduction

Faster Whisper uses the LinuxServer.io maintained `linuxserver/faster-whisper` image for Wyoming speech transcription.

## Features

- Provide a Wyoming protocol speech transcription service
- Persist configuration and application data
- Expose port 10300 for Wyoming clients such as Home Assistant
- Configure the container time zone

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-faster-whisper/>
- Project website: <https://github.com/SYSTRAN/faster-whisper>
