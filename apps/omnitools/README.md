# OmniTools

## 产品介绍

OmniTools 是一组可自托管的浏览器工具。默认工作流在浏览器中本地处理数据，适合 JSON 格式化、编码转换和日常文本处理等任务。

## 主要功能

- 提供多个无需账户的浏览器工具
- 支持 JSON Prettify 等本地数据处理工作流
- 使用官方 `iib0011/omni-tools` 容器镜像

## 访问说明

- 在 1Panel 安装页面设置 Web 端口
- 安装完成后访问 `http://<服务器 IP>:<Web 端口>`

## 数据与隐私

- 本应用不创建数据库、不挂载持久化目录，也不需要额外服务
- JSON Prettify 等默认工具在浏览器内处理输入；请根据实际使用的工具审阅其页面提示后再输入敏感数据

## 来源

- 项目与安装说明: <https://github.com/iib0011/omni-tools>
- 官方 Docker 自托管说明: <https://github.com/iib0011/omni-tools#self-hostrun>
- 许可证: MIT

## Introduction

OmniTools is a self-hosted collection of browser tools. Its default workflows process data locally in the browser for tasks such as JSON formatting, encoding conversion, and text handling.

## Features

- Multiple browser tools without an account
- Local data-processing workflows such as JSON Prettify
- Official `iib0011/omni-tools` container image

## Access

Set the Web port in the 1Panel install form, then open `http://<server-ip>:<Web-port>`.

## Data and Privacy

- This package has no database, persistent mount, or companion service.
- Default tools such as JSON Prettify process input in the browser. Review the relevant tool page before entering sensitive data.

## Sources

- Project and installation guidance: <https://github.com/iib0011/omni-tools>
- Official Docker self-hosting guidance: <https://github.com/iib0011/omni-tools#self-hostrun>
- License: MIT
