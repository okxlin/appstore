# Cowrie

## 产品介绍

Cowrie 是一个中交互 SSH/Telnet 蜜罐，用于记录攻击者的暴力破解尝试和 Shell 交互行为，帮助安全研究人员分析自动化攻击。

## 主要功能

- 中交互 SSH/Telnet 蜜罐
- 记录登录尝试、命令执行和文件下载
- 支持日志输出到多种后端
- 容器以非 root 用户运行

## 访问说明

- SSH 蜜罐端口：PANEL_APP_PORT_SSH（默认 2222）
- Telnet 蜜罐端口：PANEL_APP_PORT_TELNET（默认 2223）
- 这两个端口会暴露在主机上，用于接收外部扫描和攻击流量
- 本应用按上游 Docker 配置启用 Telnet；如需停用，请同时移除 Telnet 端口映射并修改容器环境变量。

## Introduction

Cowrie is a medium-interaction SSH and Telnet honeypot designed to log brute-force attacks and shell interaction performed by attackers.

## Features

- Medium-interaction SSH/Telnet honeypot
- Records login attempts, command execution, and file downloads
- Supports multiple log output backends
- Runs as a non-root user inside the container

## 安全提示

- 本应用会故意暴露 SSH/Telnet 端口以吸引攻击流量，请仅在受控环境中使用。
- 建议将蜜罐部署在隔离网络或防火墙后，避免影响生产服务。
- 容器内部以 UID 999 运行，安装脚本会自动将数据目录所有权设置为 999:999。

## 数据持久化

- `/cowrie/cowrie-git/var`：日志、下载文件和运行时数据，映射到 `APP_DATA_DIR`
- `/cowrie/cowrie-git/etc`：配置文件，映射到 `APP_DATA_DIR/etc`

卸载应用只会停止并删除容器，不会删除 `APP_DATA_DIR` 中的日志、下载文件或配置。删除这些数据前，请先确认不再需要蜜罐记录。

## 升级说明

升级前建议备份 `APP_DATA_DIR` 中的日志数据。

## 开源地址

- 项目主页：https://cowrie.org
- GitHub：https://github.com/cowrie/cowrie
- Docker 镜像：https://hub.docker.com/r/cowrie/cowrie
- 官方 Compose：https://raw.githubusercontent.com/cowrie/cowrie/master/docker/docker-compose.yml
