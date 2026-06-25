# meowfacts

## 应用简介
一个简单的 API，它返回一个 catfact。

英文说明：a simple api which returns a catfact.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40045 | 是 |

## 使用说明
当第一次部署时，假如出现异常问题，如容器未找到等，解决方式如下：

点击`已安装应用` > 找到应用 > 点`参数` > 点`编辑 `> 点`高级设置 `> 点击右下角`确认`。

采用的从源码编译镜像的方式，国内机子的话，假如因为各种网络原因，连接不上`github`，

可以尝试修改`/opt/1panel/resource/apps/local/meowfacts/latest/Dockerfile` 里的`github`源码链接，用诸如`ghproxy`等。

## 参考资料
- 官网: <https://github.com/wh-iterabb-it/meowfacts>
