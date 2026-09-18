# DBX

## 产品介绍
轻量级数据库管理工具，支持 25+ 种数据库。

英文说明：Lightweight database manager supporting 25+ databases.

## 主要功能
- 通过 Web 界面管理 MySQL、PostgreSQL、SQLite、Redis、MongoDB、DuckDB 等数据库。
- 使用持久化数据目录保存连接、驱动和其他 DBX 配置。

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本以应用商店当前版本目录和安装表单为准。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 4224 | 是 |

## 数据持久化
- `./data:/app/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_PASSWORD | 访问密码 | dbx_password | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 安全提示
- 当前 `t8y2/dbx:0.6.16` 已固定到经过核验的 manifest digest；该镜像未使用 privileged、host network 或 Docker Socket。
- Trivy 0.72.0 对镜像报告了以下 Critical 风险，当前均未提供固定版本：CVE-2026-58016（libglib2.0-0）、CVE-2025-7458（libsqlite3-0）、CVE-2026-13221/CVE-2026-42496/CVE-2026-8376（perl-base）以及 CVE-2023-45853（zlib1g）。这些风险属于上游基础镜像/系统包范围，已按维护授权记录接受风险，并将在上游提供修复后复核。
- 请保持访问密码为强随机值，不要在不受信任的网络中关闭密码保护。

## 参考资料
- 官网: <https://github.com/t8y2/dbx>
- 文档: <https://github.com/t8y2/dbx#readme>
