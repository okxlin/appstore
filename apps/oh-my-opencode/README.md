# Oh My OpenCode Runtime

## 产品介绍

这是一个按 1Panel v2 应用商店目录组织的 OpenCode 运行环境。
重点是三件事：

- 配置持久化：`APP_DATA_DIR_2 -> /config`
- 插件与 OpenCode userland 持久化：`APP_DATA_DIR_4 -> /data`
- 工作区、缓存分离：`APP_DATA_DIR_1 -> /workspace`、`APP_DATA_DIR_3 -> /cache`

安装后，OpenCode 默认把 userland 放到 `/data/opencode`，把 `oh-my-opencode` 安装树放到 `/data/oh-my-opencode`，把启动器放到 `/data/bin`，容器重建后不会因为镜像层刷新而丢失这些内容。

## 默认暴露

- `http://0.0.0.0:4096`
- ACP 端口：`8765`

## 持久化约定

- `APP_DATA_DIR_1`：项目工作目录，默认 `./data/workspace`
- `APP_DATA_DIR_2`：`opencode.json`、插件配置等，默认 `./data/config`
- `APP_DATA_DIR_3`：缓存目录，默认 `./data/cache`
- `APP_DATA_DIR_4`：OpenCode userland、`oh-my-opencode` 安装树、持久化启动器与状态，默认 `./data/runtime`

## 镜像发布约定

该应用默认读取：

- `IMAGE_REPO`
- `IMAGE_TAG`

建议配合仓库中的 `oh-my-opencode-builder/` 与 `.github/workflows/build-oh-my-opencode-runtime.yml`，按 `release-factory` 风格发布到 GHCR 后，再在 1Panel 面板中仅修改镜像仓库或 tag。

## 注意

- `serve` 模式默认监听 `4096`，当前证据里没有现成的内建鉴权变量，不应直接裸暴露公网。
- 若要对外使用，建议放到 1Panel 反向代理之后，再补访问控制。
- `acp` 端口 `8765` 是 ACP transport，不适合拿浏览器或普通 HTTP 探活方式去判断健康度。
