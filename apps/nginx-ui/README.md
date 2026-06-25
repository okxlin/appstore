# Nginx UI

## 应用简介
Nginx 网络管理界面。

英文说明：Yet another WebUI for Nginx.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：服务器。
- 支持架构：amd64。
- 可选版本：`latest`、`2.0.0-beta.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 控制台端口 | 31080 | 是 |
| PANEL_APP_PORT_HTTPS | HTTPS端口 | 31443 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |
| WEB_PATH | 网页文件夹路径 | ./data/www | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### 使用方法

第一次运行 Nginx UI 时，请在浏览器中访问 `http://<your_server_ip>:<listen_port>/install` 完成后续配置。

#### 通过执行文件运行
**在终端中运行 Nginx UI**

```shell
nginx-ui -config app.ini
```
在终端使用 `Control+C` 退出 Nginx UI。

**在后台运行 Nginx UI**

```shell
nohup ./nginx-ui -config app.ini &
```
使用以下命令停止 Nginx UI。

```shell
kill -9 $(ps -aux | grep nginx-ui | grep -v grep | awk '{print $2}')
```
#### 使用 Systemd
如果你使用的是[Linux 安装脚本](#linux-安装脚本)，Nginx UI 将作为 `nginx-ui` 服务安装在 systemd 中。请使用 `systemctl` 命令控制。

**启动 Nginx UI**

```shell
systemctl start nginx-ui
```
**停止 Nginx UI**

```shell
systemctl stop nginx-ui
```
**重启 Nginx UI**

```shell
systemctl restart nginx-ui
```

#### 使用 Docker

您可以在 docker 中使用我们提供的 `uozi/nginx-ui:latest` [镜像](https://hub.docker.com/r/uozi/nginx-ui)，此镜像基于 `nginx:latest` 构建。您可以直接将其监听到 80 和 443 端口以取代宿主机上的 Nginx。

注意：映射到 `/etc/nginx` 的文件夹应该为一个空目录。

#### 注意
1. 首次使用时，映射到 `/etc/nginx` 的目录必须为空文件夹。
2. 如果你想要托管静态文件，可以直接将文件夹映射入容器中。

**Docker 部署示例**

```bash
docker run -dit \
  --name=nginx-ui \
  --restart=always \
  -e TZ=Asia/Shanghai \
  -v /mnt/user/appdata/nginx:/etc/nginx \
  -v /mnt/user/appdata/nginx-ui:/etc/nginx-ui \
  -p 8080:80 -p 8443:443 \
  uozi/nginx-ui:latest
```

### Nginx 反向代理配置示例

```nginx
server {
    listen          80;
    listen          [::]:80;

    server_name     <your_server_name>;
    rewrite ^(.*)$  https://$host$1 permanent;
}

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen  443       ssl http2;
    listen  [::]:443  ssl http2;

    server_name         <your_server_name>;

    ssl_certificate     /path/to/ssl_cert;
    ssl_certificate_key /path/to/ssl_cert_key;

    location / {
        proxy_set_header    Host                $host;
        proxy_set_header    X-Real-IP           $remote_addr;
        proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto   $scheme;
        proxy_http_version  1.1;
        proxy_set_header    Upgrade             $http_upgrade;
        proxy_set_header    Connection          $connection_upgrade;
        proxy_pass          http://127.0.0.1:9000/;
    }
}
```

## 参考资料
- 官网: <https://nginxui.com/>
- 源码: <https://github.com/0xJacky/nginx-ui>
