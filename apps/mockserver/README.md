# MockServer

## 产品介绍
MockServer 是一个用于模拟、检查和代理 HTTP(S) 请求的测试服务器，适合接口联调、契约测试和请求记录场景。

## 主要功能
- 模拟 HTTP(S) API 响应
- 记录和检查请求
- 作为测试代理转发和修改请求
- 预置根路径健康响应，方便安装后确认服务可访问

## 访问说明
安装后通过 `http://<服务器 IP>:41080` 访问，实际端口以安装表单中的 `PANEL_APP_PORT_HTTP` 为准。

## Introduction
MockServer is a test server for mocking, inspecting and proxying HTTP(S) requests.

## Features
- Mock HTTP(S) API responses
- Inspect and record incoming requests
- Proxy, forward and modify test traffic
- Provide a default root response for post-install access checks

## 部署说明
- 本应用使用官方 Docker 镜像 `mockserver/mockserver` 部署。
- 应用分类：工具。
- 支持架构：amd64、arm64。
- 可选版本：`latest`。

## 端口
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| PANEL_APP_PORT_HTTP | MockServer HTTP 端口 | 41080 | 是 |

## 数据持久化
MockServer 默认以内存方式运行。本应用挂载只读初始化文件 `config/mockserverInitialization.json`，用于让根路径 `/` 返回 200，升级或重启前请确认测试期望值是否需要由外部流程重新加载。

## 参数说明
| 变量 | 说明 | 默认值 | 必填 |
| --- | --- | --- | --- |
| MOCKSERVER_LOG_LEVEL | 日志级别 | INFO | 是 |
| TZ | 容器时区 | Asia/Shanghai | 是 |

## 使用说明
- 默认容器内服务端口为 `1080`，外部访问端口由 `PANEL_APP_PORT_HTTP` 控制。
- 根路径 `/` 预置为简单 200 响应，Dashboard 可访问 `/mockserver/dashboard`。
- MockServer 常用于测试环境，不建议直接暴露到公网。

## 参考资料
- 项目仓库: <https://github.com/mock-server/mockserver>
- Docker 文档: <https://www.mock-server.com/where/docker.html>
- Docker README: <https://github.com/mock-server/mockserver/blob/master/docker/README.md>
