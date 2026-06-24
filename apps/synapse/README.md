# Synapse

## 应用简介
Synapse是一个开源的Matrix家庭服务器，自建聊天服务端。

英文说明：Synapse is an open-source Matrix homeserver,build your own chat server.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`1.155.0`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40026 | 是 |

## 数据持久化
- `synapse-data:/data`

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 使用说明
### 步骤1
创建前需要使用终端运行以下命令创建依赖配置文件，
需要按需修改参数`my.matrix.host`

```
# 参数解释说明
docker run -it --rm \
  -v synapse-data:/data \  # 挂载一个卷，将容器内的 /data 目录映射到 synapse-data 卷
  -e SYNAPSE_SERVER_NAME=my.matrix.host \  # 设置 Synapse 服务器的公共主机名
  -e SYNAPSE_REPORT_STATS=no \  # 禁用匿名统计报告
  -e SYNAPSE_HTTP_PORT=8008 \  # 设置 Synapse 监听的 HTTP 端口为 8008
  -e SYNAPSE_CONFIG_DIR=/data \  # 设置配置文件的存储位置为 /data
  -e SYNAPSE_DATA_DIR=/data \  # 设置持久数据的存储位置为 /data
  -e TZ=Asia/Shanghai \  # 设置容器的时区为亚洲/上海
  -e UID=1000 \  # 设置运行 Synapse 的用户 ID
  -e GID=1000 \  # 设置运行 Synapse 的用户组 ID
  matrixdotorg/synapse:latest generate  # 运行最新版本的 matrixdotorg/synapse 镜像，并执行 generate 命令来生成配置文件

```
实际运行命令，注意修改
```
docker run -it --rm \
  -v synapse-data:/data \
  -e SYNAPSE_SERVER_NAME=my.matrix.host \
  -e SYNAPSE_REPORT_STATS=no \
  -e SYNAPSE_HTTP_PORT=8008 \
  -e SYNAPSE_CONFIG_DIR=/data \
  -e SYNAPSE_DATA_DIR=/data \
  -e TZ=Asia/Shanghai \
  -e UID=1000 \
  -e GID=1000 \
  matrixdotorg/synapse:latest generate

```

配置文件默认存放路径是在一个`synapse-data`存储卷里，
```
# 配置文件路径
/var/lib/docker/volumes/synapse-data/_data
```

### 步骤2
创建应用

### 步骤3

需要打开容器，运行命令创建用户

```
# 创建管理员账户
# register_new_matrix_user  http://localhost:8008 -c /data/homeserver.yaml  -a -u 用户名 -p 密码
register_new_matrix_user  http://localhost:8008 -c /data/homeserver.yaml  -a -u admin -p password

# 创建普通用户账户
# register_new_matrix_user  http://localhost:8008 -c /data/homeserver.yaml   --no-admin -u 用户名 -p 密码
register_new_matrix_user  http://localhost:8008 -c /data/homeserver.yaml   --no-admin -u user -p password

# 查看更多命令与帮助
register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml --help
```

`register_new_matrix_user`自带命令

```
usage: register_new_matrix_user [-h] [-u USER] [-p PASSWORD] [-t USER_TYPE] [-a | --no-admin] (-c CONFIG | -k SHARED_SECRET) [server_url]
用法：register_new_matrix_user [-h] [-u USER] [-p PASSWORD] [-t USER_TYPE] [-a | --no-admin] (-c CONFIG | -k SHARED_SECRET) [server_url]

Used to register new users with a given homeserver when registration has been disabled. The homeserver must be configured with the 'registration_shared_secret' option set.
用于在注册被禁用时，通过给定的homeserver注册新用户。homeserver必须配置'registration_shared_secret'选项。

positional arguments:
位置参数：
server_url URL to use to talk to the homeserver. By default, tries to find a suitable URL from the configuration file. Otherwise, defaults to 'http://localhost:8008'.
server_url 与homeserver通信的URL。默认情况下，尝试从配置文件中找到合适的URL。否则，默认为'http://localhost:8008'。

options:
选项：
-h, --help show this help message and exit
-h, --help 显示帮助信息并退出
-u USER, --user USER Local part of the new user. Will prompt if omitted.
-u USER, --user USER 新用户的本地部分。如果省略，将提示输入。
-p PASSWORD, --password PASSWORD
New password for user. Will prompt if omitted.
-p PASSWORD, --password PASSWORD
用户的新密码。如果省略，将提示输入。
-t USER_TYPE, --user_type USER_TYPE
User type as specified in synapse.api.constants.UserTypes
-t USER_TYPE, --user_type USER_TYPE
用户类型，如synapse.api.constants.UserTypes中所指定的
-a, --admin Register new user as an admin. Will prompt if --no-admin is not set either.
-a, --admin 将新用户注册为管理员。如果未设置--no-admin，也会提示输入。
--no-admin Register new user as a regular user. Will prompt if --admin is not set either.
--no-admin 将新用户注册为普通用户。如果未设置--admin，也会提示输入。
-c CONFIG, --config CONFIG
Path to server config file. Used to read in shared secret.
-c CONFIG, --config CONFIG
服务器配置文件的路径。用于读取共享密钥。
-k SHARED_SECRET, --shared-secret SHARED_SECRET
Shared secret as defined in server config file.
-k SHARED_SECRET, --shared-secret SHARED_SECRET
服务器配置文件中定义的共享密钥。
```

### 提示

所有数据存放在`synapse-data`存储卷里，

删除应用时，假如需要完全清除数据，还需要将`synapse-data`存储卷删除。

## 参考资料
- 官网: <https://matrix.org/docs/projects/server/synapse>
- 文档: <https://matrix-org.github.io/synapse/latest/>
- 源码: <https://github.com/matrix-org/synapse>
