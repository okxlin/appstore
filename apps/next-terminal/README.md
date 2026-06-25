# Next Terminal

## 应用简介
一个简单好用安全的开源交互审计系统，支持RDP、SSH、VNC、Telnet、Kubernetes协议。

英文说明：A simple, easy-to-use and secure open source interactive audit system that supports RDP, SSH, VNC, Telnet, and Kubernetes protocols.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.1.1`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40058 | 是 |
| PANEL_APP_PORT_SSH | SSH端口 | 40059 | 否 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |
| SSH_KEY_PATH | SSH 私钥文件(/root/.ssh/id_rsa) | ./ssh/id_rsa | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| SSHD_SWITCH | 启用SSH(true/false) | false | 是 |

## 使用说明
- 安装完成后，在 1Panel 应用页面查看运行状态、端口和日志。
- 首次启用前，请按安装表单填写域名、账号、密码、Token、数据目录等参数。
- 如需对外开放访问，请同步检查防火墙、安全组和反向代理配置。

## 参考资料
- 官网: <https://next-terminal.typesafe.cn/>
- 文档: <https://next-terminal.typesafe.cn/docs/>
- 源码: <https://github.com/dushixiang/next-terminal>
