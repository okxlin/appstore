# Infinite Canvas

## 产品介绍
Infinite Canvas 是一个开源 AI 创作无限画布，支持文生图、图生图、参考图编辑、文本问答、音频和视频生成等创作流程。

## 主要功能
- 无限画布式创作空间
- OpenAI 兼容接口配置
- 文生图、图生图、参考图编辑和文本问答
- 音频、视频生成工作流
- 浏览器本地保存画布、素材、生成记录和 AI API Key

## 访问说明
安装完成后，访问：

```text
http://服务器IP:端口
```

首次打开后进入右上角配置，填入自己的 OpenAI 兼容 `Base URL` 和 `API Key`。

如果使用 New API，可在 New API 的聊天设置中配置跳转地址：

```text
http://服务器IP:端口?apiKey={key}&baseUrl={address}
```

当前主应用镜像只启动 Next.js。画布、素材、生成记录和 AI API Key 默认保存在浏览器本地；第三方提示词由 Next.js 路由拉取后缓存在运行实例内存里，不需要额外挂载数据目录。

## 安全提示
维护侧最近一次对当前打包镜像的 Trivy 扫描发现 `Critical=2`、`High=35`。Critical 项来自 Alpine OpenSSL 包，漏洞描述主要涉及 32 位系统；本应用声明的架构为 amd64 和 arm64，但基础镜像仍应升级到包含修复的 OpenSSL 版本。

本次扫描中的 Critical 和 High 项均已有修复版本，主要涉及 OpenSSL、c-ares、libexpat 等基础包，需要上游重新构建镜像后才能消除。

当前应用不使用特权模式、host network 或 Docker Socket，但仍建议部署在可信内网或受控环境中，并通过网关或反向代理限制访问来源。

## Introduction
Infinite Canvas is an open-source infinite canvas for AI creation. It supports text-to-image, image-to-image, reference image editing, text chat, audio generation, and video generation workflows.

## Features
- Infinite canvas workspace
- OpenAI-compatible endpoint configuration
- Text-to-image, image-to-image, reference image editing, and text chat
- Audio and video generation workflows
- Browser-local storage for canvases, assets, generation history, and AI API keys

## Security Note
The latest maintainer Trivy scan of the packaged image reports `Critical=2` and `High=35`. The Critical entries come from Alpine OpenSSL packages and primarily describe a 32-bit platform scenario. This app targets amd64 and arm64, but the base image should still be rebuilt with fixed OpenSSL packages.

All Critical and High findings in this scan have fixed versions available. They mainly affect OpenSSL, c-ares, libexpat, and other base packages that require an upstream image rebuild.

The app does not request privileged mode, host networking, or the Docker socket. Even so, deploy it in a trusted or otherwise controlled environment and restrict access through a gateway or reverse proxy where appropriate.

## 参考资料
- 源码: <https://github.com/basketikun/infinite-canvas>
- Docker 部署文档: <https://github.com/basketikun/infinite-canvas/blob/main/docs/content/docs/overview/docker.mdx>
