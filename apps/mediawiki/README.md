# MediaWiki

## 应用简介
开源百科引擎。

英文说明：Open-source wiki engine.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`latest`、`1.45.3`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40315 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MEDIAWIKI_IMAGES_PATH | MediaWiki 图片路径 | ./data/images | 是 |
| MEDIAWIKI_DATA_PATH | MediaWiki 数据路径 | ./data/data | 是 |
| INTERNAL_DATA_PATH | 容器内部数据路径 | /var/www/data | 是 |
| LOCAL_SETTINGS_PATH | LocalSettings.php 路径 (【必要】编辑 compose.yml 关闭映射可重新生成配置文件) | ./data/LocalSettings.php | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 1. 数据库连接信息及更多的设置通过`LocalSettings.php`文件进行设置，

- 2. 通过取消`LocalSettings.php`文件的映射来重新初始化，并获取配置文件。**【必要】**

- 3. 然后修改并重新映射`LocalSettings.php`文件到容器内来使新设置生效。

- 4. 需要将配置文件正确放置，文件路径大概如下：`/opt/1panel/apps/local/mediawiki/mediawiki/data/LocalSettings.php`，按需修改。

- 5. **具体：安装应用/修改应用参数时，点击`高级设置`>`编辑 compose 文件`，通过修改对`LocalSettings.php`文件的映射与否，获取新配置文件/启用配置文件。**

- 6. 在`高级设置`>`编辑 compose 文件`时，可通过按需修改编排的以下部分，然后确认重建应用生效，此步骤即是修改配置文件的映射。

```
    volumes:
      - ${MEDIAWIKI_IMAGES_PATH}:/var/www/html/images
      - ${MEDIAWIKI_DATA_PATH}:${INTERNAL_DATA_PATH}
      # 删除以下行前的#号表示启用
      #- ${LOCAL_SETTINGS_PATH}:/var/www/html/LocalSettings.php  # 映射到容器内的配置文件
```

## 参考资料
- 官网: <https://www.mediawiki.org>
- 文档: <https://www.mediawiki.org/wiki/Manual:Installation_guide>
- 源码: <https://github.com/wikimedia/mediawiki>
