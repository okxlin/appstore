# Wavelog

## 应用简介
开源业余无线电通联日志。

英文说明：Open-source amateur radio QSO logger.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64、arm/v7。
- 当前仓库提供多个版本目录，安装时请以 1Panel 应用版本列表为准。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 3792 | 是 |

## 数据持久化
- `./data/wavelog-config:/var/www/html/application/config/docker`
- `./data/wavelog-uploads:/var/www/html/uploads`
- `./data/wavelog-userdata:/var/www/html/userdata`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_TYPE | 数据库服务 | mariadb | 是 |
| PANEL_DB_NAME | 数据库名 | wavelog | 是 |
| PANEL_DB_USER | 数据库用户 | wavelog | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | - | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 安全提示
- 当前应用使用上游官方镜像 `ghcr.io/wavelog/wavelog`。官方镜像功能完整，但常见镜像扫描结果可能包含较多 High / Critical 级别漏洞条目，请结合自身暴露面评估风险。
- 建议仅在可信网络中部署，及时跟进上游镜像更新，并通过反向代理、访问控制和最小暴露原则降低风险。

## 参考资料
- 官网: <https://www.wavelog.org/>
- 文档: <https://docs.wavelog.org/>
- 源码: <https://github.com/wavelog/wavelog>
