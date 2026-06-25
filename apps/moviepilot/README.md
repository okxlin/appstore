# MoviePilot

## 应用简介
NAS 媒体库自动化管理工具。

英文说明：NAS Media Library Automation Management Tool.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`2.13.14`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 面板 HTTP 端口 | 40241 | 是 |
| PANEL_APP_PORT_API | API 端口 | 40242 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/config | 是 |
| CORE_PATH | 核心路径 | ./data/core | 是 |
| DOCKER_SOCK_PATH | Docker套接字路径 | /var/run/docker.sock | 是 |
| MEDIA_PATH | 媒体路径 | ./data/media | 是 |
| DOWNLOAD_PATH | 下载保存目录 (容器内) | /media/downloads | 是 |
| DOWNLOAD_MOVIE_PATH | 电影下载目录 (容器内) | /media/downloads/movies | 是 |
| DOWNLOAD_TV_PATH | 电视剧下载目录 (容器内) | /media/downloads/tv | 是 |
| DOWNLOAD_ANIME_PATH | 动漫下载目录 (容器内) | /media/downloads/anime | 是 |
| DOWNLOAD_SUBTITLE | 下载字幕 | false | 是 |
| DOWNLOAD_CATEGORY | 下载二级分类 | false | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HOSTNAME | 主机名 | moviepilot | 是 |
| USER_ID | 用户 ID | 0 | 是 |
| GROUP_ID | 用户组 ID | 0 | 是 |
| MOVIEPILOT_AUTO_UPDATE | MoviePilot 自动更新 | release | 是 |
| SUPERUSER | 超级管理员用户名 | admin | 是 |
| SUPERUSER_PASSWORD | 超级管理员密码 | password | 是 |
| WALLPAPER | 登录首页电影海报 | tmdb | 是 |
| API_TOKEN | API 密钥 | roduqib1o8ldrl8uyax7 | 是 |
| PROXY_HOST | 网络代理 | - | 否 |
| TMDB_API_DOMAIN | TMDB API 地址 | api.themoviedb.org | 是 |

## 使用说明
安装完成后通过容器日志获取登录密码
- 类似：

```
【超级管理员初始密码】uUxB2LPPi07X612g
```

## 参考资料
- 官网: <https://github.com/jxxghp/MoviePilot>
