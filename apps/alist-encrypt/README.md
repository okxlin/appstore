# Alist-encrypt

## 应用简介
对 Alist 的服务提供 webdav 的加解密功能。

英文说明：Provides webdav encryption and decryption for Alist's services.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`beta`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40218 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| ALIST_HOST | Alist 服务地址 | 192.168.31.254:5254 | 是 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
启动后就打开代理服务器地址 `http://ip:端口/public/index.html` 即可进入配置页面，`账号 admin，密码默认 123456`。

配置后之后，打开`http://ip:端口` 即可访问到 alist 的服务了。

对于路径的设置，目前是支持正则表达式的，推荐表达式例如: movie_encrypt/\* ，这样的话所有的 movie_encrypt 目录的文件都会被加密传输。

## 参考资料
- 官网: <https://github.com/traceless/alist-encrypt>
