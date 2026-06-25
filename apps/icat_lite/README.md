# icat_lite

## 应用简介
喵空间社区程序 Lite 版。

英文说明：A mini bbs/forum/talk communicaty program.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`1.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_PORT | 数据库端口 | 5432 | 是 |
| PANEL_APP_PORT_HTTP | 端口 | 8095 | 是 |

## 数据持久化
- `./icat_lite/data:/icat_lite/www/data`
- `./icat_lite/system:/icat_lite/www/public/statics/system`
- `./icat_lite/systemBlock:/icat_lite/www/public/statics/systemBlock`
- `./icat_lite/sticker:/icat_lite/www/public/statics/sticker`
- `./icat_lite/certs:/icat_lite/certs`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_HOST | 数据库服务 | - | 是 |
| PANEL_DB_NAME | 数据库名 | icat_lite | 是 |
| PANEL_DB_USER | 数据库用户 | icat_lite | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | icat_bbs | 是 |
| ICAT_PWDKEY | 用于加密的密码的密钥 (丢失无法登录) | nevovltregopezeminatisejlbojudos | 是 |
| ICAT_COOKIEPWD | 登录状态加密密码 (至少32位) | fibowrlnidazotocrichechotechovad | 否 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://miao.o-o.zone>
- 文档: <https://github.com/0ui0/icat_lite_public>
