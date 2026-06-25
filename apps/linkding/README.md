# linkding

## 应用简介
一个书签管理器，您可以自己托管。

英文说明：A bookmark manager that you can host yourself.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.45.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40123 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### 创建初始化用户

- 宿主机终端方式
```shell
docker exec -it xxx python manage.py createsuperuser --username=用户名 --email=邮箱
```

 * xxx 改成容器名称
 * 用户名 建议 `英文`
 * 邮箱 邮箱地址
 * 在`SSH`输入两次密码

- 容器终端方式

容器管理页面，连接容器终端执行
```shell
python manage.py createsuperuser --username=用户名 --email=邮箱
```

## 参考资料
- 官网: <https://github.com/sissbruecker/linkding>
