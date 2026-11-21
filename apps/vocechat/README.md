# VoceChat

## 产品介绍

VoceChat 是可自行部署的聊天服务，服务端运行在自己的服务器上，聊天数据保存在所配置的数据目录中。

## 主要功能

- 支持私聊和群聊。
- 提供 Web 客户端，并有 Android 和 iOS 移动客户端。
- 支持自行托管服务端和聊天数据。

## 部署说明

- 在 1Panel 应用表单中设置访问端口和数据目录。
- 默认 Web 端口为 `40067`，容器内服务端口为 `3000`。
- 数据目录默认是 `./data`。升级或迁移前，请先在 1Panel 中备份该目录。
- 对外提供访问时，请同步检查防火墙、安全组和反向代理配置。

## 参考资料

- [官网](https://voce.chat)
- [产品文档](https://doc.voce.chat)
- [服务端源码](https://github.com/Privoce/vocechat-server-rust)
