# MiGPT

## 应用简介
将小爱音箱接入 ChatGPT 和豆包。

英文说明：Plugging ChatGPT and Doubao into Xiaomi Speaker.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：AI。
- 支持架构：amd64。
- 可选版本：`latest`、`4.2.0`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
- `./data/.migpt.js:/app/.migpt.js`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| OPENAI_MODEL | 模型 | gpt-4o | 否 |
| OPENAI_API_KEY | API 密钥 | sk-xxxxxxxxxxxxxxx | 否 |
| OPENAI_BASE_URL | 基础 URL | https://api.openai.com/v1 | 否 |
| OPENAI_API_VERSION | Azure OpenAI API 版本 (编辑去除compose.yml里的注释生效) | - | 否 |
| AZURE_OPENAI_API_KEY | Azure OpenAI API 密钥 (编辑去除compose.yml里的注释生效) | - | 否 |
| AZURE_OPENAI_ENDPOINT | Azure OpenAI 端点 (编辑去除compose.yml里的注释生效) | - | 否 |
| AZURE_OPENAI_DEPLOYMENT | Azure OpenAI 部署名 (编辑去除compose.yml里的注释生效) | - | 否 |
| AUDIO_SILENT | 静音音频链接 (编辑去除compose.yml里的注释生效) | - | 否 |
| AUDIO_BEEP | 提示音链接 (编辑去除compose.yml里的注释生效) | - | 否 |
| AUDIO_ACTIVE | 唤醒音频链接 (编辑去除compose.yml里的注释生效) | - | 否 |

## 使用说明
请先按照 [⚙️ 参数设置](https://github.com/idootop/mi-gpt/blob/main/docs/settings.md) 相关说明，配置好你的 `.env` 和 `.migpt.js` 文件。

- `.migpt.js` 文件路径，按需修改
```
/opt/1panel/apps/local/mi-gpt/mi-gpt/data/.migpt.js
```

## 参考资料
- 官网: <https://github.com/idootop/mi-gpt>
