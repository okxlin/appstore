# 中文 DOS 游戏

## 应用简介
中文 DOS 游戏合集。

英文说明：Chinese DOS games collections.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：游戏。
- 支持架构：amd64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40078 | 是 |

## 使用说明
需要更多游戏的，从原仓库获取，然后将游戏放到存储卷`dosgame_data`的对应目录下

原仓库：[chinese-dos-games](https://github.com/rwv/chinese-dos-games)

## 参考资料
- 官网: <https://dos.lol/>
- 文档: <https://github.com/rwv/chinese-dos-games>
