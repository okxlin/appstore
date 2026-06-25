# EasyTier

## 应用简介
一个简单、安全、去中心化的内网穿透 VPN 组网方案。

英文说明：A simple, safe and decentralized VPN networking solution.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`2.6.4`、`config-latest`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| TIME_ZONE | 时区 | Asia/Shanghai | 是 |
| PRIVILEGED_MODE | 特权模式开关 | true | 是 |
| HOSTNAME | 主机名 | easytier | 是 |
| COMMAND | 命令 (按需修改) | -i --network-name --network-secret -e tcp://:11010 -l  | 是 |

## 使用说明
相关信息可通过容器日志与配置文件获取，注意参考官方文档来使用。
***
[简体中文](https://github.com/EasyTier/EasyTier/blob/main/README_CN.md) | [English](https://github.com/EasyTier/EasyTier/blob/main/README.md)

**请访问 [EasyTier 官网](https://www.easytier.top/) 以查看完整的文档。**

一个简单、安全、去中心化的内网穿透 VPN 组网方案，使用 Rust 语言和 Tokio 框架实现。

## 参考资料
- 官网: <https://www.easytier.top>
- 源码: <https://github.com/EasyTier/EasyTier>
