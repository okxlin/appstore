# WireGuard Easy

## 应用简介
运行 WireGuard VPN + 基于 Web 的管理 UI 的最简单方法。

英文说明：The easiest way to run WireGuard VPN + Web-based Admin UI.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`15`、`nightly`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 网页端口 | 40074 | 是 |
| WIREGUARD_PORT | Wireguard 端口 | 51820 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PASSWORD_HASH | 网页密码 hash (注意查看说明文档，默认为`PAssw00rd`) | $$2a$$12$$0AL3hGeedv8fOfsNtfZY5OO3mMvBqlnZA8QmeBGfWPAQEoZ7LZ/7a | 是 |
| HOST_ADDRESS | 本机地址(必改项) | 172.17.0.1 | 是 |
| WG_DEFAULT_ADDRESS | 默认 Wireguard 网段 | 10.0.8.x | 是 |
| WG_DEFAULT_DNS | 默认 Wireguard DNS | 119.29.29.29,1.1.1.1 | 是 |
| WG_MTU | Wireguard MTU | 1420 | 是 |
| WG_ALLOWED_IPS | Wireguard 允许的 IP 段 | 10.0.8.0/24 | 是 |
| WG_PERSISTENT_KEEPALIVE | Wireguard 保活间隔 | 25 | 是 |

## 使用说明
> **14版本以上启用了bcrypt 密码哈希，以前设置密码方式失效**

`wg-password`（也称为 **wgpw**）是一个生成 bcrypt 密码哈希的脚本，旨在通过与 **`wg-easy`** 集成来提高安全性，方便管理 WireGuard 配置。

### Docker 使用方法

使用 Docker 生成 bcrypt 密码哈希，运行以下命令：

```sh
docker run -it ghcr.io/wg-easy/wg-easy wgpw YOUR_PASSWORD
```

示例输出：
```sh
PASSWORD_HASH='$2b$12$coPqCsPtcFO.Ab99xylBNOW4.Iu7OOA2/ZIboHN6/oyxca3MWo7fW'
```

如果未提供密码，工具将提示您输入：

```sh
docker run -it ghcr.io/wg-easy/wg-easy wgpw
Enter your password:  # 输入密码（输入不可见）
PASSWORD_HASH='$2b$12$coPqCsPtcFO.Ab99xylBNOW4.Iu7OOA2/ZIboHN6/oyxca3MWo7fW'
```

### 重要说明

- **在 `docker-compose.yml` 中使用**：在 `docker-compose.yml` 文件中，将生成的哈希中的每个 `$` 替换为 `$$`，以防止解释错误。

```yaml
- PASSWORD_HASH=$$2y$$10$$hBCoykrB95WSzuV4fafBzOHWKu9sbyVa34GJr8VV5R/pIelfEMYyG
```

## 参考资料
- 官网: <https://www.wireguard.com/>
- 源码: <https://github.com/wg-easy/wg-easy>
