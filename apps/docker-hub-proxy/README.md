# Docker Hub Proxy

## 产品介绍
Docker Hub Proxy 是一个轻量级的 Docker Hub 镜像代理与加速服务，提供镜像搜索、代理拉取、节点测速与访问控制能力。

## 主要功能
- Web 控制台搜索与拉取 Docker 镜像
- 多代理节点管理与测速
- 可选管理员账户登录
- 支持 IP 白名单、镜像白名单/黑名单正则控制

## 访问说明
安装完成后访问：

```text
http://服务器IP:端口
```

首次进入可直接在 Web 控制台中搜索镜像、查看节点状态与复制代理拉取命令。

## 数据持久化
- `APP_DATA_DIR`：持久化 `/app/data`

若同时设置 `ADMIN_USER` 与 `ADMIN_PASS`，Web 控制台将启用登录保护；留空则保持公开访问。

## Introduction
Docker Hub Proxy is a lightweight Docker Hub image proxy and acceleration service with image search, proxy pulls, node testing, and access control.

## Features
- Web console for searching and proxy-pulling Docker images
- Multi-node management with latency testing
- Optional administrator authentication
- IP whitelist and regex-based image allow/deny controls

## 参考资料
- 源码: <https://github.com/xingfeng7788/docker-hub-proxy>
- 文档: <https://github.com/xingfeng7788/docker-hub-proxy/blob/main/README.md>
- Docker Hub: <https://hub.docker.com/r/qq510023514/docker-hub>
