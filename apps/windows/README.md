# Windows

## 应用简介
在 Docker 容器内运行 Windows。

英文说明：Windows inside a Docker container.

## 部署说明
- 本应用使用 Docker Compose 在 1Panel 中部署。
- 应用分类：工具。
- 支持架构：amd64。
- 可选版本：`latest`、`5.16`、`latest-online`。
- 安装后按应用表单中的端口访问 Web UI、SSH 或对应服务。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | 端口 | 40286 | 是 |
| RDP_PORT | RDP 远程端口 | 3389 | 是 |

## 数据持久化
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| DATA_PATH | 数据路径 | ./data/storage | 是 |
| IMAGE_ISO_FILE | Windows ISO 文件路径 | - | 是 |

升级或迁移前，请在 1Panel 中备份上述数据目录。

## 配置项
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MANUAL | 手动安装 | Y | 是 |
| DISK_SIZE | 磁盘大小 | 30GB | 是 |
| RAM_SIZE | 内存大小 | 4GB | 是 |
| CPU_CORES | CPU 核心数 | 2 | 是 |
| USERNAME | 登录用户名 (非匹配的系统镜像则此设置无效) | docker | 是 |
| PASSWORD | 登录密码 (非匹配的系统镜像则此设置无效) | password | 是 |
| RESTART_POLICY | 重启策略 | always | 是 |

## 使用说明
要验证您的系统是否支持 KVM，请运行以下命令：

```
sudo apt install cpu-checker
sudo kvm-ok
```

如果您根本没有收到来自`kvm-ok`的任何错误，但容器仍然抱怨`/dev/kvm`丢失，则将`privileged: true`添加到您的 compose 文件（或`--privileged`到您的`run`命令）可能会有所帮助，排除任何权限问题。

**在线下载的 Windows 镜像版本可从以下选择 (后续官方可能有修改，以官方文档为准)**

  | **Value** | **Version**              | **Size** |
  |---|---|---|
  | `win11`   | Windows 11 Pro           | 6.4 GB   |
  | `win11e`  | Windows 11 Enterprise    | 5.8 GB   |
  | `win10`   | Windows 10 Pro           | 5.7 GB   |
  | `ltsc10`  | Windows 10 LTSC          | 4.6 GB   |
  | `win10e`  | Windows 10 Enterprise    | 5.2 GB   |
  ||||  
  | `win8`    | Windows 8.1 Pro          | 4.0 GB   |
  | `win8e`   | Windows 8.1 Enterprise   | 3.7 GB   |
  | `win7`    | Windows 7 Enterprise     | 3.0 GB   |
  | `vista`   | Windows Vista Enterprise | 3.0 GB   |
  | `winxp`   | Windows XP Professional  | 0.6 GB   |
  ||||
  | `2022`    | Windows Server 2022      | 4.7 GB   |
  | `2019`    | Windows Server 2019      | 5.3 GB   |
  | `2016`    | Windows Server 2016      | 6.5 GB   |
  | `2012`    | Windows Server 2012      | 4.3 GB   |
  | `2008`    | Windows Server 2008      | 3.0 GB   |
  ||||
  | `core11`  | Tiny 11 Core             | 2.1 GB   |
  | `tiny11`  | Tiny 11                  | 3.8 GB   |
  | `tiny10`  | Tiny 10                  | 3.6 GB   |

## 参考资料
- 官网: <https://github.com/dockur/windows>
