# Firecrawl

## 产品介绍

Firecrawl 是一个开源网页数据 API，可将网页抓取、搜索和内容提取能力部署到自己的服务器。

## 主要功能

- 抓取网页并输出适合 AI 使用的内容。
- 提供网页搜索、爬取和内容提取 API。
- 使用 Playwright 处理需要浏览器渲染的页面。
- 使用 PostgreSQL、Redis 和 RabbitMQ 管理任务状态与队列。

## 访问说明

- 安装完成后，通过 `http://服务器IP:端口` 访问 API，默认端口为 `3002`。
- 默认配置关闭 Firecrawl 的数据库认证。请仅在受信任的内网使用；如果需要公网访问，请先在 1Panel 反向代理或其他 API 网关配置认证和 TLS。仅修改 `USE_DB_AUTHENTICATION` 并不能完成认证配置。
- API 客户端可按 Firecrawl 文档使用 `Authorization: Bearer <API_KEY>` 请求头。
- PostgreSQL、Redis 和 RabbitMQ 数据保存在应用目录的 `data/postgres`、`data/redis` 和 `data/rabbitmq`，可直接纳入 1Panel 备份。卸载应用时请保留这些目录。
- 首次启动会初始化 PostgreSQL 表结构，API 完全就绪可能需要几分钟。
- OpenAI/Ollama 相关字段是可选配置；未填写时，基础抓取功能仍可使用。其他云端集成、代理、搜索引擎和 Webhook 变量未纳入此基础包的安装表单。
- Firecrawl 上游采用 AGPL-3.0 许可证；如果修改程序并对外提供服务，请按许可证履行相应的源码提供义务。

## 安全与部署风险

- API 默认未启用认证，不能直接暴露到不受信任的公网。
- Playwright 容器使用 `no-new-privileges`、丢弃全部 Linux capabilities 和临时缓存目录；不要为了调试而移除这些限制。
- 依赖服务只加入内部网络，没有发布 PostgreSQL、Redis 或 RabbitMQ 端口。

## 相关链接

- [官方网站](https://firecrawl.dev)
- [自托管文档](https://github.com/firecrawl/firecrawl/blob/v2.11.359/SELF_HOST.md)
- [上游源码](https://github.com/firecrawl/firecrawl)

<details>
<summary>默认图标许可（MIT）</summary>

Copyright (c) 2026 okxlin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

</details>
