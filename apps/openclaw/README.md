## 产品介绍

**OpenClaw** 是一个运行在你自己设备上的 **个人 AI 助理**。它可以在你已经使用的各种沟通渠道中与你对话，包括：飞书、钉钉、企业微信、QQ、WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、Microsoft Teams、WebChat等。

如果你想要一个可以在本地 7x24 运行的个人 AI 助理，那就是它了。

## 核心特性

- **Local-first Gateway** — 本地优先的网关架构，统一管理会话、渠道、工具和事件的单一控制平面。
- **多渠道收件箱** — 原生支持 WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、BlueBubbles、Microsoft Teams、Matrix、Zalo、Zalo Personal、WebChat，以及 macOS、iOS / Android。
- **多 Agent 路由** — 可将不同的接入渠道 / 账号 / 对象路由到相互隔离的 Agent，实现工作区级别和 Agent 级别的会话隔离。
- **语音唤醒与对话模式** — 在 macOS / iOS / Android 上提供始终在线的语音交互能力，集成 ElevenLabs。
- **实时 Canvas** — 基于 A2UI 的可视化工作区，由 Agent 驱动，支持实时渲染和交互。
- **一等公民级工具系统** — 内置浏览器、Canvas、节点（Nodes）、定时任务（Cron）、会话管理，以及 Discord / Slack 行为操作。
- **配套客户端应用** — 提供 macOS 菜单栏应用，以及 iOS / Android 节点应用。
- 引导式上手与技能系统 — 通过向导完成初始化，内置并支持托管 / 工作区级技能（Skills）管理。

## 部署后指南

部署完成后，为了确保 OpenClaw 的正常运行和外部访问，请按照以下步骤进行配置：

1. **更新配置文件**：
   找到并编辑应用挂载的数据目录下的 `./data/conf/openclaw.json`。将 `"allowedOrigins"` 部分更新为您实际使用的反向代理 URL 地址，以允许相应的跨域请求。

2. **访问注册设备**：
   在浏览器地址栏的 URL 后面追加您的 token，格式如：`http://your_address:port?token=xxx`，使用此带有 token 的链接访问以注册您的设备。

3. **审批设备请求**：
   设备注册后，需要连接到容器的终端环境，执行以下命令检查并批准配对请求：
   
   查看待处理的配对请求：
   ```bash
   openclaw devices list
   ```
   
   如果您看到待处理的请求，请使用获取到的 `<request id>` 来批准它：
   ```bash
   openclaw devices approve <request id>
   ```
