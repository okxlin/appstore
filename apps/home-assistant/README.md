# Home Assistant

## 应用简介
开源家庭自动化，将本地控制和隐私放在首位。

英文说明：Open source home automation that puts local control and privacy first.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`2023.8.0.dev20230723`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据文件夹路径 | ./data | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
- 默认访问地址
```
IP:8123
```

## 参考资料
- 官网: <https://www.home-assistant.io/>
- 文档: <https://www.home-assistant.io/docs/>
- 源码: <https://github.com/home-assistant/core>
