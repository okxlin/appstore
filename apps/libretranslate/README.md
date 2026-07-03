# LibreTranslate

## 产品介绍
LibreTranslate 是一个开源自托管机器翻译 API，可在本地部署多语言翻译服务，而不依赖商业翻译平台。

## 主要功能
- 自托管机器翻译 API
- 可选 API Key 管理
- 可缓存翻译模型，减少重复下载

## 访问说明
安装完成后访问：

```text
http://服务器IP:端口
http://服务器IP:端口/docs
```

其中 `/docs` 可查看接口文档。首次调用某些语言模型时可能需要额外下载模型文件。

## 数据持久化
- Docker named volume：持久化 `/app/db`，可用于 API Key 数据库
- Docker named volume：持久化 `/home/libretranslate/.local`，缓存下载的翻译模型

为兼容官方镜像使用 `UID/GID 1032` 的非 root 用户运行，本适配保持上游的 named volume 语义，避免 bind mount 权限问题。

## Introduction
LibreTranslate is an open-source self-hosted machine translation API that lets you run multilingual translation locally without relying on commercial translation platforms.

## Features
- Self-hosted machine translation API
- Optional API key management
- Persistent model cache to avoid repeated downloads

## 参考资料
- 官网: <https://libretranslate.com/>
- 文档: <https://docs.libretranslate.com/>
- 源码: <https://github.com/LibreTranslate/LibreTranslate>
