# WuKongIM

## 应用简介
让信息传递更简单。

英文说明：Make messaging easier.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`1.2`、`2.0.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_WK_API | 悟空 IM api 端口 | 5001 | 是 |
| PANEL_APP_PORT_WK_TCP | 悟空 IM TCP 端口 | 5100 | 是 |
| PANEL_APP_PORT_WK_WS | 悟空 IM WS 端口 | 5200 | 是 |
| PANEL_APP_PORT_HTTP | 悟空 IM 监控端口 | 5300 | 是 |
| PANEL_APP_PORT_WK_DEMO_SERVER | 悟空 IM demo 端口 | 5172 | 是 |

## 数据持久化
- `./wukongim:/root/wukongim`
- `WK_DATASOURCE_ADDR=http://tangsengdaodaoserver:8090/v1/datasource`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| EXTERNAL_IP | 外部访问 IP | - | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://githubim.com>
- 源码: <https://github.com/TangSengDaoDao/TangSengDaoDaoServer>
