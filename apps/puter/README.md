# Puter

## 应用简介
先进的开源互联网操作系统。

英文说明：An advanced, open-source internet operating system.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40263 | 是 |
| PANEL_APP_PORT_INTERNAL | 容器内部端口 | 4100 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 (容器内部) | /etc/puter | 是 |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
- 默认用户名与密码查看容器日志获取

- 修改配置文件后重建应用生效

- 注意查看官方文档以及登录页面的提示，修改配置文件的端口和域名/IP等的设置

配置文件路径，按需修改

```
/opt/1panel/apps/local/puter/puter/data/config/config.json
```

## 参考资料
- 官网: <https://puter.com>
- 文档: <https://github.com/HeyPuter/puter>
