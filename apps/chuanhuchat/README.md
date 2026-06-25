# 川虎 Chat (Chuanhu Chat)

## 应用简介
为多种 LLM 提供了一个轻快好用的 Web 图形界面和众多附加功能。

英文说明：Lightweight and User-friendly Web-UI for LLMs.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40193 | 是 |

## 数据持久化
- `./data/history:/app/history`
- `./data/config.json:/app/config.json`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### 功能相关由`config.json`决定，配置问题注意查看官方文档与教程

- https://github.com/GaiZhenbiao/ChuanhuChatGPT/wiki

## 参考资料
- 官网: <https://github.com/GaiZhenbiao/ChuanhuChatGPT>
- 文档: <https://github.com/GaiZhenbiao/ChuanhuChatGPT/wiki>
