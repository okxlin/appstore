# Koodo Reader

## 应用简介
一个跨平台的电子书阅读器。

英文说明：A cross-platform ebook reader.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：媒体。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40146 | 是 |

## 使用说明
### 使用方法

- 桌面端：
  - 稳定版 (推荐下载)：[官网](https://koodo.960960.xyz/zh)（感谢 [@Stille](https://www.ioiox.com/donate.html) 提供下载加速服务）
  - 开发版：[Github Release](https://github.com/troyeguo/koodo-reader/releases/latest) （包含新功能和 bug 修复，但也可能引入更多未知 bug）
- 网页版：[前往](https://reader.960960.xyz)
- 使用 Scoop 安装：

```shell
scoop bucket add extras
scoop install dorado/koodo-reader
```

- 使用 Winget 安装：

```shell
winget install -e AppbyTroye.KoodoReader
```

- 使用 Homebrew 安装：

```shell
brew install --cask koodo-reader
```

- 使用 Docker 安装：

```bash
docker-compose up -d
```

- 使用 Flathub 安装：

```shell
flatpak install flathub io.github.troyeguo.koodo-reader
flatpak run io.github.troyeguo.koodo-reader
```

## 参考资料
- 官网: <https://koodo.960960.xyz>
- 文档: <https://troyeguo.notion.site/Koodo-Reader-0c9c7ccdc5104a54825dfc72f1c84bea>
- 源码: <https://github.com/troyeguo/koodo-reader>
