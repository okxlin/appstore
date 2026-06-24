# Diosic

## 应用简介
一个开源的基于网络的音乐收集服务器和流媒体。

英文说明：An open source web-based music collection server and streamer.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40177 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data/data | 是 |
| MUSIC_PATH | 音乐文件夹路径 | ./data/library | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| LIBRARY_NAME | 音乐库名称 | 我的音乐库 | 是 |

## 使用说明
容器以普通用户身份运行的，

但是默认面板创建应用时，可能会将所需的数据文件夹设定身份为`root`，导致首次运行异常。

不用在意，执行以下命令，将文件夹改成普通用户身份，再重建应用即可。

- 路径注意按需修改
```
chown -R 1000:1000 /opt/1panel/apps/local/diosic/diosic/data
```

- 也可以：进入已安装应用界面，点击跳转数据目录，修改目录下的`data`文件夹为`www-data`用户。

***

## 参考资料
- 官网: <https://github.com/Reknij/diosic>
- 文档: <https://reknij.github.io/DiosicDocCN/>
