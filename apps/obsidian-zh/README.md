# Obsidian (中文适配)

## 应用简介
一个使用Markdown语法的闭源笔记软件。

英文说明：A private and flexible writing app.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`1.0-ob1.3.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | HTTP 端口 | 40166 | 是 |
| PANEL_APP_PORT_VNC | VNC 端口 | 40167 | 是 |
| PANEL_APP_PORT_SSH | SSH 端口 | 40168 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HTTP_PWD | 密码 | password | 是 |
| DISPLAY_SIZE | 画面尺寸 | 1024x768 | 是 |
| PRIVILEGED_MODE | 特权模式开关 | true | 是 |

## 使用说明
注意，容器以`privileged`特权模式运行，注意安全问题。

如果只想放行个别端口，可以高级设置>编辑compose文件，删除或修改相关端口映射。

```
        ports:
            - ${HOST_IP}:${PANEL_APP_PORT_HTTP}:6090
            - ${HOST_IP}:${PANEL_APP_PORT_VNC}:5900
            - ${HOST_IP}:${PANEL_APP_PORT_SSH}:22
```
***

## 参考资料
- 官网: <https://obsidian.md>
- 文档: <https://help.obsidian.md>
- 源码: <https://github.com/WHG555/obsidian-docker>
