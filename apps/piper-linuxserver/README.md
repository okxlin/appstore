# Piper LinuxServer

## 产品介绍

Piper LinuxServer 使用 LinuxServer.io 维护的 `linuxserver/piper` 镜像，提供 Piper 文本转语音 Wyoming 服务。

## 主要功能

- 提供 Home Assistant 等客户端可连接的 Wyoming 文本转语音服务
- 持久化保存配置和业务数据
- 使用 10200 端口提供 Wyoming 协议服务
- 支持配置默认 Piper 语音模型
- 支持自定义时区

## 访问说明

安装完成后，在 Home Assistant Wyoming 集成或兼容客户端中填写服务器地址和 Wyoming 端口。默认语音模型为 `en_US-lessac-medium`，可在安装参数中调整。

## Introduction

Piper LinuxServer uses the LinuxServer.io maintained `linuxserver/piper` image for a Piper text-to-speech Wyoming service.

## Features

- Provide a Wyoming text-to-speech service for Home Assistant and compatible clients
- Persist configuration and application data
- Expose the Wyoming protocol service on port 10200
- Configure the default Piper voice model
- Configure the container time zone

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-piper/>
- Project website: <https://github.com/rhasspy/piper>
