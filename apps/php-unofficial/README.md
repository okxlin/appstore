# PHP Unofficial

## 应用简介
非官方 PHP-FPM 容器，用于在 1Panel/OpenResty 环境中为站点提供 PHP 运行环境。

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 可选版本：`7.4.33`、`7.4.33-alpine`、`8.1.17`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 9001 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SITE_PATH | 网站目录文件路径 | /opt/1panel/apps/openresty/OpenResty/www | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### 注意事项
~~在1Panel V1.0.5及以下版本条件下，需要对官方OpenResty镜像和OpenResty配置进行修改才能正常部署PHP网站。~~

- 写在20230414：

1Panel V1.1.0版本的openresty已经添加了php文件支持，但存在缺点需要在创建网站时即创建PHP运行环境，

如果现有网站需要添加可能需要删除重建，这边提供另外一种思路。

如果修改openresty，不同的PHP版本只要监听不同的PHP容器服务端口即可，方便快捷。

> 以下是操作过程

V1.1.0版本拦截了PHP配置，如果需要使用第三方PHP容器提供服务。

需要修改openresty目录下的`fastcgi_params`文件，

`fastcgi_params`文件所在位置。以默认安装在`/opt`路径为例子，
```
/opt/1panel/apps/openresty/自定容器名/conf
```

修改成如下:
```
# 添加行1
fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;

fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  REQUEST_SCHEME     $scheme;
fastcgi_param  HTTPS              $https if_not_empty;

fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx;

fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;

# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;
# 添加行2，非必要
fastcgi_param  PHP_ADMIN_VALUE "open_basedir=$document_root/:/tmp/:/proc/";

```

然后修改openresty配置，监听php-fpm端口即可。

```
    # php服务端口例如 127.0.0.1:9000，按需修改
    location ~ [^/]\.php(/|$) {
        fastcgi_pass 127.0.0.1:9000;
        include fastcgi-php.conf;
        include fastcgi_params;
    }
```
点击保存并重载即可或重启openresty容器。
