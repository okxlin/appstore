# 使用说明

- 默认账户密码

```
username：root
password：123456
```

# One API

**One API** 是一个通过标准的 OpenAI API 格式访问所有的大模型，开箱即用。

## 主要功能:

- 支持多种大模型：
    + [x] [OpenAI ChatGPT 系列模型](https://platform.openai.com/docs/guides/gpt/chat-completions-api)（支持 [Azure OpenAI API](https://learn.microsoft.com/en-us/azure/ai-services/openai/reference)）
    + [x] [Anthropic Claude 系列模型](https://anthropic.com)
    + [x] [Google PaLM2/Gemini 系列模型](https://developers.generativeai.google)
    + [x] [百度文心一言系列模型](https://cloud.baidu.com/doc/WENXINWORKSHOP/index.html)
    + [x] [阿里通义千问系列模型](https://help.aliyun.com/document_detail/2400395.html)
    + [x] [讯飞星火认知大模型](https://www.xfyun.cn/doc/spark/Web.html)
    + [x] [智谱 ChatGLM 系列模型](https://bigmodel.cn)
    + [x] [360 智脑](https://ai.360.cn)
    + [x] [腾讯混元大模型](https://cloud.tencent.com/document/product/1729)
- 支持配置镜像以及众多第三方代理服务。
- 支持通过**负载均衡**的方式访问多个渠道。
- 支持 **stream 模式**，可以通过流式传输实现打字机效果。
- 支持**多机部署**。
- 支持**令牌管理**，设置令牌的过期时间和额度。
- 支持**兑换码管理**，支持批量生成和导出兑换码，可使用兑换码为账户进行充值。
- 支持**通道管理**，批量创建通道。
- 支持**用户分组**以及**渠道分组**，支持为不同分组设置不同的倍率。
- 支持渠道**设置模型列表**。
- 支持**查看额度明细**。
- 支持**用户邀请奖励**。
- 支持以美元为单位显示额度。
- 支持发布公告，设置充值链接，设置新用户初始额度。
- 支持模型映射，重定向用户的请求模型，如无必要请不要设置，设置之后会导致请求体被重新构造而非直接透传，会导致部分还未正式支持的字段无法传递成功。
- 支持失败自动重试。
- 支持绘图接口。
- 支持 [Cloudflare AI Gateway](https://developers.cloudflare.com/ai-gateway/providers/openai/)，渠道设置的代理部分填写 `https://gateway.ai.cloudflare.com/v1/ACCOUNT_TAG/GATEWAY/openai` 即可。
- 持丰富的**自定义**设置，
    1. 支持自定义系统名称，logo 以及页脚。
    2. 支持自定义首页和关于页面，可以选择使用 HTML & Markdown 代码进行自定义，或者使用一个单独的网页通过 iframe 嵌入。
- 支持通过系统访问令牌访问管理 API（bearer token，用以替代 cookie，你可以自行抓包来查看 API 的用法）。
- 支持 Cloudflare Turnstile 用户校验。
- 支持用户管理，支持**多种用户登录注册方式**：
   + 邮箱登录注册（支持注册邮箱白名单）以及通过邮箱进行密码重置。
   + [GitHub 开放授权](https://github.com/settings/applications/new)。
   + 微信公众号授权（需要额外部署 [WeChat Server](https://github.com/songquanpeng/wechat-server)）。