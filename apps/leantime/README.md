# Leantime

## 产品介绍

Leantime 是面向团队和初创公司的开源项目管理平台，提供项目、任务、看板和知识库功能。

## 主要功能

- 通过 1Panel 选择的 MySQL 服务保存业务数据。
- 首次打开 `/install` 后按官方向导创建管理员和数据库结构。
- 持久化用户上传、插件和应用日志。

## 部署说明

- 安装时请选择一个已部署的 1Panel MySQL 服务。Leantime 使用该服务，不会启动内置数据库容器。
- `LEAN_SESSION_PASSWORD` 是会话签名密钥；安装后请保持该值不变，否则现有登录会话会失效。
- `LEAN_DATA_DIR` 必须保持在应用安装目录的 `./data` 下，以便安装脚本安全地修复官方镜像所需的目录权限。
- 直接通过 HTTP 端口访问时保持 `Secure Cookies` 为 `false`。使用 HTTPS 反向代理时请改为 `true`，并填写 `Public URL`。

## 访问说明

- 安装完成后访问 `http://<服务器地址>:<端口>/install`，创建第一个管理员账户。
- 完成初始化后，通过 `http://<服务器地址>:<端口>/` 登录并创建项目和任务。

## 数据持久化与升级

- `LEAN_DATA_DIR` 保存公开文件、用户文件、插件和日志；MySQL 服务保存业务数据。升级前请同时备份两者。
- 固定版本用于可复现部署；`latest` 跟随上游稳定镜像。上游数据库更新会在首次访问时引导到 `/update`，应在备份后按页面说明完成。
- 不要在多个安装中共享同一个数据库或数据目录。

## 参考资料

- 官网: <https://leantime.io/>
- 源码: <https://github.com/Leantime/leantime>
- 官方 Docker 部署: <https://github.com/Leantime/docker-leantime>

## Introduction

Leantime is an open-source project management platform for teams and startups.

## Features

- Uses a MySQL service selected from 1Panel.
- Provides the official first-run administrator setup at `/install`.
- Persists user files, plugins, and logs under `LEAN_DATA_DIR`.
