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
维护侧已对当前 `latest` / `0.4.0` 对应的上游镜像 `ghcr.io/basketikun/infinite-canvas:v0.4.0` 做过 Trivy 扫描，报告为 `Critical=3`、`High=17`、`Total=178`。其中 Critical 主要来自 Debian 基础层 `perl-base`、`zlib1g`，当前没有可直接应用的上游修复版本。

在 `--ignore-unfixed` 视角下，Critical 会消失，但仍有 `High=9`，主要集中在 `next 16.2.3`、`picomatch 4.0.3`、`sigstore 3.1.0`，需要上游更新依赖并重新构建镜像后才能消除。

因此当前版本更适合部署在可信内网或受控环境中，并应尽快跟进上游镜像更新。若对暴露面更敏感，建议在网关或反向代理层额外限制访问来源。

## Introduction
Infinite Canvas is an open-source infinite canvas for AI creation. It supports text-to-image, image-to-image, reference image editing, text chat, audio generation, and video generation workflows.

## Features
- Infinite canvas workspace
- OpenAI-compatible endpoint configuration
- Text-to-image, image-to-image, reference image editing, and text chat
- Audio and video generation workflows
- Browser-local storage for canvases, assets, generation history, and AI API keys

## Security Note
The current upstream image used by `latest` and `0.4.0` was scanned with Trivy and the report contains `Critical=3`, `High=17`, and `Total=178` findings. The Critical items are mainly in the Debian base layer (`perl-base`, `zlib1g`) and currently have no upstream fixed package available.

With `--ignore-unfixed`, the Critical findings drop out, but `High=9` remains, mainly in `next 16.2.3`, `picomatch 4.0.3`, and `sigstore 3.1.0`. Those require an upstream dependency refresh and image rebuild.

Deploy this app in a trusted network or otherwise controlled environment, and update promptly when the upstream image is refreshed.

## 参考资料
- 源码: <https://github.com/basketikun/infinite-canvas>
- Docker 部署文档: <https://github.com/basketikun/infinite-canvas/blob/main/docs/content/docs/overview/docker.mdx>
