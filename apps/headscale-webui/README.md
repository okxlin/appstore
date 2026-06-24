# Headscale-WebUI

## 应用简介
适用于小规模部署的简单 Headscale 网络用户界面。

英文说明：A simple Headscale web UI for small-scale deployments.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40185 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |
| HEADSCALE_PATH | Headscale 配置文件路径 | /opt/1panel/apps/local/headscale/headscale/data/config | 是 |
| URL_PATH | 后台管理路径 | /admin | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HS_SERVER | Headscale 服务器链接 | http://172.18.0.241:8080 | 是 |
| External_URL | 外部访问地址 (域名地址) | https://hs.example.com | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| SECRET_KEY | 加密密钥 (终端执行'openssl rand -base64 32'获得) | TvMhk7FDnAfaIwp0RDRsq3AVNdrYBuhNT0NTPNw4vIQ= | 是 |
| AUTH_TYPE | 验证方式 (留空无 http 验证) | Basic | 否 |
| HTTP_USER | HTTP 用户 | user | 否 |
| HTTP_PWD | HTTP 密码 | password | 否 |

## 使用说明
### 数据文件夹授权

- 1、**必要操作：** 首次安装完成后，进入已安装应用界面，点击跳转数据目录，修改目录下的`data`文件夹为`1000`用户和用户组。

命令行修改则类似如下，路径按需修改：
```
chown -R 1000:1000 /opt/1panel/apps/local/headscale-webui/headscale-webui/data
```

- 2、回到已安装应用界面，重建应用。

## 参考资料
- 官网: <https://github.com/iFargle/headscale-webui>
