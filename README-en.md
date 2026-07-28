<h1 align="center">1Panel Third-Party App Store</h1>

<p align="center">
  Docker app configurations adapted for the <code>1Panel</code> app store <code>2.0</code>. After import, apps can be installed from the 1Panel local app store or run directly with <code>docker-compose</code> from each app version directory.
</p>

<p align="center">
  <img src="docs/afdian-logo.png" alt="Docker Apps project banner" width="640">
</p>

<p align="center">
  <a href="README.md"><img src="https://img.shields.io/badge/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87-D9D9D9?style=flat-square" alt="阅读简体中文版"></a>
  <a href="README-en.md"><img src="https://img.shields.io/badge/English-2875B6?style=flat-square" alt="English (current language)"></a>
</p>

## Support

<p align="center">
  <a href="https://afdian.com/a/dockerapps"><strong>Support this project on AFDIAN</strong></a><br><br>
  <strong>WeChat Reward Code</strong><br>
  <img src="docs/wechat-reward.webp" alt="WeChat reward code" width="200">
</p>

<details>
<summary><strong>Table of Contents</strong></summary>

- [Disclaimer](#disclaimer)
  - [1. Image Container Adaptation](#1-image-container-adaptation)
  - [2. Compliance with Laws](#2-compliance-with-laws)
  - [3. Acceptance of Disclaimer](#3-acceptance-of-disclaimer)
- [1. Introduction](#1-introduction)
- [2. Contributing Apps](#2-contributing-apps)
- [Retired Apps](#retired-apps)
- [3. Usage](#3-usage)
  - [3.1 GitHub Network Notes](#31-github-network-notes)
  - [3.2 Getting Apps via Git Command](#32-getting-apps-via-git-command)
  - [3.3 Getting Apps via Compressed Package](#33-getting-apps-via-compressed-package)
- [4. Remarks](#4-remarks)
- [5. App Overview](#5-app-overview)

</details>

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

This repository organizes app directories, metadata, form variables, and Docker Compose files according to the 1Panel v2 app specification. The goal is to make apps installable after import with less manual deployment and repeated configuration.

## 2. Contributing Apps

> [!IMPORTANT]
> Before submitting an app PR, third-party developers are encouraged to generate or validate the app package with [okxlin/1panel-app-adapter](https://github.com/okxlin/1panel-app-adapter). It checks the 1Panel v2 directory layout, `data.yml`, `docker-compose.yml`, environment variable closure, i18n labels, and common release issues.

When opening a PR, include reproducible upstream sources, image sources, default ports, data directories, required dependencies, and test results. Commit only the final app directory to this repository; temporary test output and process files are not needed.

## Retired Apps

Apps that can no longer be installed and have no trustworthy replacement image are removed from the active catalog. Retirement reasons and last available versions are recorded in [`.github/retired-apps.yml`](.github/retired-apps.yml), while the complete app files remain recoverable from Git history.

## 3. Usage

The commands below use `/opt` as the default 1Panel installation base directory. Before running each command block, set `PANEL_BASE_DIR` to match your installation.

### 3.1 GitHub Network Notes

GitHub proxy mirrors change often, so this README no longer maintains a fixed acceleration domain list. If your network cannot reach GitHub, use a trusted proxy, a self-hosted `gh-proxy`, or another acceleration method, and verify that the proxy does not modify repository content.

The examples below use official GitHub URLs. Replace them according to your proxy rules if needed.

### 3.2 Getting Apps via Git Command

Create a `Shell Script` scheduled task in 1Panel and run the following commands, or execute them directly in a terminal:

```bash
set -euo pipefail

PANEL_BASE_DIR="/opt" # Change this to your 1Panel installation base directory

case "$PANEL_BASE_DIR" in
  /*) ;;
  *)
    echo "PANEL_BASE_DIR must be an absolute path" >&2
    exit 1
    ;;
esac

PANEL_BASE_DIR="$(realpath -m -- "$PANEL_BASE_DIR")"
if [ "$PANEL_BASE_DIR" = "/" ]; then
  echo "PANEL_BASE_DIR cannot be /" >&2
  exit 1
fi

LOCAL_APPS_DIR="$PANEL_BASE_DIR/1panel/resource/apps/local"
IMPORT_DIR="$LOCAL_APPS_DIR/appstore-localApps"

if [ ! -d "$LOCAL_APPS_DIR" ]; then
  echo "Local app directory does not exist: $LOCAL_APPS_DIR" >&2
  exit 1
fi

git clone -b localApps https://github.com/okxlin/appstore "$IMPORT_DIR"

cp -a "$IMPORT_DIR/apps/." "$LOCAL_APPS_DIR/"

find "$IMPORT_DIR" -xdev -mindepth 1 -delete
rmdir "$IMPORT_DIR"
```

When the commands finish, refresh the local apps in the app store.

### 3.3 Getting Apps via Compressed Package

Create a `Shell Script` scheduled task in 1Panel and run the following commands, or execute them directly in a terminal:

```bash
set -euo pipefail

PANEL_BASE_DIR="/opt" # Change this to your 1Panel installation base directory

case "$PANEL_BASE_DIR" in
  /*) ;;
  *)
    echo "PANEL_BASE_DIR must be an absolute path" >&2
    exit 1
    ;;
esac

PANEL_BASE_DIR="$(realpath -m -- "$PANEL_BASE_DIR")"
if [ "$PANEL_BASE_DIR" = "/" ]; then
  echo "PANEL_BASE_DIR cannot be /" >&2
  exit 1
fi

LOCAL_APPS_DIR="$PANEL_BASE_DIR/1panel/resource/apps/local"
IMPORT_DIR="$LOCAL_APPS_DIR/appstore-localApps"
ARCHIVE_PATH="$LOCAL_APPS_DIR/localApps.zip"

if [ ! -d "$LOCAL_APPS_DIR" ]; then
  echo "Local app directory does not exist: $LOCAL_APPS_DIR" >&2
  exit 1
fi

wget -O "$ARCHIVE_PATH" https://github.com/okxlin/appstore/archive/refs/heads/localApps.zip

unzip -o "$ARCHIVE_PATH" -d "$LOCAL_APPS_DIR"

cp -a "$IMPORT_DIR/apps/." "$LOCAL_APPS_DIR/"

find "$IMPORT_DIR" -xdev -mindepth 1 -delete
rmdir "$IMPORT_DIR"

unlink "$ARCHIVE_PATH"
```

When the commands finish, refresh the local apps in the app store.

## 4. Remarks

> [!NOTE]
> Apps that do not appear in the local app list have not been fully adapted for panel operations, but they can usually still be run from a terminal.

For example, to run `rustdesk`:

```bash
PANEL_BASE_DIR="/opt" # Change this to your 1Panel installation base directory

# Enter the latest version directory of rustdesk
cd "$PANEL_BASE_DIR/1panel/resource/apps/local/rustdesk/versions/latest/" || exit 1

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
