# CLIProxyAPI

一个为 CLI 提供 OpenAI/Gemini/Claude/Codex 兼容 API 接口的代理服务器。

## 相关链接
- [GitHub 仓库](https://github.com/router-for-me/CLIProxyAPI)

## 数据配置说明
安装本应用后，相关数据和日志挂载在 1Panel 应用安装目录下的 `data` 文件夹中。
- `config.yaml`: 配置文件
- `auths`: 认证信息缓存目录
- `logs`: 运行日志目录

## 使用 CLI Proxy API 自带的 Web UI

**注意**：要开启远程访问，应该先修改 `config.yaml` 里的以下几个部分：
```yaml
remote-management:
  allow-remote: false
  secret-key: ""
```

1. 启动 CLI Proxy API 服务。
2. 打开：`http://<host>:<api_port>/management.html`
3. 输入 **管理密钥** 并连接。
