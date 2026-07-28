# Stump

## 产品介绍

Stump 是一个免费开源的漫画、漫画书与电子书服务器，支持 OPDS，并内置多种阅读器。

## 主要功能

- 管理 EPUB、PDF、CBZ/ZIP 和 CBR/RAR 文件
- 内置阅读器以及 EPUB 标注和高亮
- 支持 OPDS 1.2、OPDS 2.0、Kobo 与 KOReader 集成
- 支持多用户、权限和年龄限制

## 访问说明

安装后通过 `http://<服务器 IP>:10801` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。首次打开时按向导创建管理员账户。

## Introduction

Stump is a free and open-source comics, manga, and digital book server with OPDS support and built-in readers.

## Features

- Manage EPUB, PDF, CBZ/ZIP, and CBR/RAR files
- Read supported formats and annotate or highlight EPUB books
- Integrate through OPDS 1.2, OPDS 2.0, Kobo, and KOReader
- Manage multiple users, permissions, and age restrictions

## 部署说明

- 使用上游官方镜像 `aaronleopold/stump`。
- 提供 `latest` 和版本选择器列出的最新固定版本。
- 支持 amd64 和 arm64。
- Stump 仍处于 `1.0` 之前的测试阶段，升级前应备份配置目录。

## 数据与安全

- `CONFIG_PATH` 保存数据库和应用配置，`LIBRARY_PATH` 保存书库文件。
- 容器按 `PUID=1000`、`PGID=1000` 运行；请确保挂载目录允许该用户访问。
- Stump 启动时会调整配置目录所有权，并调整书库根目录所有权。挂载已有书库前请确认权限符合预期。
- 升级或卸载不会主动删除自定义绝对路径中的书库文件；操作前仍应备份重要数据。
- 对公网开放时，建议使用 1Panel 反向代理配置 HTTPS，并限制不必要的网络访问。

## 参考资料

- 官网: <https://www.stumpapp.dev/>
- 源码: <https://github.com/stumpapp/stump>
- Docker 文档: <https://www.stumpapp.dev/docs/getting-started/installation/docker>
