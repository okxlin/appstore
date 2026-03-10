# Docker Mirror Monitor

实时监控多种容器镜像源的加速器状态，帮助开发者选择最佳的镜像源。

## 功能特性

* **多分组监控**：支持 Docker Hub、GHCR、Quay、K8s、GCR 等多种仓库。
* **实时更新**：基于 WebSocket 的实时状态推送。
* **配置生成**：一键生成 Docker `daemon.json` 或 Containerd 配置。
* **美观界面**：支持浅色/深色模式及多种配色主题。

## 使用说明

安装完成后，访问 `http://IP:端口` 即可使用。

如需修改监控目标或站点标题，请编辑安装目录下的 `data/config.yaml` 文件，然后调用 API 热加载或重启容器。