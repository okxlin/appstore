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

## 安全风险提示
维护侧对候选镜像的固定 digest 扫描发现当前基础镜像层包含 Critical=10、High=78 项漏洞，部分项目暂无上游修复版本。该版本已完成真实 1Panel 安装、升级、重启和卸载实装；使用前请评估暴露面，并优先部署在可信内网，等待上游镜像更新。

## Introduction
TREK is a travel planning and collaborative map application with itineraries, budgets, files, maps, and multi-user collaboration.

## Features
- Travel planning, maps, and timeline management
- Budget, files, and task collaboration
- Can auto-seed the first admin account on initial startup
- Preserves the upstream read-only root filesystem and minimal privilege setup

## Security risk notice
The maintainer scan of the pinned candidate image found Critical=10 and High=78 vulnerabilities in the current base image layers; some findings have no upstream fix yet. The version passed a real 1Panel install, upgrade, restart, and uninstall test. Assess your exposure before use, prefer a trusted network, and follow upstream image updates.

## 参考资料
- 源码: <https://github.com/mauriceboe/TREK>
- 文档: <https://github.com/mauriceboe/TREK/blob/main/README.md>
- Docker Hub: <https://hub.docker.com/r/mauriceboe/trek>
