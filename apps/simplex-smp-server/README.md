# SimpleX SMP Server

## 产品介绍
SimpleX SMP Server 是官方推荐的自托管 SimpleX 中继服务，提供 SMP 消息中继端口，并生成可公开访问的服务器信息页。

## 主要功能
- 自托管 SMP 中继服务端口
- 内嵌 HTTP 服务器信息页，便于探活与公开说明
- 首次启动自动生成证书、指纹与 `smp-server.ini`
- 支持可选队列创建密码

## 访问说明
安装完成后：

```text
http://服务器IP:信息页端口
```

信息页端口用于查看服务器说明页；SimpleX 客户端实际连接请使用 `ADDR` 对应的公网域名或 IP 与 SMP 端口。

`ADDR` 默认值为 `127.0.0.1`，仅用于本地初始化与测试。正式使用前请改成你的公网域名或公网 IP。

## 数据持久化
- `APP_CONFIG_DIR`：持久化 `/etc/opt/simplex`，保存证书、指纹与 `smp-server.ini`
- `APP_STATE_DIR`：持久化 `/var/opt/simplex`，保存 store log、统计与信息页静态文件

## Introduction
SimpleX SMP Server is the official self-hosted relay server for SimpleX. This adaptation keeps the SMP relay port and enables the embedded HTTP server information page for 1Panel management and smoke testing.

## Features
- Self-hosted SMP relay port
- Embedded HTTP server information page
- Auto-generated certificates, fingerprint, and `smp-server.ini`
- Optional password for creating new queues

## 版本说明
固定版本使用官方镜像 `simplexchat/smp-server:v6.5.2`，`latest` 当前同样基于 6.5.x 发布线。

## 参考资料
- 官网: <https://simplex.chat/>
- 部署文档: <https://github.com/simplex-chat/simplex-chat/blob/stable/docs/SERVER.md>
- 源码: <https://github.com/simplex-chat/simplex-chat>
- Docker Compose 参考: <https://raw.githubusercontent.com/simplex-chat/simplexmq/stable/scripts/docker/docker-compose-smp-manual.yml>
- Docker Hub: <https://hub.docker.com/r/simplexchat/smp-server>
