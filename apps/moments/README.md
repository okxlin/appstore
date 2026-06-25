# Moments

## 应用简介
一个 C# 开发的博客朋友圈平台。

英文说明：A C#-developed blogosphere platform.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`2.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40153 | 是 |

## 使用说明
- 默认密码

```
lantin
```

- 关于时区

可以在容器内执行，切换时区为东八区，重启容器即可。
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

- 数据默认以存储卷方式存储，类似卷`moments_data`

## 参考资料
- 官网: <https://moments.shiyu.dev/>
- 文档: <https://shiyu.dev/archives/2069/>
- 源码: <https://github.com/Drizzle365/Moments>
