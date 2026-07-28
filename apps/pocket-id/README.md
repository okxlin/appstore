# Pocket ID

## 产品介绍

Pocket ID 是面向自托管服务的 OIDC 身份提供商，以通行密钥作为主要登录方式，可集中管理用户、OIDC 客户端和访问策略。

## 主要功能

- 使用 WebAuthn 通行密钥进行无密码登录
- 为兼容 OIDC 的应用提供单点登录
- 管理用户、用户组、OIDC 客户端、API 密钥和审计日志
- 默认使用内置 SQLite 数据库和本地持久化存储

## 访问说明

安装时必须将 `POCKET_ID_APP_URL` 设置为浏览器实际访问的完整源地址，例如 `https://id.example.com`。安装后访问该地址的 `/setup` 页面创建首个管理员账户并注册通行密钥。

## Introduction

Pocket ID is a passkey-first OIDC identity provider for self-hosted services. It centralizes users, OIDC clients, and access policies while using WebAuthn passkeys as the primary sign-in method.

## Features

- Passwordless authentication with WebAuthn passkeys
- Single sign-on for applications that support OIDC
- User, group, OIDC client, API key, and audit log management
- Embedded SQLite database and local persistent storage by default

## Deployment And Security

- This package uses the official non-root `pocketid/pocket-id` distroless image.
- `POCKET_ID_ENCRYPTION_KEY` defaults to `generate`; the install script creates and stores a 32-byte random key in the application `.env` file. Back up this key with the data directory and never rotate it by replacing the value manually.
- WebAuthn binds credentials to the configured origin. Set `POCKET_ID_APP_URL` to the final HTTPS origin before enrolling passkeys. Changing it later can prevent existing passkeys from working.
- `POCKET_ID_TRUST_PROXY` defaults to `false`. Configure only the exact reverse-proxy IP addresses or CIDR ranges that Pocket ID should trust.
- Keep the service behind HTTPS for any non-local deployment. Do not expose an uninitialized instance to an untrusted network.

## Data Persistence

Application state, the SQLite database, uploaded images, and generated files are stored in `./data` and mounted at `/app/data`. Back up both this directory and the application `.env` before upgrades or migrations.

## References

- Website: <https://pocket-id.org/>
- Source: <https://github.com/pocket-id/pocket-id>
- Documentation: <https://pocket-id.org/docs/>
- Environment variables: <https://pocket-id.org/docs/configuration/environment-variables>
