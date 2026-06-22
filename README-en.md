[中文](https://github.com/okxlin/appstore/blob/localApps/README.md) | English

# 1Panel Third-Party App Store

Docker app configurations adapted for the `1Panel` app store `2.0`. After import, apps can be installed from the 1Panel local app store or run directly with `docker-compose` from each app version directory.

## Support

[**Support via AFDIAN**](https://afdian.com/a/dockerapps)

[![Support via AFDIAN](https://github.com/okxlin/appstore/raw/localApps/docs/afdian-logo.png)](https://afdian.com/a/dockerapps)

**WeChat Reward Code**

<img src="docs/wechat-reward.webp" alt="WeChat reward code" width="240">

***

## Table of Contents

- [Support](#support)
- [Table of Contents](#table-of-contents)
- [Disclaimer](#disclaimer)
  - [1. Image Container Adaptation](#1-image-container-adaptation)
  - [2. Compliance with Laws](#2-compliance-with-laws)
  - [3. Acceptance of Disclaimer](#3-acceptance-of-disclaimer)
- [1. Introduction](#1-introduction)
- [2. Contributing Apps](#2-contributing-apps)
- [3. Usage](#3-usage)
  - [3.1 GitHub Network Notes](#31-github-network-notes)
  - [3.2 Getting Apps via Git Command](#32-getting-apps-via-git-command)
  - [3.3 Getting Apps via Compressed Package](#33-getting-apps-via-compressed-package)
- [4. Remarks](#4-remarks)
- [5. App Overview](#5-app-overview)


***

## Disclaimer

### 1. Image Container Adaptation
This project specifically adapts to the `1Panel` app store for original `docker` image container operations. We do not make any explicit or implicit warranties or statements regarding the validity of any original images, and we are not responsible for any effects caused by using applications from this repository. Users undertake the risks associated with using this project on their own.

### 2. Compliance with Laws
When using this repository, users must comply with the laws and regulations of their respective countries and regions. Certain applications may be restricted by specific national laws, and users need to understand and comply with relevant legal requirements. This repository is not responsible for any consequences arising from the user's violation of laws and regulations.

### 3. Acceptance of Disclaimer
By importing and using the applications in this repository, the user signifies that they have read, understood, and accepted all the terms and conditions of this disclaimer.

Please note that this disclaimer applies only to the use of this repository and does not encompass other third-party applications or services. We are not responsible for the accuracy, completeness, reliability, or legality of third-party content linked to this repository.

Before using this repository, please ensure that you have read, understood, and accepted all the terms and conditions of this disclaimer.

***
## 1. Introduction
These are some configurations of docker applications adapted for the `1Panel` store version 2.0.

This repository keeps app directories, metadata, form variables, and compose files recognizable by 1Panel so users can avoid repeated manual deployment work.

## 2. Contributing Apps

> [!IMPORTANT]
> Before submitting an app PR, third-party developers are encouraged to generate or validate the app package with [okxlin/1panel-app-adapter](https://github.com/okxlin/1panel-app-adapter). It checks the 1Panel v2 directory layout, `data.yml`, `docker-compose.yml`, environment variable closure, i18n labels, and common release issues.

When opening a PR, include reproducible upstream sources, image sources, default ports, data directories, required dependencies, and test results. Commit only the final app directory to this repository; temporary test output and process files are not needed.

## 3. Usage

The default installation path of `1Panel` is `/opt/`, which can be modified as needed.

### 3.1 GitHub Network Notes

GitHub proxy mirrors change often, so this README no longer maintains a fixed acceleration domain list. If your network cannot reach GitHub, use a trusted proxy, a self-hosted `gh-proxy`, or another acceleration method, and verify that the proxy does not modify repository content.

The examples below use official GitHub URLs. Replace them according to your proxy rules if needed.

### 3.2 Getting Apps via Git Command

In the `Shell Script` task type in the `1Panel` scheduled tasks, add and execute the following command, or run it in a terminal:

```shell
git clone -b localApps https://github.com/okxlin/appstore /opt/1panel/resource/apps/local/appstore-localApps

cp -rf /opt/1panel/resource/apps/local/appstore-localApps/apps/* /opt/1panel/resource/apps/local/

rm -rf /opt/1panel/resource/apps/local/appstore-localApps
```

Then refresh the local applications in the app store.

### 3.3 Getting Apps via Compressed Package

In the `Shell Script` task type in the `1Panel` scheduled tasks, add and execute the following command, or run it in a terminal:

```shell
wget -P /opt/1panel/resource/apps/local https://github.com/okxlin/appstore/archive/refs/heads/localApps.zip

unzip -o -d /opt/1panel/resource/apps/local/ /opt/1panel/resource/apps/local/localApps.zip

cp -rf /opt/1panel/resource/apps/local/appstore-localApps/apps/* /opt/1panel/resource/apps/local/

rm -rf /opt/1panel/resource/apps/local/appstore-localApps

rm -rf /opt/1panel/resource/apps/local/localApps.zip
```

Then refresh the local applications in the app store.

## 4. Remarks

**If an application is not displayed in the local app list, it means it has not been fully adapted for operation in the app store panel.**

**However, it can still be run directly in the terminal.**

> Most applications in this repository support running directly with `docker-compose up`

Taking `rustdesk` as an example:

```shell
# Enter the latest version directory of rustdesk
cd /opt/1panel/resource/apps/local/rustdesk/versions/latest/

# Copy .env.sample as .env
cp .env.sample .env

# Edit the .env file and modify the parameters
nano .env

# Start RustDesk
docker-compose up -d

# View the necessary key for connecting
cat ./data/hbbs/id_ed25519.pub

```

## 5. App Overview

![](https://github.com/okxlin/appstore/raw/localApps/docs/app-list.png)
