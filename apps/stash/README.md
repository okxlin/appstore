# Stash

## 应用简介
媒体管理工具。

英文说明：Media Management Tools.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64。
- 可选版本：`latest`、`0.31.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40299 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| CONFIG_PATH | 配置路径 | ./data/config | 是 |
| STASH_DATA | 媒体数据路径 | ./data/data | 是 |
| STASH_METADATA | 元数据路径 | ./data/metadata | 是 |
| STASH_CACHE | 缓存路径 | ./data/cache | 是 |
| STASH_BLOBS | 二进制数据路径 (场景封面、图像） | ./data/blobs | 是 |
| STASH_GENERATED | 生成内容路径 | ./data/generated | 是 |
| STASH_DATA_INTERNAL | 容器内部媒体数据路径 | /data | 是 |
| STASH_METADATA_INTERNAL | 容器内部元数据路径 | /metadata | 是 |
| STASH_CACHE_INTERNAL | 容器内部缓存路径 | /cache | 是 |
| STASH_BLOBS_INTERNAL | 容器内部二进制数据路径 (场景封面、图像） | /blobs | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
假如需要公网访问，可以修改配置文件的以下项为`true`

```
dangerous_allow_public_without_auth: "true"
```

且以下值为空

```
security_tripwire_accessed_from_public_internet: ""
```

## 参考资料
- 官网: <https://stashapp.cc>
- 文档: <https://docs.stashapp.cc>
- 源码: <https://github.com/stashapp/stash>
