# Fail2ban
## 产品介绍

Fail2ban 使用 LinuxServer.io 维护的 `linuxserver/fail2ban` 镜像，提供 Fail2ban 主机入侵防护服务 能力。

## 主要功能

- 提供 日志监控和封禁规则 能力
- 持久化保存配置和业务数据
- 使用安装表单配置数据路径、主机日志路径和日志级别
- 支持自定义时区

## 访问说明

Fail2ban 没有 Web 界面。安装完成后，在配置目录中编辑 jail 配置并查看 `/config/log/fail2ban/fail2ban.log`。

## 运行说明

该应用使用 host network，并需要 `NET_ADMIN`、`NET_RAW` 权限读取日志并管理封禁规则。默认 LinuxServer 配置中的 jail 处于禁用状态，请仅在确认日志路径和封禁规则后启用需要的 jail。

## Introduction

Fail2ban uses the LinuxServer.io maintained `linuxserver/fail2ban` image for log monitoring and ban rules.

## Features

- Provide log monitoring and ban rules
- Persist configuration and application data
- Configure data paths, host log path, and log verbosity from the install form
- Configure the container time zone

## Access

Fail2ban does not provide a web interface. After installation, edit jail files in the config directory and check `/config/log/fail2ban/fail2ban.log`.

## Runtime Notes

This app uses host networking and requires `NET_ADMIN` and `NET_RAW` so it can read logs and manage ban rules. LinuxServer's default jail configuration is disabled; enable only the jails whose log paths and ban actions you have reviewed.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-fail2ban/>
- Project website: <http://www.fail2ban.org/>
