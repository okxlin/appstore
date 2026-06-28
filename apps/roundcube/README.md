# Roundcube

## 产品介绍
Roundcube 是一个开源 Webmail 客户端，可通过浏览器连接已有的 IMAP/SMTP 邮件服务器收发邮件。

## 主要功能
- 通过浏览器访问 IMAP 邮箱
- 使用外部 SMTP 服务器发送邮件
- 支持内置插件、主题和自定义配置
- 使用本地 SQLite 保存 Webmail 元数据

## 访问说明
安装后通过 `http://<服务器 IP>:18090` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
Roundcube is an open source Webmail client for accessing an existing IMAP and SMTP mail server from a browser.

## Features
- Browser-based IMAP mail access
- Send mail through an external SMTP server
- Built-in plugins, themes and custom configuration support
- Local SQLite metadata storage

## 部署说明
- 本应用使用官方 Docker 镜像 `roundcube/roundcubemail:1.7.1-apache-nonroot`。
- 应用分类：邮件服务。
- 支持架构：amd64、arm64。
- Roundcube 只是 Webmail 客户端，不包含邮件服务器。请先准备可用的 IMAP/SMTP 服务，例如已有邮箱服务或应用商店中的 Maddy Mail Server。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | Web 访问端口 | 18090 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APP_DATA_DIR | SQLite 数据库、自定义配置和 Enigma 插件数据目录 | ./data | 是 |

升级或迁移前，请先在 1Panel 中备份上述数据目录。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ROUNDCUBEMAIL_DEFAULT_HOST | IMAP 主机，可使用 `tls://` 或 `ssl://` 前缀 | ssl://mail.example.com | 是 |
| ROUNDCUBEMAIL_DEFAULT_PORT | IMAP 端口 | 993 | 是 |
| ROUNDCUBEMAIL_SMTP_SERVER | SMTP 主机，可使用 `tls://` 或 `ssl://` 前缀 | tls://mail.example.com | 是 |
| ROUNDCUBEMAIL_SMTP_PORT | SMTP 端口 | 587 | 是 |
| ROUNDCUBEMAIL_USERNAME_DOMAIN | 登录用户名自动补全域名，留空表示不补全 | 空 | 否 |
| ROUNDCUBEMAIL_REQUEST_PATH | 反向代理子路径 | / | 是 |
| ROUNDCUBEMAIL_PLUGINS | 启用的内置插件列表 | archive,zipdownload | 是 |
| ROUNDCUBEMAIL_DES_KEY | Roundcube 加密密钥，安装后不要随意修改 | 随机生成 | 是 |

## 使用说明
- 如果 IMAP/SMTP 使用隐式 TLS，主机通常写成 `ssl://mail.example.com`，端口使用 `993` 或 `465`。
- 如果 IMAP/SMTP 使用 STARTTLS，主机通常写成 `tls://mail.example.com`，端口使用 `143` 或 `587`。
- `ROUNDCUBEMAIL_DES_KEY` 会影响 Roundcube 保存的加密数据，迁移或重建容器时应保持不变。
- 自定义 Roundcube 配置可放入数据目录的 `config` 子目录，文件名需以 `.php` 结尾。

## 参考资料
- 官网: <https://roundcube.net/>
- 项目仓库: <https://github.com/roundcube/roundcubemail>
- 官方 Docker 镜像文档: <https://github.com/roundcube/roundcubemail-docker>
- 官方镜像: <https://hub.docker.com/r/roundcube/roundcubemail>
