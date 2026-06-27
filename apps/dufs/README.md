# Dufs

## 产品介绍
Dufs 是一个轻量文件服务器，支持静态文件访问、上传、搜索、访问控制和 WebDAV。

## 主要功能
- 提供基于浏览器的文件访问入口
- 支持上传、删除、搜索和 WebDAV 等可选能力
- 支持通过认证规则限制路径访问权限

## 访问说明
安装后通过 `http://<服务器 IP>:15032` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Dufs is a lightweight file server with upload, search, access control and WebDAV support.

## Features
- Browser-based file access
- Optional upload, delete, search and WebDAV capabilities
- Path-level access control through auth rules

## 部署说明
- 本应用使用官方 Docker 镜像 `sigoden/dufs` 部署。
- 应用分类：工具。
- 支持架构：amd64、arm64、armv7。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 访问端口 | 15032 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | 文件数据目录，挂载到容器 `/data` | ./data | 是 |

升级、迁移或开启写入能力前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DUFS_ALLOW_ALL | 是否允许上传、删除、搜索、创建、编辑等写入操作 | false | 是 |
| DUFS_AUTH | Dufs 认证规则，默认 `@/` 表示匿名只读访问 | @/ | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 默认安装提供匿名只读访问，不默认开放写入能力。
- 如果开启 `DUFS_ALLOW_ALL=true`，建议同时配置 `DUFS_AUTH` 并限制公网访问。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 项目仓库: <https://github.com/sigoden/dufs>
- Docker 使用说明: <https://github.com/sigoden/dufs#with-docker>
