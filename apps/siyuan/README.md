# 思源笔记 SiYuan

## 应用简介
一款隐私优先的个人知识管理系统。

英文说明：A privacy-first personal knowledge management system.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`3.6.5`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40138 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 赋予文件夹权限

容器要求以`1000:1000`用户身份运行，第一次创建可能失败，需要将应用数据文件夹`data`赋予用户权限，

终端运行以下命令，按需修改

```
chown -R 1000:1000 /opt/1panel/apps/local/siyuan/siyuan/data
```

然后重建应用即可。

## 参考资料
- 官网: <https://b3log.org/siyuan>
- 文档: <https://github.com/siyuan-note/siyuan>
