# Arcadia

## 应用简介
一站式代码运维平台。

英文说明：One-stop code operation and maintenance platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：DevTool。
- 支持架构：amd64。
- 可选版本：`beta`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40310 | 是 |

## 数据持久化
- `./data/config:/arcadia/config`
- `./data/log:/arcadia/log`
- `./data/scripts:/arcadia/scripts`
- `./data/repo:/arcadia/repo`
- `./data/raw:/arcadia/raw`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HOSTNAME | 主机名 | arcadia | 是 |

## 使用说明
- 账户密码
```
username: useradmin
password: passwd
```

## 参考资料
- 官网: <https://arcadia.cool>
- 文档: <https://arcadia.cool/docs>
- 源码: <https://github.com/SuperManito/Arcadia>
