# telegraph

## 应用简介
基于 telegraph 的图床，图片大于 5MB 自动压缩。

英文说明：Telegraph-based graph bed with automatic compression for images larger than 5MB.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40224 | 是 |

## 使用说明
### 使用方法
### 服务器
安装nginx+php
下载源码，将文件上传到网站目录，访问域名即可！

#### 配置自己的反代域名
修改nginx配置
```
location /file {
            proxy_pass https://telegra.ph/file;
}
```
修改api/api.php文件第6行中的域名即可！

### docker

```docker pull baipiaoo/telegraph:latest```

```docker run -p 8080:80 -d --restart=always baipiaoo/telegraph```

复制功能由```navigator.clipboard```实现，需使用 HTTPS 协议！
###### nginx 反代配置
```
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
```    
### Star History

[![Star History Chart](https://api.star-history.com/svg?repos=0-RTT/telegraph&type=Date)](https://star-history.com/#0-RTT/telegraph&Date)

## 参考资料
- 官网: <https://jiasu.in>
- 文档: <https://github.com/0-RTT/telegraph>
