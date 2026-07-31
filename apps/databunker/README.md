# DataBunker

## 产品介绍

DataBunker 是一个面向隐私和合规场景的加密数据存储服务。应用通过 REST API 保存敏感用户记录，以不可预测的令牌代替业务系统中的原始个人数据，并提供审计、同意管理和数据删除能力。

## 主要功能

- 使用独立主密钥加密存储个人数据。
- 通过 REST API 创建、读取、更新和删除用户记录。
- 提供令牌化、审计、同意管理和数据保留策略。
- 内置管理界面，并提供状态与健康检查端点。

## 部署拓扑

- 应用包运行一个 DataBunker 服务，使用上游 `securitybunker/databunker` 镜像。
- 安装时必须选择 1Panel 中已登记并运行的 MySQL 服务。1Panel 为当前应用创建独立数据库和独立用户，DataBunker 不复用 MySQL 管理员账号。
- DataBunker 的加密记录和应用结构保存在所选 MySQL 服务中；本地数据目录保存运行目录以及恢复应用所必需的根令牌和主密钥。

## 访问说明

默认 HTTP 端口为 `3000`。安装完成后，可访问 `http://服务器地址:安装端口/` 打开界面，`/status` 用于健康检查。

初始化脚本会生成符合上游格式要求的 48 位十六进制主密钥和 UUID 根令牌。凭据不会写入容器日志，而是以 `0600` 权限分别保存在所选数据目录的 `credentials/master-key` 和 `credentials/root-token` 文件中。可通过 1Panel 文件管理读取根令牌，并将其作为 `X-Bunker-Token` 请求头调用管理 API。

创建记录示例：

```bash
curl -X POST 'http://服务器地址:安装端口/v1/user' \
  -H 'X-Bunker-Token: <root-token>' \
  -H 'Content-Type: application/json' \
  -d '{"firstName":"Ada","lastName":"Lovelace","email":"ada@example.invalid"}'
```

响应中的用户令牌可用于 `/v1/user/token/<user-token>` 的读取、更新和删除操作。

## 备份与升级

- 备份时必须同时保存所选 MySQL 数据库、`credentials/master-key` 和 `credentials/root-token`。缺少原主密钥将无法解密数据库中的既有记录。
- `latest` 与固定版本使用相同的数据和初始化契约，可以直接交叉升级。升级脚本优先恢复数据目录中的持久凭据，不会轮换有效密钥。
- 升级前建议先完成数据库与本地数据目录备份，并在升级后检查 `/status` 及一次记录读取。

## 卸载

应用卸载脚本不会主动删除本地数据目录；默认相对数据目录仍位于应用安装目录内，因此不要把卸载行为当作备份。1Panel 的删除数据库选项会尝试移除关联数据库和用户，但远程 MySQL 登记的实际行为可能不同。卸载后请核对独立数据库和应用用户，仅在确认备份有效后精确清理仍存在的资源。

## 安全说明

- 根令牌具有管理权限，请限制数据目录访问权限，不要把凭据提交到代码仓库或发送到日志。
- 对外提供服务时请置于 HTTPS 反向代理之后并限制防火墙来源；不要通过明文 HTTP 发送根令牌或隐私数据。
- Compose 不使用特权模式、host 网络、额外 capability、设备映射或 Docker Socket。
- 镜像默认以非 root 的 `appuser` 运行。当前打包镜像支持 `amd64` 和 `arm64`，准入扫描未发现 Critical、High 或 Secret 结果。
- SMTP、短信网关和自定义 TLS 属于安装后的高级配置，本包保持上游默认配置；启用这些功能时请在备份配置后按上游文档调整。

## 参考资料

- 官网：<https://databunker.org/>
- 文档：<https://databunker.org/doc/>
- API：<https://github.com/securitybunker/databunker/blob/master/API.md>
- 源码：<https://github.com/securitybunker/databunker>

## Introduction

DataBunker is an encrypted vault and tokenization service for privacy-sensitive records. It exposes REST APIs for storing personal data behind opaque tokens, with auditing, consent management, and deletion workflows.

## Features

- Encrypt privacy-sensitive records with an application-specific master key.
- Create, read, update, and delete tokenized user records through REST APIs.
- Keep audit, consent-management, and retention-policy data in a dedicated MySQL database.
- Expose a built-in web interface and health endpoint without elevated container permissions.

The package runs one official DataBunker container and requires a MySQL service registered in 1Panel. During installation, 1Panel provisions a dedicated application database and user. The package initializes the schema automatically before starting the long-running service.

The initialization script creates a valid 48-character hexadecimal master key and UUID root token without printing either secret. They are stored with `0600` permissions under `credentials/master-key` and `credentials/root-token` in the selected data directory. Read the root token through 1Panel File Manager and send it in the `X-Bunker-Token` header.

Back up the MySQL database and both credential files together. Existing encrypted records cannot be recovered without the original master key. The uninstall script does not actively delete the local data directory, but the default relative path remains inside the app installation directory and is not a backup. 1Panel attempts to remove a linked database and user when that option is selected; verify the result for a remotely registered MySQL service and precisely remove only resources that remain. Put Internet-facing deployments behind HTTPS and never send the root token or privacy data over cleartext HTTP.
