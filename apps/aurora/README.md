# Aurora

## 应用简介
极光面板-一个多服务器端口租用管理面板。

英文说明：A multi-server port leasing management panel.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`0.18.9`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40036 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据存放文件夹 | ./data | 是 |
| SSH_KEY_PATH | SSH 私钥文件 | /root/.ssh/id_rsa | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_DB_NAME | 数据库名 | aurora | 是 |
| PANEL_DB_USER | 数据库用户 | aurora | 是 |
| PANEL_DB_USER_PASSWORD | 数据库用户密码 | aurora | 是 |
| SECRECY_KEY | 保密密码 | aurora | 是 |

## 使用说明
### 1.前期准备
- 创建所需网络

终端运行
```
docker network create aurora-worker
docker network create aurora-network
```

### 2.生成 SSH 密钥
```
# 如果面板服务器并没有已经生成好的 ssh 密钥
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
# 后面一直回车，跳过设置 passphase 即可
# 然后还需要将面板服务器 ~/.ssh/id_rsa.pub 里面的内容复制到每一台被控机的 ~/.ssh/authorized_keys 文件中去。
```

### 3.启动应用后创建管理员
当应用已经正确启动，点击面板"容器"功能，，找到与`aurora` `backend`相关的容器，

终端运行以下
```
# 创建管理员用户（密码必须设置8位以上，否则无法登陆）
python app/initial_data.py
```
### 4.已知问题

当开启`UFW`等防火墙功能时，所创建的网络间容器通信存在问题，无法正确运行。

有兴趣的可以尝试以下方式，或可解决与防火墙的共存问题。

- [what-is-the-best-practice-of-docker-ufw-under-ubuntu](https://stackoverflow.com/questions/30383845/what-is-the-best-practice-of-docker-ufw-under-ubuntu)

## 参考资料
- 官网: <https://github.com/Aurora-Admin-Panel/deploy>
