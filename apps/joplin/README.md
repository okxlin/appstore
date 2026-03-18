# Joplin（浏览器版）

Joplin 是一款开源笔记应用。随时记录想法，并可在任何设备上安全访问。

这是一个通过浏览器访问的 Joplin 容器化版本（基于 LinuxServer 镜像）。

- 应用 Key：`joplin`
- 上游：
  - Joplin：<https://github.com/laurent22/joplin>
  - LinuxServer 镜像：<https://github.com/linuxserver/docker-joplin>

## 访问方式

- HTTP：`http://<服务器IP>:<PANEL_APP_PORT_HTTP>`（默认 3000）
- HTTPS（自签名证书）：`https://<服务器IP>:<PANEL_APP_PORT_HTTPS>`（默认 3001）

## 密码访问（Basic Auth）

该镜像支持通过环境变量启用 **Basic HTTP Auth**：

- `CUSTOM_USER`：用户名
- `PASSWORD`：密码

> 安全提示：该容器 GUI 内含终端且具备高权限能力，不建议直接暴露公网；如需公网访问，建议放在反向代理后并增加更强的认证与访问控制。

## 数据存储

使用 Docker **named volume**：`joplin-config` 持久化到容器内的 `/config`。
