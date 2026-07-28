# Documenso

## 产品介绍

Documenso 是开源文档签署平台，支持文档上传、收件人工作流、签名字段、审计日志和签署证书。

## 主要功能

- 上传 PDF、配置收件人和签名字段
- 发送签署邀请、提醒和完成通知
- 保留审计日志并使用 X.509 证书封装完成的文档

## 访问说明

安装后通过 `NEXT_PUBLIC_WEBAPP_URL` 配置的地址访问。默认端口只绑定 `127.0.0.1`；需要外部访问时应通过 1Panel 反向代理发布 HTTPS，而不是直接暴露应用端口。

## 安装要求

- 必须选择一个 PostgreSQL 14 或更高版本的 1Panel 数据库运行环境。
- 必须填写可用的 SMTP 服务；签署邀请、验证码和完成通知依赖邮件投递。
- `NEXT_PUBLIC_WEBAPP_URL` 必须是用户实际访问的完整 HTTP(S) 地址。生产环境应通过反向代理提供 HTTPS。

## 签名证书和数据

初始化脚本会在 `./data/cert.p12` 首次生成带随机密码的自签名证书，并把密码和应用密钥写回权限为 `0600` 的 `.env`。证书在容器内只读挂载，升级时会校验并保留原证书；卸载不会删除该文件。数据库和 `cert.p12` 必须一起备份，否则无法维持既有签署身份。

## 安全说明

- 默认关闭 Documenso 匿名遥测，容器丢弃全部 Linux capabilities，并启用只读根文件系统和 `no-new-privileges`。
- 当前官方镜像的新鲜 Trivy 扫描仍含上游漏洞。`CVE-2026-59873` 位于 npm CLI 的 `tar@7.5.11`；本包不运行 npm/npx，而是直接执行镜像内的本地 Prisma CLI，文档上传也不会进入该依赖。`CVE-2025-68121` 位于 `react-email` 开发/预览 CLI 携带的 esbuild Go 二进制，生产服务器只使用 `@react-email/render`，不会执行 esbuild。
- 若镜像摘要改变、入口改回 npm/npx、加入运行时包安装/归档解包，或生产流程开始调用 `react-email`/esbuild CLI，上述默认路径例外立即失效，必须重新扫描与验证。

## Introduction

Documenso is an open-source document signing platform with document uploads, recipient workflows, signing fields, audit logs, and signing certificates.

## Features

- Upload PDFs and configure recipients and signing fields
- Send signing invitations, reminders, and completion notices
- Retain audit logs and seal completed documents with an X.509 certificate

## Requirements

- Select a 1Panel PostgreSQL 14+ runtime.
- Configure a working SMTP service. Signing invitations, verification messages, and completion notices depend on email delivery.
- Set `NEXT_PUBLIC_WEBAPP_URL` to the complete HTTP(S) URL used by recipients. Use an HTTPS reverse proxy in production.

## Signing Certificate And Backups

On first install, the initialization script creates a passphrase-protected self-signed certificate at `./data/cert.p12` and persists generated secrets in the mode-`0600` `.env` file. The certificate is mounted read-only and preserved across upgrades. Back up both PostgreSQL and `cert.p12`; losing the certificate changes the instance's signing identity.

## Security Note

The official images currently contain upstream vulnerabilities. This package bypasses the npm/npx startup path containing vulnerable `tar@7.5.11` and directly invokes the installed Prisma CLI. The vulnerable esbuild Go binary belongs to the unused `react-email` preview/build CLI; production rendering imports `@react-email/render` and does not execute esbuild. These are reachability exceptions, not claims that the vulnerable files are absent. Reassess whenever image digests or runtime commands change.

## References

- Project: <https://github.com/documenso/documenso>
- Self-hosting: <https://docs.documenso.com/docs/self-hosting>
- Signing certificate: <https://docs.documenso.com/docs/self-hosting/configuration/signing-certificate/local>
- Official Compose: <https://github.com/documenso/documenso/blob/v2.15.0/docker/production/compose.yml>
- License: <https://github.com/documenso/documenso/blob/v2.15.0/LICENSE> (AGPL-3.0)
- Security advisory: <https://github.com/advisories/GHSA-23hp-3jrh-7fpw>
