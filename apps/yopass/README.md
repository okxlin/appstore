# Yopass

## 产品介绍

Yopass 用于安全地分享密码、令牌和其他敏感文本。浏览器会在上传前使用 OpenPGP 加密内容，解密密钥不会发送到服务端。分享链接可以设置有效期，并可在第一次读取后立即失效。

本应用使用 Yopass 官方镜像和一个仅在应用内部网络可访问的 Memcached 服务。它不需要账户或数据库，也不会在磁盘中保存秘密。

## 主要功能

- 在浏览器中端到端加密秘密
- 生成带自动过期时间的分享链接
- 支持一次性读取，首次读取后立即删除服务端密文
- 支持密码保护和小文件加密上传
- 提供多语言 Web 界面和健康检查

## 访问说明

安装后通过 `http://<服务器地址>:<安装端口>` 打开 Yopass。输入秘密，选择有效期和一次性读取选项，然后生成分享链接。链接的 URL fragment 中包含解密材料；请只通过可信渠道发送完整链接。

Yopass 默认在容器内使用 HTTP。处理真实秘密时必须通过 1Panel 网站反向代理或其他可信代理启用 HTTPS，避免链接和页面内容在传输过程中被窃听或篡改。

## 数据与重启

默认后端是无持久化的 Memcached。尚未过期但未读取的秘密会在应用重启、Memcached 重启、升级或卸载时丢失，这是本默认拓扑的明确边界。一次性读取和自动过期机制不能替代 HTTPS、访问控制或组织内的秘密管理策略。

如需跨重启保留待领取秘密，应按上游文档单独规划 Redis 等持久化后端、备份、访问控制和迁移流程；该拓扑不属于本应用的默认包。

## 配置说明

- 默认过期时间只影响 Web 界面的初始选择，用户仍可在界面中选择其他上游支持的有效期。
- 最大密文长度限制发送到服务端的 OpenPGP 密文大小。
- Memcached 内存限制只控制临时密文缓存，不会创建持久卷。

## Introduction

Yopass securely shares passwords, tokens, and other sensitive text. The browser encrypts content with OpenPGP before upload, and the decryption key never reaches the server. Links can expire automatically and can be consumed exactly once.

This package runs the official Yopass image with a non-persistent Memcached service isolated on an app-internal network. Pending secrets are intentionally lost when the app or cache restarts. Use a trusted HTTPS reverse proxy before handling real secrets.

## Features

- Browser-side OpenPGP encryption
- Expiring and one-time secret links
- Optional password protection and encrypted file uploads
- Isolated non-persistent cache with no published Memcached port
- Built-in service and dependency health checks

## References

- Website: <https://yopass.se/>
- Documentation: <https://yopass.se/docs>
- Source: <https://github.com/jhaals/yopass>
- Official image: <https://hub.docker.com/r/jhaals/yopass>
