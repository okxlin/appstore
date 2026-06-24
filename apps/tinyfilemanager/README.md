# TinyFileManager

## 应用简介
一个基于 PHP 的轻量级文件管理器。

英文说明：A lightweight file manager based on PHP.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：网站。
- 支持架构：amd64。
- 可选版本：`master`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40304 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data/data | 是 |
| INDEX_PHP_PATH | Index.php 路径 | ./data/index.php | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
默认用户密码: `admin/admin@123` 和 `user/12345`，

可以通过编辑`index.php`文件修改

## 参考资料
- 官网: <https://tinyfilemanager.github.io>
- 文档: <https://github.com/prasathmani/tinyfilemanager/wiki>
- 源码: <https://github.com/prasathmani/tinyfilemanager>
