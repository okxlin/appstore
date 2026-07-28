<h1 align="center">1Panel 第三方应用商店</h1>

<p align="center">
  适配 <code>1Panel</code> 应用商店 <code>2.0</code> 的 Docker 应用配置合集。导入后可在 1Panel 本地应用商店中安装，也可以进入应用版本目录后用 <code>docker-compose</code> 直接运行。
</p>

<p align="center">
  <img src="docs/afdian-logo.png" alt="Docker Apps 项目标识" width="640">
</p>

<p align="center">
  <a href="README.md"><img src="https://img.shields.io/badge/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-2875B6?style=flat-square" alt="简体中文（当前语言）"></a>
  <a href="README-en.md"><img src="https://img.shields.io/badge/English-D9D9D9?style=flat-square" alt="Read in English"></a>
</p>

## 支持项目

<p align="center">
  <a href="https://afdian.com/a/dockerapps"><strong>爱发电赞助：用爱发电</strong></a><br><br>
  <strong>微信赞赏</strong><br>
  <img src="docs/wechat-reward.webp" alt="微信赞赏码" width="200">
</p>

<details>
<summary><strong>目录</strong></summary>

- [免责声明](#免责声明)
  - [1. 镜像容器适配](#1-镜像容器适配)
  - [2. 法律遵守](#2-法律遵守)
  - [3. 免责声明接受](#3-免责声明接受)
- [1. 简介](#1-简介)
- [2. 贡献应用](#2-贡献应用)
- [已下架应用](#已下架应用)
- [3. 使用方式](#3-使用方式)
  - [3.1 GitHub 网络说明](#31-github-网络说明)
  - [3.2 使用 git 命令获取应用](#32-使用-git-命令获取应用)
  - [3.3 使用压缩包方式获取应用](#33-使用压缩包方式获取应用)
- [4. 备注](#4-备注)
- [5. 应用一览图](#5-应用一览图)

</details>

***

## 免责声明

### 1. 镜像容器适配

本项目仅针对原`docker`镜像容器运行进行针对`1Panel`应用商店的适配。我们不对任何原始镜像的有效性做出任何明示或暗示的保证或声明，并且不对使用本仓库应用所造成的任何影响负责。用户在使用本项目时应自行承担风险。

### 2. 法律遵守

用户在使用本仓库时必须遵守所在国家与地区的法律法规。某些应用可能受到特定国家法律的限制，用户需自行了解并遵守相关法律要求。本仓库不对用户违反法律法规所产生的任何后果负责。

### 3. 免责声明接受

用户在导入本仓库并使用其中的应用时，即表示用户已经阅读、理解并同意接受本免责声明的所有条款和条件。

请注意，本免责声明仅针对本仓库的使用情况，并不包括其他第三方应用或服务。对于与本仓库链接的第三方内容，我们不对其准确性、完整性、可靠性或合法性负责。

在使用本仓库之前，请确保已经阅读、理解并接受了本免责声明的所有条款和条件。

***

## 1. 简介

本仓库按 1Panel v2 应用规范组织应用目录、元数据、表单变量和 Docker Compose 配置，尽量做到导入后即可安装，减少手动部署和重复配置。

## 2. 贡献应用

> [!IMPORTANT]
> 第三方开发者提交应用 PR 前，建议先使用 [okxlin/1panel-app-adapter](https://github.com/okxlin/1panel-app-adapter) 生成或校验应用包。它会检查 1Panel v2 目录结构、`data.yml`、`docker-compose.yml`、环境变量闭包、i18n 标签和常见发布问题，能减少返工。

提交 PR 时请优先提供可复现的官方来源、镜像来源、默认端口、数据目录、前置依赖和测试结果。仓库只需要最终应用目录，不需要提交临时测试产物或过程文件。

## 已下架应用

无法安装且没有可信替代镜像的应用会从活动目录移除，避免继续展示给新用户。下架原因和最后版本记录在 [`.github/retired-apps.yml`](.github/retired-apps.yml)，完整应用文件仍可从 Git 历史恢复。

## 3. 使用方式

下面的命令默认使用 `/opt` 作为 1Panel 安装根目录。执行前请按实际情况设置每段命令开头的 `PANEL_BASE_DIR`。

### 3.1 GitHub 网络说明

GitHub 代理镜像的可用性变化很快，本 README 不再维护固定加速域名。网络受限时，可以使用可信代理、自建 `gh-proxy` 或其他加速方式，并自行确认代理没有改写仓库内容。

下面示例使用 GitHub 官方地址。如需加速，请按你使用的代理规则替换 URL。

### 3.2 使用 git 命令获取应用

在 1Panel 中新建类型为 `Shell 脚本` 的计划任务，粘贴并执行以下命令；也可以直接在终端执行：

```bash
set -euo pipefail

PANEL_BASE_DIR="/opt" # 按实际的 1Panel 安装根目录修改

case "$PANEL_BASE_DIR" in
  /*) ;;
  *)
    echo "PANEL_BASE_DIR 必须是绝对路径" >&2
    exit 1
    ;;
esac

PANEL_BASE_DIR="$(realpath -m -- "$PANEL_BASE_DIR")"
if [ "$PANEL_BASE_DIR" = "/" ]; then
  echo "PANEL_BASE_DIR 不能是 /" >&2
  exit 1
fi

LOCAL_APPS_DIR="$PANEL_BASE_DIR/1panel/resource/apps/local"
IMPORT_DIR="$LOCAL_APPS_DIR/appstore-localApps"

if [ ! -d "$LOCAL_APPS_DIR" ]; then
  echo "本地应用目录不存在：$LOCAL_APPS_DIR" >&2
  exit 1
fi

git clone -b localApps https://github.com/okxlin/appstore "$IMPORT_DIR"

cp -a "$IMPORT_DIR/apps/." "$LOCAL_APPS_DIR/"

find "$IMPORT_DIR" -xdev -mindepth 1 -delete
rmdir "$IMPORT_DIR"
```

执行完成后，在应用商店中刷新本地应用。

### 3.3 使用压缩包方式获取应用

在 1Panel 中新建类型为 `Shell 脚本` 的计划任务，粘贴并执行以下命令；也可以直接在终端执行：

```bash
set -euo pipefail

PANEL_BASE_DIR="/opt" # 按实际的 1Panel 安装根目录修改

case "$PANEL_BASE_DIR" in
  /*) ;;
  *)
    echo "PANEL_BASE_DIR 必须是绝对路径" >&2
    exit 1
    ;;
esac

PANEL_BASE_DIR="$(realpath -m -- "$PANEL_BASE_DIR")"
if [ "$PANEL_BASE_DIR" = "/" ]; then
  echo "PANEL_BASE_DIR 不能是 /" >&2
  exit 1
fi

LOCAL_APPS_DIR="$PANEL_BASE_DIR/1panel/resource/apps/local"
IMPORT_DIR="$LOCAL_APPS_DIR/appstore-localApps"
ARCHIVE_PATH="$LOCAL_APPS_DIR/localApps.zip"

if [ ! -d "$LOCAL_APPS_DIR" ]; then
  echo "本地应用目录不存在：$LOCAL_APPS_DIR" >&2
  exit 1
fi

wget -O "$ARCHIVE_PATH" https://github.com/okxlin/appstore/archive/refs/heads/localApps.zip

unzip -o "$ARCHIVE_PATH" -d "$LOCAL_APPS_DIR"

cp -a "$IMPORT_DIR/apps/." "$LOCAL_APPS_DIR/"

find "$IMPORT_DIR" -xdev -mindepth 1 -delete
rmdir "$IMPORT_DIR"

unlink "$ARCHIVE_PATH"
```

执行完成后，在应用商店中刷新本地应用。

## 4. 备注

> [!NOTE]
> 未显示在本地应用列表中的应用，表示尚未完全适配面板操作，但通常仍可通过终端运行。

以 `rustdesk` 为例：

```bash
PANEL_BASE_DIR="/opt" # 按实际的 1Panel 安装根目录修改

# 进入 rustdesk 的最新版本目录
cd "$PANEL_BASE_DIR/1panel/resource/apps/local/rustdesk/versions/latest/" || exit 1

# 复制 .env.sample 为 .env
cp .env.sample .env

# 编辑 .env 文件，修改参数
nano .env

# 启动 RustDesk
docker-compose up -d

# 查看连接所需密钥
cat ./data/hbbs/id_ed25519.pub
```

## 5. 应用一览图

![](https://github.com/okxlin/appstore/raw/localApps/docs/app-list.png)
