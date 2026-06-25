# OpenTDP

## 应用简介
可以跨平台部署的云资源管理面板。

英文说明：Cloud resource management dashboard for cross-platform deployment.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40250 | 是 |

## 数据持久化
- `./data/conf:/etc/tdp-cloud`
- `./data/data:/var/lib/tdp-cloud`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
初始账号 `admin` ，密码 `123456`

***

## 参考资料
- 官网: <https://docs.opentdp.org>
- 源码: <https://github.com/opentdp/tdp-cloud>
