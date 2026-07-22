# Rustpad

## 产品介绍

Rustpad 是一款高效、极简的开源协作文本编辑器，基于操作转换算法，支持多名用户在浏览器中实时协作编辑代码。

## 主要功能

- 浏览器内实时协作编辑
- 基于操作转换算法
- 无需数据库，可选 SQLite 持久化
- 文档默认在指定不活跃天数后过期清理
- 轻量级 Docker 镜像

## 访问说明

- 默认通过 PANEL_APP_PORT_HTTP 对外访问
- 安装后访问地址：http://<服务器IP>:<端口>
- 打开页面后创建或加入文档即可开始协作

## Introduction

Rustpad is an efficient and minimal open-source collaborative text editor based on operational transformation, letting users collaborate in real time while writing code in their browser.

## Features

- Real-time collaborative editing in the browser
- Operational transformation algorithm
- No database required; optional SQLite persistence
- Documents expire after configured inactive days
- Lightweight Docker image

## 数据持久化

- SQLite 数据库保存在 `APP_DATA_DIR` 挂载的 `/data/rustpad.db`
- 即使容器重启，文档内容仍可保留

## 升级说明

升级前建议备份 `APP_DATA_DIR` 目录中的 `rustpad.db` 文件。

## 开源地址

- 项目主页：https://rustpad.io
- GitHub：https://github.com/ekzhang/rustpad
- Docker 镜像：https://hub.docker.com/r/ekzhang/rustpad
