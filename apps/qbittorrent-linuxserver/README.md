# linuxserver/qbittorrent⁠

由 LinuxServer.io 提供的 Qbittorrent 容器

Qbittorrent 项目旨在提供 μTorrent 的开源软件替代方案

QBittorrent 基于 Qt 工具包和 libtorrent-rasterbar 库
## docker-compose
```docker compose
services:
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - WEBUI_PORT=8080
      - TORRENTING_PORT=6881
    volumes:
      - /path/to/qbittorrent/appdata:/config
      #optional
      - /path/to/downloads:/downloads 
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
```
## docker cli
```bash
docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e WEBUI_PORT=8080 \
  -e TORRENTING_PORT=6881 \
  -p 8080:8080 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v /path/to/qbittorrent/appdata:/config \
  -v /path/to/downloads:/downloads `#optional` \
  --restart unless-stopped \
  lscr.io/linuxserver/qbittorrent:latest
```

## 参数
| 参数                  | 功能                                |
|-----------------------|-------------------------------------|
| `-p 8080:8080`        | WebUI 界面端口                      |
| `-p 6881:6881`        | TCP 连接端口                        |
| `-p 6881:6881/udp`    | UDP 连接端口                        |
| `-e PUID=1000`        | 指定用户 ID，详见下文说明            |
| `-e PGID=1000`        | 指定用户组 ID，详见下文说明          |
| `-e TZ=Etc/UTC`       | 指定使用的时区，详见时区列表         |
| `-e WEBUI_PORT=8080`  | 修改 WebUI 的端口，详见下文说明      |
| `-e TORRENTING_PORT=6881` | 修改 TCP/UDP 连接的端口，详见下文说明 |
| `-v /config`          | 包含所有相关配置文件的路径           |
| `-v /downloads`       | 磁盘上的下载位置                    |
| `--read-only=true`    | 以只读文件系统运行容器，详见文档说明  |
| `--user=1000:1000`    | 以非 root 用户运行容器，详见文档说明  |
