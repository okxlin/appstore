# ntfy

## 应用简介
基于 HTTP 的简单 pub-sub 通知服务。

英文说明：A simple HTTP-based pub-sub notification service.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：DevTool。
- 支持架构：amd64。
- 可选版本：`latest`、`2.24.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40265 | 是 |
| APP_PORT_INTERNAL | 容器内部端口 | 80 | 是 |

## 数据持久化
- `./data/cache/ntfy:/var/cache/ntfy`
- `./data/ntfy:/etc/ntfy`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
可以通过修改配置文件来自定义设置，文件路径如下，按需修改，将`server.yml.sample`修改为`server.yml`，

然后自定义修改内容即可。

```
/opt/1panel/apps/local/ntfy/ntfy/data/ntfy/server.yml.sample
```

## 参考资料
- 官网: <https://ntfy.sh/>
- 文档: <https://ntfy.sh/docs>
- 源码: <https://github.com/binwiederhier/ntfy>
