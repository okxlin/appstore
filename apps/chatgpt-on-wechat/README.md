# ChatGPT on WeChat

## 应用简介
基于大模型的智能对话机器人。

英文说明：Intelligent Conversational Bots Based on Large Models.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`2.1.2`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| WECHATMP_PORT | 微信公众平台端口 | 8080 | 否 |
| WECHATCOMAPP_PORT | 企业微信 App 端口 | 9898 | 否 |
| FEISHU_PORT | 飞书 Bot 监听端口 | 80 | 否 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| APPDATA_DIR | 数据目录 | - | 否 |
| USE_GLOBAL_PLUGIN_CONFIG | 使用全局插件配置 | false | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| OPEN_AI_API_KEY | OpenAI API 密钥 | - | 否 |
| OPEN_AI_API_BASE | OpenAI API 基础地址 | https://api.openai.com/v1 | 否 |
| MODEL | 模型 | gpt-3.5-turbo | 否 |
| USE_AZURE_CHATGPT | 使用 Azure ChatGPT | false | 否 |
| AZURE_DEPLOYMENT_ID | Azure 部署 ID | - | 否 |
| AZURE_API_VERSION | Azure API 版本 | - | 否 |
| PROXY | 代理 | - | 否 |
| SINGLE_CHAT_PREFIX | 私聊前缀 | ["bot", "@bot"] | 是 |
| SINGLE_CHAT_REPLY_PREFIX | 私聊回复前缀 | [bot] | 否 |
| SINGLE_CHAT_REPLY_SUFFIX | 私聊回复后缀 | - | 否 |

## 使用说明
参数相关设置与获取注意查看原始文档：

- https://github.com/zhayujie/chatgpt-on-wechat/blob/master/config.py

- https://docs.link-ai.tech/cow

**由于`1Panel`自动生成的`.env`文件里的引号为双引号，直接部署会出现异常，**

**需要手动修改一下，将产生异常的行，最外面的双引号修改为单引号，重建应用即可。**

如

```
GROUP_CHAT_IN_ONE_SESSION='["ChatGPT测试群"]'
GROUP_CHAT_PREFIX='["@bot"]'
GROUP_NAME_WHITE_LIST='["ChatGPT测试群", "ChatGPT测试群2"]'
IMAGE_CREATE_PREFIX='["画", "看", "找"]'
SINGLE_CHAT_PREFIX='["bot", "@bot"]'
SINGLE_CHAT_REPLY_PREFIX='[bot] '
```

文件路径，按需修改
```
/opt/1panel/apps/local/chatgpt-on-wechat/chatgpt-on-wechat/.env
```

## 参考资料
- 官网: <https://github.com/zhayujie/chatgpt-on-wechat>
- 文档: <https://docs.link-ai.tech/cow>
