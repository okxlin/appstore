# TREK

## 产品介绍
TREK 是一个旅行计划与协作地图应用，支持行程管理、预算、文件、地图和多人协作。

## 主要功能
- 旅行计划、地图与时间线管理
- 预算、文件和任务协作
- 首次启动可自动创建管理员账号
- 保留上游的只读根文件系统与最小权限设置

## 访问说明
安装完成后访问：

```text
http://服务器IP:端口
```

如果未在表单中填写 `ADMIN_EMAIL` 和 `ADMIN_PASSWORD`，TREK 会在首次启动时自动生成管理员账号，并输出到容器日志。

## 数据持久化
- `APP_DATA_DIR`：持久化 `/app/data`
- `APP_UPLOADS_DIR`：持久化 `/app/uploads`

## Introduction
TREK is a travel planning and collaborative map application with itineraries, budgets, files, maps, and multi-user collaboration.

## Features
- Travel planning, maps, and timeline management
- Budget, files, and task collaboration
- Can auto-seed the first admin account on initial startup
- Preserves the upstream read-only root filesystem and minimal privilege setup

## 参考资料
- 源码: <https://github.com/mauriceboe/TREK>
- 文档: <https://github.com/mauriceboe/TREK/blob/main/README.md>
- Docker Hub: <https://hub.docker.com/r/mauriceboe/trek>
