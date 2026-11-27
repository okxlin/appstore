# Thunderbird

## 产品介绍
Thunderbird 是一款开源电子邮件客户端。本应用商店包使用 jlesage 维护的第三方容器镜像，并非 Thunderbird 项目官方镜像。

## 主要功能
- 通过浏览器使用 Thunderbird 图形界面。
- 通过 VNC 客户端连接桌面界面。
- 将配置、状态和需要持久化的文件保存在 `/config`。

## 访问说明
- 浏览器访问 `https://<服务器地址>:<PANEL_APP_PORT_HTTP>`。默认启用 HTTPS；关闭 `SECURE_CONNECTION` 后使用 HTTP。
- VNC 客户端连接 `<服务器地址>:<PANEL_APP_PORT_VNC>`。默认使用 SSL 隧道，客户端需要支持该连接方式。
- `CONFIG_PATH` 默认是 `./data`，挂载到容器的 `/config`。升级或迁移前，请在 1Panel 中备份此目录。
- VNC 密码最多 8 个字符；`SECURE_CONNECTION` 开启时，VNC 会话的安全方式由 `SECURE_CONNECTION_VNC_METHOD` 决定。
- `APP_NICENESS` 使用负值时，容器通过 `SYS_NICE` capability 调整进程优先级；默认值 `0` 不提高优先级。

如果从旧版本升级，原有 `VNC_PORT` 会用于保留旧 VNC 端口；升级后，外部访问端口由 `PANEL_APP_PORT_VNC` 管理。旧的 VNC 侦听端口值会保留在容器内，以兼容已保存的安装参数。

## 参考资料
- 官网: <https://www.thunderbird.net>
- 文档: <https://support.mozilla.org/en-US/products/thunderbird>
- 源码: <https://github.com/thunderbird>
- 容器项目: <https://github.com/jlesage/docker-thunderbird/tree/v26.11.2>
