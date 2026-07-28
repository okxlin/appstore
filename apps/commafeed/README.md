# CommaFeed

## 产品介绍

CommaFeed 是一款受 Google Reader 启发的自托管 RSS 阅读器，提供响应式界面、订阅分类和 OPML 导入导出。

## 主要功能

- 订阅和阅读 RSS、Atom 信息源
- 支持分类、搜索、规则和已读状态管理
- 支持 OPML 导入与导出
- 提供响应式界面、深色模式和键盘操作
- 提供 REST API 和 Fever 兼容 API

## 访问说明

安装后通过 `http://<服务器 IP>:8082` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。首次访问时创建管理员账户。

## Introduction

CommaFeed is a self-hosted RSS reader inspired by Google Reader, with a responsive interface, feed categories, and OPML import and export.

## Features

- Subscribe to and read RSS and Atom feeds
- Organize subscriptions with categories, searches, rules, and read states
- Import and export OPML files
- Use a responsive interface with dark mode and keyboard controls
- Integrate through the REST API or Fever-compatible API

## 部署与安全

- 使用官方 H2 原生镜像 `athou/commafeed`，数据保存在 `APP_DATA_DIR`。
- 会话凭据存储在加密 Cookie 中；请妥善保管安装表单生成的会话加密密钥，不要在已有会话时随意更换。
- 默认关闭公开注册。首次初始化接口只在数据库没有用户时可用。
- 默认阻止订阅源抓取访问本地和私有地址，以降低服务端请求伪造风险；因此不能直接订阅仅内网可访问的信息源。
- 对公网开放时建议通过 1Panel 反向代理启用 HTTPS，并限制不受信任的网络访问。

## 数据持久化

`APP_DATA_DIR` 挂载到容器 `/commafeed/data`，保存 H2 数据库和应用状态。升级、迁移或卸载前请备份该目录。

## 参考资料

- 官网: <https://www.commafeed.com/>
- 源码: <https://github.com/Athou/commafeed>
- 文档: <https://athou.github.io/commafeed/documentation/>
- Docker 说明: <https://github.com/Athou/commafeed/blob/7.2.0/commafeed-server/src/main/docker/README.md>
