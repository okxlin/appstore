# Xiaomi Album Syncer

## 产品介绍

Xiaomi Album Syncer 通过 WebUI 将小米云服务中的相册与录音下载到本地，支持全量、增量和定时同步，并可按相册组织保存目录。

## 主要功能

- 下载小米云相册、录音及相关元数据。
- 执行全量、增量或定时同步任务。
- 支持 PassToken、UserId 和 Passkey 登录流程。
- 在本地目录中保存下载文件和同步数据库。

## 访问说明

- Web 端口由安装表单设置，默认 `8232`。
- 首次打开 WebUI 时需要设置一个强管理密码，该密码只用于本应用。
- 按上游文档完成小米账号授权后再创建同步任务。

## 数据持久化

- `DOWNLOAD_DIR` 挂载到 `/app/download`，保存相册和录音文件。
- `DATABASE_DIR` 挂载到 `/app/db`，保存账号授权、任务和同步记录。
- 容器本身不保存状态；升级前请备份两个挂载目录。

## 安全与使用风险

- 数据库目录包含小米账号授权信息，应限制宿主机读取权限并避免共享。
- 建议通过 1Panel 反向代理启用 HTTPS，不要直接将未加密的管理端暴露到公网。
- 删除任务或调整目录前请确认是否会影响已下载文件，并只同步您有权访问的内容。

## Introduction

Xiaomi Album Syncer downloads Xiaomi Cloud albums and recordings to local storage through full, incremental, or scheduled synchronization.

## Features

- Synchronize albums and recordings from Xiaomi Cloud.
- Run full, incremental, and scheduled jobs.
- Persist downloaded files, account authorization, and job state.
- Configure the application through a browser-based interface.

## Links

- Project and documentation: https://github.com/Coooolfan/XiaomiAlbumSyncer
- Image: https://hub.docker.com/r/coolfan1024/xiaomi-album-syncer
