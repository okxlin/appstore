# Diun

## 产品介绍

Diun 会检查本机 Docker 容器使用的镜像，并在镜像标签或摘要发生变化时记录和发送更新通知。默认只监视带有 `diun.enable=true` 标签的容器，也可以在安装表单中启用未标记容器监视。

## 主要功能

- 检查 Docker 容器镜像的标签和摘要变化
- 使用官方通知提供商发送镜像更新通知
- 通过 Docker Socket 读取本机容器和镜像信息

## 访问说明

- 本应用没有 Web 管理界面。运行状态、镜像检查结果和通知错误可在 1Panel 容器日志中查看。

## 使用说明

- 本应用没有 Web 管理界面。运行状态、镜像检查结果和通知错误可在 1Panel 容器日志中查看。
- 默认每 6 小时检查一次。检查计划使用标准五段 Cron 表达式。
- Diun 支持 Webhook、邮件、Gotify、ntfy、Telegram 等通知方式。请按官方通知文档添加对应的环境变量；未配置通知方式时，检查结果仍会写入日志。
- 数据库和已检查镜像状态保存在应用目录的 `data` 子目录中。

## 安全说明

本应用为实现 Docker provider 的核心功能，会将宿主机 `/var/run/docker.sock` 挂载到容器。能够访问 Docker Socket 的进程通常可以控制宿主机上的全部容器，并可能获得等同于宿主机 root 的权限。请仅使用可信镜像和配置，不要向不受信任的用户开放容器配置或环境变量修改权限。

## 参考资料

- 项目主页：<https://crazymax.dev/diun/>
- 源代码：<https://github.com/crazy-max/diun>
- Docker 安装：<https://crazymax.dev/diun/install/docker/>
- Docker provider：<https://crazymax.dev/diun/providers/docker/>
- 通知配置：<https://crazymax.dev/diun/config/notif/>

## Introduction

Diun checks the images used by local Docker containers and records or sends notifications when a tag or digest changes. It watches containers labelled `diun.enable=true` by default.

## Features

- Check Docker image tags and digest changes
- Send notifications through the official notification providers
- Read local container and image metadata through the Docker Socket
