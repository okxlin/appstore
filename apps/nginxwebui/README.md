# nginxWebUI

## 应用简介
Nginx 网页管理工具。

英文说明：Nginx Web page configuration tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：服务器。
- 支持架构：amd64。
- 可选版本：`latest`、`4.4.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_CONSOLE | 控制台端口 | 40093 | 是 |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 80 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS 端口 | 443 | 是 |

## 数据持久化
- `./data:/home/nginxWebUI`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
打开 http://xxx.xxx.xxx.xxx:8080 进入主页

![输入图片说明](http://www.nginxwebui.cn/img/login.jpeg "login.jpg")

登录页面, 第一次打开会要求初始化管理员账号

![输入图片说明](http://www.nginxwebui.cn/img/admin.jpeg "admin.jpg")

进入系统后, 可在管理员管理里面添加修改管理员账号

![输入图片说明](http://www.nginxwebui.cn/img/http.jpeg "http.jpg")

在http参数配置中可以配置nginx的http项目,进行http转发, 默认会给出几个常用配置, 其他需要的配置可自由增删改查. 可以勾选开启日志跟踪, 生成日志文件。

![输入图片说明](http://www.nginxwebui.cn/img/tcp.jpeg "tcp.jpg")

在TCP参数配置中可以配置nginx的stream项目参数, 大多数情况下可不配.

![输入图片说明](http://www.nginxwebui.cn/img/server.jpeg "server.jpg")

在反向代理中可配置nginx的反向代理即server项功能, 可开启ssl功能, 可以直接从网页上上传pem文件和key文件, 或者使用系统内申请的证书, 可以直接开启http转跳https功能，也可开启http2协议

![输入图片说明](http://www.nginxwebui.cn/img/upstream.jpeg "upstream.jpg")

在负载均衡中可配置nginx的负载均衡即upstream项功能, 在反向代理管理中可选择代理目标为配置好的负载均衡

![输入图片说明](http://www.nginxwebui.cn/img/html.jpeg "html.jpg")

在html静态文件上传中可直接上传html压缩包到指定路径,上传后可直接在反向代理中使用,省去在Linux中上传html文件的步骤

![输入图片说明](http://www.nginxwebui.cn/img/cert.jpeg "cert.jpg")

在证书管理中可添加证书, 并进行签发和续签, 开启定时续签后, 系统会自动续签即将过期的证书, 注意:证书的签发是用的acme.sh的dns模式, 需要配合阿里云的aliKey和aliSecret来使用. 请先申请好aliKey和aliSecret

![输入图片说明](http://www.nginxwebui.cn/img/bak.jpeg "bak.jpg")

备份文件管理, 这里可以看到nginx.cnf的备份历史版本, nginx出现错误时可以选择回滚到某一个历史版本

![输入图片说明](http://www.nginxwebui.cn/img/conf.jpeg "conf.jpg")

最终生成conf文件,可在此进行进一步手动修改,确认修改无误后,可覆盖本机conf文件,并进行效验和重启, 可以选择生成单一nginx.conf文件还是按域名将各个配置文件分开放在conf.d下
 
![输入图片说明](http://www.nginxwebui.cn/img/remote.jpeg "remote.jpg")

远程服务器管理, 如果有多台nginx服务器, 可以都部署上nginxWebUI, 然后登录其中一台, 在远程管理中添加其他服务器的ip和用户名密码, 就可以在一台机器上管理所有的nginx服务器了.

提供一键同步功能, 可以将某一台服务器的数据配置和证书文件同步到其他服务器中

#### 找回密码

如果忘记了登录密码或没有保存两步验证二维码，可按如下教程重置密码和关闭两步验证.

1.停止nginxWebUI进程或停止docker容器运行

2.使用找回密码参数运行nginxWebUI.jar, docker用户需单独下载nginxWebUI.jar运行此命令

```
java -jar nginxWebUI.jar --project.home=/home/nginxWebUI/ --project.findPass=true
```

--project.home 为项目文件所在目录, 使用docker容器时为映射目录

--project.findPass 为是否打印用户名密码

运行成功后即可重置并打印出全部用户名密码并关闭两步验证

## 参考资料
- 官网: <https://www.nginxwebui.cn>
- 文档: <https://www.nginxwebui.cn/product.html>
- 源码: <https://github.com/cym1102/nginxWebUI>
