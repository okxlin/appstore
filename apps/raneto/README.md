# Raneto

## 应用简介
一个免费、开放、简单的 Markdown 支持的 Node.js 知识库。

英文说明：A free, open, and simple Markdown supported Node.js knowledge base.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40216 | 是 |

## 数据持久化
- `"./data/config:/opt/raneto/config`
- `"./data/content/pages:/opt/raneto/content/pages`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### 账号密码
> 默认账户1
- 账号：admin
- 密码：password

> 默认账户2
- 账号：admin2
- 密码：password

## 参考资料
- 官网: <https://raneto.com>
- 文档: <https://docs.raneto.com>
- 源码: <https://github.com/ryanlelek/Raneto>
