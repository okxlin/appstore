# NezhaDash

## 应用简介
一个基于 Next.js 和 哪吒监控 的仪表盘。

英文说明：A dashboard based on Next.exe and Nezha monitoring.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.1.12`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40309 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| NEZHA_BASE_URL | 哪吒面板地址 | - | 是 |
| NEZHA_AUTH | 哪吒面板 API Token | - | 是 |
| NEXT_PUBLIC_NezhaFetchInterval | 获取数据间隔（毫秒） | 2000 | 是 |
| NEXT_PUBLIC_CustomLogo | 自定义 Logo | https://nezha-cf.buycoffee.top/apple-touch-icon.png | 是 |
| NEXT_PUBLIC_CustomTitle | 自定义标题 | Nezha-Dash | 是 |
| NEXT_PUBLIC_CustomDescription | 自定义描述 | Nezha-Dash | 是 |
| DEFAULT_LOCALE | 默认语言 | zh | 是 |
| ForceShowAllServers | 是否强制显示所有服务器 | false | 是 |
| NEXT_PUBLIC_ShowFlag | 是否显示旗帜 | false | 是 |
| NEXT_PUBLIC_DisableCartoon | 是否禁用卡通人物 | false | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://nezha-cf.buycoffee.top>
- 文档: <https://github.com/hamster1963/nezha-dash>
