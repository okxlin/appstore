# PDFMathTranslate

## 产品介绍

PDFMathTranslate 是一个面向科研和技术文档的 PDF 翻译工具，可在保留公式、图表、目录和原始排版的同时，生成单语或双语 PDF。

本应用使用 PDFMathTranslate 2.x 官方 Docker 镜像。默认翻译服务可直接使用，也可以在 WebUI 中配置 OpenAI、DeepSeek、SiliconFlow、Ollama 等翻译引擎。

## 主要功能

- 保留公式、图表、目录和文档排版。
- 生成单语 PDF、双语 PDF 和术语表结果。
- 支持多种云端及自托管翻译引擎。
- 通过 WebUI 上传、预览和下载翻译文件。

## 访问说明

- 默认 Web 端口：`40391`
- 容器内部端口：`7860`
- 安装表单会生成 Web 登录密码，访问页面时使用表单中的用户名和密码登录。
- 不需要 GPU；较大的 PDF 在分析和翻译过程中可能占用较多 CPU 与内存。
- 镜像体积约为 850–900 MB，首次拉取需要一定时间。

## 数据持久化

- 配置目录：`/root/.config/pdf2zh`
- 翻译缓存：`/root/.cache/pdf2zh_next`
- 翻译结果：`/app/pdf2zh_files`

配置目录中可能保存翻译服务 API Key。升级时会保留以上目录；卸载应用不会自动删除绑定目录中的用户数据。

## 网络与安全

- WebUI 可以上传包含敏感内容的 PDF，并可能保存付费翻译服务的 API Key，请保留登录验证。
- 对公网开放时，建议通过 1Panel 网站反向代理启用 HTTPS。
- `HF_ENDPOINT` 默认使用 Hugging Face 官方地址；网络受限环境可切换为可用镜像地址。

## 版本说明

- `2.9.0`：固定 PDFMathTranslate 版本，适合需要可重复部署的用户。
- `latest`：跟随官方最新镜像，可能包含 BabelDOC 模型和依赖更新。

项目采用 AGPL-3.0 许可证。

## Introduction

PDFMathTranslate translates scientific and technical PDF documents while preserving formulas, figures, tables of contents, and the original layout. It can produce monolingual and bilingual PDF output.

## Features

- Layout-preserving scientific PDF translation.
- Monolingual, bilingual, and glossary output.
- Multiple hosted and self-hosted translation engines.
- Authenticated WebUI for upload, preview, and download workflows.

## Links

- Project: https://github.com/PDFMathTranslate/PDFMathTranslate-next
- Documentation: https://pdf2zh-next.com/
- Docker image: https://hub.docker.com/r/awwaawwa/pdfmathtranslate-next
