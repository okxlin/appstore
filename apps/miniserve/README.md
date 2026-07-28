# miniserve

## 产品介绍

miniserve 是一个轻量级文件服务器，可通过浏览器查看和下载指定目录中的文件。

## 主要功能

- 提供目录浏览和文件下载
- 默认启用 HTTP 基本认证
- 默认禁止上传、创建目录和跟随符号链接
- 以只读方式挂载共享目录

## 访问说明

安装后通过 `http://<服务器 IP>:8080` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。使用安装表单设置的用户名和密码登录。

## Introduction

miniserve is a lightweight file server for browsing and downloading files from a selected directory.

## Features

- Browse directories and download files
- Require HTTP basic authentication by default
- Disable uploads, directory creation, and symlink traversal by default
- Mount the shared directory read-only

## 部署说明

- 使用官方镜像 `svenstaro/miniserve`。
- 提供 `latest` 和版本选择器列出的最新固定版本。
- 支持 amd64、arm64 和 armv7。

## 数据与安全

- `MOUNT_PATH` 指向需要共享的主机目录，容器仅以只读方式访问。
- 不要将系统目录、密钥目录或其他敏感路径设为共享目录。
- 服务必须通过用户名和随机生成的密码访问；对公网开放时仍建议使用 1Panel 反向代理配置 HTTPS。
- 升级或卸载不会删除共享目录中的文件。

## 参考资料

- 官网: <https://miniserve.cli.rs/>
- 源码: <https://github.com/svenstaro/miniserve>
- Docker 使用说明: <https://github.com/svenstaro/miniserve/blob/master/README.md#how-to-install>
