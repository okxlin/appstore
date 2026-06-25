# Artalk

## 应用简介
一款简洁的自托管评论系统。

英文说明：A concise self hosted comment system.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`2.9.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40159 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### Artalk 设置账号密码

以下两种方式相同。

### 1. 宿主机
```
docker exec -it artalk artalk admin
```

- 修改`artalk`改为容器名
- 如 `1Panel-localartalk-tYWg`
- 更改后
```
docker exec -it 1Panel-localartalk-tYWg artalk admin
```

### 2. 面板执行

面板`容器`界面，连接容器终端，执行以下命令

```
artalk admin
```

## 参考资料
- 官网: <https://artalk.js.org>
- 文档: <https://artalk.js.org/guide/intro.html>
- 源码: <https://github.com/ArtalkJS/Artalk>
