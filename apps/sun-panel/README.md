# Sun-Panel

## 应用简介
一个服务器、NAS导航面板、Homepage、浏览器首页。

英文说明：Server, NAS navigation panel, Homepage, Browser homepage.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`1.8.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40198 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 账户密码
```
username: admin@sun.cc
password: 12345678
```

## 参考资料
- 官网: <https://sun-panel-doc.enianteam.com>
- 源码: <https://github.com/hslr-s/sun-panel>
