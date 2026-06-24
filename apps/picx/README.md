# PicX

## 应用简介
一款基于 GitHub API 开发的图床工具。

英文说明：A picture bed tool based on GitHub API.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40131 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
当第一次部署时，假如出现异常问题，如容器未找到等，解决方式如下：

点击`已安装应用` > 找到应用 > 点`参数` > 点`编辑 `> 点`高级设置 `> 点击右下角`确认`。

采用的从源码编译镜像的方式，国内机子的话，假如因为各种网络原因，连接不上`github`，

可以尝试修改应用目录下，即类似`/opt/1panel/apps/local/picx/picx/Dockerfile` 文件里的`github`源码链接，用诸如`ghproxy`等。

然后重建应用

## 参考资料
- 官网: <https://picx.xpoet.cn>
- 文档: <https://picx-docs.xpoet.cn>
- 源码: <https://github.com/XPoet/picx>
