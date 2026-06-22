中文 | [English](https://github.com/okxlin/appstore/blob/localApps/README-en.md)

# 1Panel 第三方应用商店

适配 `1Panel` 应用商店 `2.0` 的 Docker 应用配置合集。导入后可在 1Panel 本地应用商店中安装，也可以进入应用版本目录后用 `docker-compose` 直接运行。

## 支持项目

[**爱发电赞助：用爱发电**](https://afdian.com/a/dockerapps)

[![爱发电赞助：用爱发电](https://github.com/okxlin/appstore/raw/localApps/docs/afdian-logo.png)](https://afdian.com/a/dockerapps)

**微信赞赏**

<img src="docs/wechat-reward.webp" alt="微信赞赏码" width="240">

***
## 目录

- [支持项目](#支持项目)
- [目录](#目录)
- [免责声明](#免责声明)
  - [1. 镜像容器适配](#1-镜像容器适配)
  - [2. 法律遵守](#2-法律遵守)
  - [3. 免责声明接受](#3-免责声明接受)
- [1. 简介](#1-简介)
- [2. 贡献应用](#2-贡献应用)
- [3. 使用方式](#3-使用方式)
  - [3.1 GitHub 网络说明](#31-github-网络说明)
  - [3.2 使用 git 命令获取应用](#32-使用-git-命令获取应用)
  - [3.3 使用压缩包方式获取应用](#33-使用压缩包方式获取应用)
- [4. 备注](#4-备注)
- [5. 应用一览图](#5-应用一览图)


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
这是一些适配 `1Panel` 应用商店 `2.0` 的 Docker 应用配置。

本仓库尽量保持应用目录、元数据、表单变量和 compose 配置可被 1Panel 直接识别，降低手动部署和重复配置成本。

## 2. 贡献应用

> [!IMPORTANT]
> 第三方开发者提交应用 PR 前，建议先使用 [okxlin/1panel-app-adapter](https://github.com/okxlin/1panel-app-adapter) 生成或校验应用包。它会检查 1Panel v2 目录结构、`data.yml`、`docker-compose.yml`、环境变量闭包、i18n 标签和常见发布问题，能减少返工。

提交 PR 时请优先提供可复现的官方来源、镜像来源、默认端口、数据目录、前置依赖和测试结果。仓库只需要最终应用目录，不需要提交临时测试产物或过程文件。

## 3. 使用方式

默认 `1Panel` 安装在 `/opt/` 路径下。如果你的 1Panel 安装目录不同，请按实际路径调整下面命令。

### 3.1 GitHub 网络说明

GitHub 代理镜像的可用性变化很快，本 README 不再维护固定加速域名。网络受限时，可以使用可信代理、自建 `gh-proxy` 或其他加速方式，并自行确认代理没有改写仓库内容。

下面示例使用 GitHub 官方地址。如需加速，请按你使用的代理规则替换 URL。

### 3.2 使用 git 命令获取应用

`1Panel`计划任务类型`Shell 脚本`的计划任务框里，添加并执行以下命令，或者终端运行以下命令，
```shell
git clone -b localApps https://github.com/okxlin/appstore /opt/1panel/resource/apps/local/appstore-localApps

cp -rf /opt/1panel/resource/apps/local/appstore-localApps/apps/* /opt/1panel/resource/apps/local/

rm -rf /opt/1panel/resource/apps/local/appstore-localApps
```

然后应用商店刷新本地应用即可。

### 3.3 使用压缩包方式获取应用

`1Panel`计划任务类型`Shell 脚本`的计划任务框里，添加并执行以下命令，或者终端运行以下命令，
```shell
wget -P /opt/1panel/resource/apps/local https://github.com/okxlin/appstore/archive/refs/heads/localApps.zip

unzip -o -d /opt/1panel/resource/apps/local/ /opt/1panel/resource/apps/local/localApps.zip

cp -rf /opt/1panel/resource/apps/local/appstore-localApps/apps/* /opt/1panel/resource/apps/local/

rm -rf /opt/1panel/resource/apps/local/appstore-localApps

rm -rf /opt/1panel/resource/apps/local/localApps.zip
```

然后应用商店刷新本地应用即可。


## 4. 备注

**未显示在本地应用列表里的，表示未完全适配应用商店面板操作**

**但是支持直接终端运行。**

> 本仓库应用基本支持直接 `docker-compose up` 运行

以`rustdesk`为例

```shell
# 进入 rustdesk 的最新版本目录
cd /opt/1panel/resource/apps/local/rustdesk/versions/latest/

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
