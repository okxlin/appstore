# LANraragi

## 应用简介
一个开源的漫画存档服务。

英文说明：Open source server for archival of comics/manga.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`0.9.21`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40290 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONTENT_DIRECTORY | 媒体库目录 | ./data/content | 是 |
| THUMBNAIL_DIRECTORY | 缩略图目录 | ./data/thumb | 是 |
| DATABASE_DIRECTORY | 数据库目录 | ./data/database | 是 |
| PLUGIN_DIRECTORY | 插件目录 | ./data/plugin | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HTTP_PROXY | HTTP 代理 | - | 否 |
| HTTPS_PROXY | HTTPS 代理 | - | 否 |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |

## 使用说明
默认密码`kamimamita`

- 可以自行更换汉化后的镜像：
  - 高级设置 > 编辑 compose 文件 > 对应修改`image: "difegue/lanraragi:latest"`
  - 修改为：`image: "mhdy2233/lanraragi_cn_mhdy:latest"`
  - 及其他镜像`image: "windycloud/lanraragi_cn:latest"`等

## 参考资料
- 官网: <https://lrr.tvc-16.science>
- 文档: <https://sugoi.gitbook.io/lanraragi/v/dev>
- 源码: <https://github.com/Difegue/LANraragi>
