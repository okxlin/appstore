# Music Tag Web

## 应用简介
一款可以编辑歌曲的标题，专辑，艺术家，歌词，封面等信息的应用程序。

英文说明：An app that can edit the title, album, artist, lyrics, cover, and more of the song.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`2.7.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40129 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 账户与密码

```
username：admin
password：admin
```

## 参考资料
- 官网: <https://github.com/xhongc/music-tag-web>
