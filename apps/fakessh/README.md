# FakeSSH

## 产品介绍

FakeSSH 是一款轻量级 SSH 蜜罐，用于记录连接尝试和基础交互，不提供真实 Shell，适合快速部署以收集攻击者扫描行为。

## 主要功能

- 轻量级 SSH 蜜罐
- 记录连接尝试
- 容器以 root 运行以绑定 22 端口
- 无需持久化数据

## 访问说明

- 蜜罐端口：`PANEL_APP_PORT_SSH`（默认 2222）
- 该端口会暴露在主机上，用于接收外部 SSH 扫描和攻击流量
- 容器内部监听 22 端口

## Introduction

FakeSSH is a lightweight SSH honeypot that logs connection attempts and basic interaction without providing a real shell.

## Features

- Lightweight SSH honeypot
- Logs connection attempts
- Container runs as root to bind port 22
- No persistence required

## 安全提示

- 本应用会故意暴露 SSH 端口以吸引攻击流量，请仅在受控环境中使用。
- 容器内部以 root 运行，这是绑定 22 端口所必需的。
- 建议将蜜罐部署在隔离网络或防火墙后，避免影响生产服务。

## 数据持久化

本应用无需持久化数据。

## 升级说明

直接升级即可，无需额外数据迁移。

## 开源地址

- GitHub：https://github.com/fffaraz/fakessh
- 容器镜像：https://github.com/fffaraz/fakessh/pkgs/container/fakessh
