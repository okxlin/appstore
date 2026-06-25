# FRP-Panel (Server/Client)

## 应用简介
多节点 FRP WebUI (服务端/客户端)。

英文说明：A multi node frp webui (Server/Client).

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`0.1.37`。
- 该应用未声明固定 Web 端口，请按服务类型和版本配置使用。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| COMMAND_LINE | 命令参数 (由控制节点决定，注意修改具体) | - | 是 |

## 使用说明
### 项目使用说明
frp-panel可选docker和直接运行模式部署，直接部署请到release下载文件：[release](https://github.com/VaalaCat/frp-panel/releases)

启动过后默认访问地址为 http://IP:9000

### docker   

注意⚠️：client 和 server 的启动指令可能会随着项目更新而改变，虽然在项目迭代时会注意前后兼容，但仍难以完全适配，因此 client 和 server 的启动指令以 master 生成为准

- master   
   
```bash
docker run -d -p 9000:9000 \
	-p 9001:9001 \
    --restart=unless-stopped \
	-v /opt/frp-panel:/data \
	-e APP_GLOBAL_SECRET=your_secret \ # Master的secret注意不要泄漏，客户端和服务端的是通过Master生成的
	-e MASTER_RPC_HOST=0.0.0.0 \
	vaalacat/frp-panel
# 或者
docker run -d \
	--network=host \
    --restart=unless-stopped \
	-v /opt/frp-panel:/data \
	-e APP_GLOBAL_SECRET=your_secret \ # Master的secret注意不要泄漏，客户端和服务端的是通过Master生成的
	-e MASTER_RPC_HOST=0.0.0.0 \
	vaalacat/frp-panel
```
- client   
   
```bash
docker run -d \
	--network=host \
    --restart=unless-stopped \
	vaalacat/frp-panel client -s xxx -i xxx # 在master WebUI复制的参数
```
- server   
   
```bash
docker run -d \
	--network=host \
    --restart=unless-stopped \
	vaalacat/frp-panel server -s xxx -i xxx # 在master WebUI复制的参数
```

### 直接运行(Linux)
- master   
   
```
APP_GLOBAL_SECRET=your_secret MASTER_RPC_HOST=0.0.0.0 frp-panel master
```
- client   
   
```
frp-panel client -s xxx -i xxx # 在master WebUI复制的参数
```
- server
   
```
frp-panel server -s xxx -i xxx # 在master WebUI复制的参数
```
### 直接运行(Windows)
在下载的可执行文件同名文件夹下创建一个 `.env` 文件(注意不要有后缀名)，然后输入以下内容保存后运行对应命令，注意，client和server的对应参数需要在web页面复制

- master: `frp-panel-amd64.exe master`
```
APP_GLOBAL_SECRET=your_secret
MASTER_RPC_HOST=IP
DB_DSN=data.db
```

client 和 server 要使用在 master WebUI复制的参数

- client: `frp-panel-amd64.exe client -s xxx -i xxx`

- server: `frp-panel-amd64.exe server -s xxx -i xxx`

### 配置说明

[settings.go](https://github.com/VaalaCat/frp-panel/blob/main/conf/settings.go)
这里有详细的配置参数解释，需要进一步修改配置请参考该文件

## 参考资料
- 官网: <https://github.com/VaalaCat/frp-panel>
