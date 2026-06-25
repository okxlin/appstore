# RustDesk

## 应用简介
RustDesk是一款开源的远程桌面软件。

英文说明：RustDesk is an open source remote desktop software.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`、`s6-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| NAT_TEST_PORT | NAT类型测试端口 | 21115 | 是 |
| HBBS_PORT | hbbs端口(配合IP/域名使用) | 21116 | 是 |
| HBBR_PORT | hbbr端口(客户端中继服务器端口) | 21117 | 是 |
| WEB_CLIENT_PORT1 | 网页客户端支持端口1 | 21118 | 是 |
| WEB_CLIENT_PORT2 | 网页客户端支持端口2 | 21119 | 是 |

## 数据持久化
- `"./data:/root" # 自定义挂载目录`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| HOST_ADDRESS | IP地址或域名(必改项) | 172.17.0.1 | 是 |

## 使用说明
### **注意事项**
 - 运行完容器后需要获取当前数据目录"./data/hbbs"下的key，方便客户端使用。

```
# 面板的话在文件管理里查看即可
# 终端的话输入以下获得
cat ./data/hbbs/id_ed25519.pub
```

 - 如果要更改key，请删除"./data/hbbs"和"./data/hbbr"文件夹下的"id_ed25519"和"id_ed25519.pub"文件并重新启动 hbbs/hbbr，hbbs将会产生新的密钥对。

## 参考资料
- 官网: <https://rustdesk.com/zh/>
- 文档: <https://rustdesk.com/docs/zh-cn/>
- 源码: <https://github.com/rustdesk/rustdesk>
