# imgproxy

## 产品介绍

imgproxy 是一个高性能、安全的实时图片处理服务。它通过 URL 参数按需获取、缩放、裁剪和转换远程图片，可用于网站、应用和 CDN 的图片处理链路。

## 主要功能

- 按需缩放、裁剪、旋转和转换图片格式
- 支持 JPEG、PNG、WebP、AVIF、GIF 等常见格式
- 使用 URL 签名防止未经授权的处理请求
- 可限制允许获取的图片来源
- 默认阻止回环、链路本地和私有网络来源
- 内置健康检查，适合接入反向代理和负载均衡

## 访问说明

在 1Panel 应用商店中安装后，通过安装时设置的 HTTP 端口访问服务。健康检查地址为：

```text
http://服务器地址:端口/health
```

未设置签名 Key 和签名 Salt 时，可使用上游提供的无签名 URL 格式。例如：

```text
http://服务器地址:端口/insecure/rs:fill:300:200/plain/https://example.com/image.jpg@webp
```

## 安全建议

默认配置为了便于首次使用，不启用 URL 签名，但会阻止回环、链路本地和私有网络来源并保持 TLS 证书校验。公网部署时应同时配置十六进制格式的签名 Key 和签名 Salt，并根据业务设置来源白名单。仅当业务确实需要处理内网图片时才启用“允许私有网络来源”。建议将 imgproxy 放在反向代理或 CDN 后方，限制公开访问范围，避免将其作为不受限制的公共图片处理服务。

## 数据与升级

imgproxy 默认是无状态服务，不创建持久化数据卷。更新或重启不会涉及应用数据迁移；业务系统应保存原始图片和生成 URL 所需的配置。

## Introduction

imgproxy is a fast and secure real-time image processing service. It fetches, resizes, crops, and converts remote images on demand through URL parameters.

## Features

- On-demand image resizing, cropping, rotation, and format conversion
- URL signatures and source allowlists for production deployments
- Loopback, link-local, and private network sources blocked by default
- Built-in health endpoint for reverse proxies and load balancers
- Stateless operation without application data migration

## 来源

- 项目主页：https://imgproxy.net
- 官方文档：https://docs.imgproxy.net
- 源代码：https://github.com/imgproxy/imgproxy
- 官方镜像：https://github.com/imgproxy/imgproxy/pkgs/container/imgproxy
