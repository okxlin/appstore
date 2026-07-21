## 产品介绍

**BokeBox** 是一个私人 AI 播客工作室，可将视频、链接、文稿、会议与课程材料转化为可收听的节目。首次访问会引导创建管理员账号并配置模型服务，不提供默认密码。

## 主要功能

- **多源内容**：支持导入视频、链接、文稿及插件扩展的内容源。
- **自然口播**：使用 AI 理解素材并改写为有结构的口播稿。
- **自定义节目**：可设置主播人设、音色、语气与节目风格。
- **收听与沉淀**：提供专辑、封面、节目笔记、知识闪卡与收听进度。
- **开放扩展**：内置 MCP，并支持 Source、ASR 和 TTS 外部插件。
- **私有部署**：账号、设置、任务与媒体文件持久化在本地。

## 访问说明

- 安装完成后，通过应用详情中的 Web 端口访问 BokeBox。
- 首次访问会进入初始化向导，请创建管理员账号并配置所需的模型、ASR 和 TTS 服务。
- 应用不提供默认账号或默认密码，请妥善保存自行设置的管理员凭据。

## 数据与升级

- 应用数据保存在安装目录的 `data` 子目录，包括 SQLite 数据库、设置、任务和媒体文件。
- 升级或重建容器前建议先通过 1Panel 备份应用数据。

## 安全说明

- 本应用会保存第三方模型服务的 API Key，仅应部署在可信网络中，并建议通过反向代理启用 HTTPS。
- 当前上游 `/api/health` 在尚未配置可用 TTS 服务时会返回 500，因此应用包禁用了镜像内置健康检查；这不影响首次初始化页面和 Web 服务访问。
- 镜像已从最终运行文件系统移除 `npm`，但 Trivy 仍可能从镜像历史层报告其已删除工具链中的漏洞。该工具链不在运行路径中，后续仍应关注上游镜像更新。

## Introduction

BokeBox is a private AI podcast studio that turns videos, links, documents, meetings, and course materials into listenable shows. The first-run wizard creates the administrator account and configures model services; there is no default password.

## Features

- Import videos, links, documents, and plugin-provided content sources.
- Rewrite source material into structured spoken scripts with AI.
- Configure host personas, voices, delivery, and show styles.
- Manage albums, show notes, knowledge flashcards, and listening progress.
- Extend the service through MCP and external Source, ASR, and TTS plugins.

## Links

- Website: https://bokebox.aiuo.net
- Project: https://github.com/vastsa/BokeBox
- Image: https://github.com/vastsa/BokeBox/pkgs/container/bokebox
