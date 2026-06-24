# Telegram Desktop

## 应用简介
适用于Kasm Workspaces 的电报桌面。

英文说明：Telegram Desktop for Kasm Workspaces.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`1.19.0`、`develop`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTPS | HTTP端口 | 40105 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HTTP_PWD | 访问密码 | password | 是 |
| MEM_USE | 共享内存占用(1gb) | 512m | 是 |

## 使用说明
- 访问链接`https`：

`https://IP_OF_SERVER:6901`

- 账户密码
```
username: kasm_user
password: password
```

## 参考资料
- 官网: <https://telegram.org>
- 文档: <https://telegram.org/faq>
- 源码: <https://github.com/telegramdesktop/tdesktop>
