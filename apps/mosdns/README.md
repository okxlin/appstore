# mosdns

## 应用简介
一个插件化的 DNS 转发/分流器。

英文说明：A plug-in DNS forwarder/tap.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`5.3.4`、`static-latest`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | DNS服务端口 | 40028 | 是 |
| PANEL_APP_PORT_API | API端口 | 40029 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
建议搭配`adguardhome`使用，`mosdns`作为上游，`adguardhome`开启`DOH`等。

**需要注意国内法律与规则问题**

容器内默认端口以`config.yaml`文件为准，

有需要的可以自行编辑`config.yaml`修改功能。

应用目录下有个更新附属文件的脚本，可以将其添加到计划任务，以更新所需文件。

计划任务添加如下，按需修改：

```
# 需要修改以下为具体实际路径
cd /opt/1panel/apps/local/mosdns/xxx/data/ && \
bash update.sh
```

### 可自定义文件说明

- force-cn.txt      强制国内解析域名
- force-nocn.txt    强制国外解析域名
- hosts             自定义hosts

## 参考资料
- 官网: <https://hub.docker.com/r/irinesistiana/mosdns>
- 文档: <https://irine-sistiana.gitbook.io/mosdns-wiki/>
- 源码: <https://github.com/IrineSistiana/mosdns>
