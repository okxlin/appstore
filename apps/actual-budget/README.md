# Actual Budget

## 产品介绍

Actual Budget 是隐私优先的开源个人财务应用，提供信封预算、账户与交易管理、规则、报表和多设备同步。

## 主要功能

- 信封预算与灵活预算管理
- 账户、交易、分类、规则和报表
- 预算导入导出、本地备份与多设备同步

## 访问说明

安装后通过 `http://<服务器 IP>:<端口>` 访问，实际端口以 `PANEL_APP_PORT_HTTP` 为准。首次打开时应立即设置服务器密码；在完成密码设置和反向代理 HTTPS 配置前，不要将端口暴露到不可信网络。

## 数据持久化

`APP_DATA_DIR` 保存服务器账户数据库、预算文件和同步数据。该路径必须位于应用版本目录内；初始化脚本会拒绝绝对路径、路径穿越和符号链接逃逸，并为上游容器用户 `1001:1001` 准备权限。卸载不会删除该目录，请定期独立备份。

## 安全与部署风险

- 容器以 UID/GID `1001:1001` 运行，丢弃全部 Linux capabilities，并启用只读根文件系统和 `no-new-privileges`。
- 固定版本 `26.7.0` 使用的镜像快照在 Trivy 扫描中仍包含上游未修复漏洞。其中两份受 `CVE-2026-59873` 影响的 `node-tar` 分别属于 npm CLI 和仅由 `node-gyp` 导入的构建链；Actual 的运行时导入、备份和同步上传路径使用 `AdmZip` 或限长后原样存储，未调用 `node-tar`。该结论是默认运行路径例外，不代表后续镜像中不存在漏洞。
- 如果在容器内手动运行 npm/node-gyp、增加执行外部命令的插件或改变官方入口，上述可达性结论将不再成立。`latest` 标签解析到新镜像时必须重新扫描。

## Introduction

Actual Budget is a privacy-focused open-source personal finance app with envelope budgeting, account and transaction management, rules, reports, and multi-device synchronization.

## Features

- Envelope and flexible budgeting
- Accounts, transactions, categories, rules, and reports
- Budget import/export, local backups, and multi-device synchronization

## Usage Notes

- Access the service at `http://<server-ip>:<port>` and set the server password immediately on first use. Do not expose it to an untrusted network before password setup and HTTPS reverse-proxy configuration are complete.
- `APP_DATA_DIR` stores the account database, budget files, and synchronization data. It must remain inside the application version directory and should be backed up independently.
- The container runs as UID/GID `1001:1001`, drops all Linux capabilities, and uses a read-only root filesystem plus `no-new-privileges`.

## Security Note

The image snapshot used by the fixed `26.7.0` package contains upstream vulnerabilities. Two `node-tar` copies affected by `CVE-2026-59873` belong to the npm CLI and the `node-gyp` build chain; Actual's runtime import, backup, and sync-upload paths use `AdmZip` or bounded opaque storage and do not invoke them. This is a default-path reachability exception, not a claim that later images are unaffected. The `latest` package follows a moving tag; a newly resolved image, running npm/node-gyp inside the container, or replacing the official entrypoint invalidates the exception and requires renewed review.

## References

- Project: <https://github.com/actualbudget/actual>
- Docker installation: <https://actualbudget.org/docs/install/docker/>
- Official Compose: <https://github.com/actualbudget/actual/blob/master/packages/sync-server/docker-compose.yml>
- License: <https://github.com/actualbudget/actual/blob/master/LICENSE.txt> (MIT)
- Security advisory: <https://github.com/advisories/GHSA-23hp-3jrh-7fpw>
