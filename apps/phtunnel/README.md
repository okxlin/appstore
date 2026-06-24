# 花生壳

## 应用简介
花生壳内网穿透服务。

英文说明：Best Oray Intranet Penetration Service.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.0.0`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIPS | 这是一个提示说明 | 注意查看说明文档/Attention to the documentation | 是 |

## 使用说明
1. 部署完成后连接容器终端执行命令，获取`SN码`

```
phddns status
```

或者宿主机执行
```
# 按需修改容器名
docker exec 容器名 phddns status
```

1. 访问[官网](https://b.oray.com/)用`SN码`与默认登录密码`admin`登录，绑定账号添加内网穿透服务。

**官方教程：**
> [Docker - 花生壳内网穿透教程](https://service.oray.com/question/36626.html)

## 参考资料
- 官网: <https://hsk.oray.com>
- 文档: <https://service.oray.com/question/36626.html>
- 源码: <https://hub.docker.com/r/bestoray/phtunnel>
