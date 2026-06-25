# Thunderbird

## 应用简介
开源的电子邮件客户端 (Kasm)。

英文说明：Open-source email client (Kasm).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：邮件。
- 支持架构：amd64。
- 可选版本：`1.19.0`、`develop`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTPS | 端口 | 40327 | 是 |

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HTTP_PWD | 访问密码 | password | 是 |
| MEM_USE | 共享内存占用(1gb) | 1024m | 是 |

## 使用说明
- 默认账户
```
username: kasm_user
```

## 参考资料
- 官网: <https://www.thunderbird.net>
- 文档: <https://support.mozilla.org/en-US/products/thunderbird>
- 源码: <https://github.com/thunderbird>
