# LDAP Auth
## 产品介绍

LDAP Auth 使用 LinuxServer.io 维护的 `linuxserver/ldap-auth` 镜像，提供 LDAP Auth 认证服务 能力。

## 主要功能

- 提供 LDAP 认证代理 能力
- 持久化保存配置和业务数据
- 使用安装表单配置服务端口
- 支持自定义时区

## 访问说明

安装完成后，通过 HTTP 端口访问 LDAP Auth 登录页，认证守护进程端口供反向代理等组件调用。

## Introduction

LDAP Auth uses the LinuxServer.io maintained `linuxserver/ldap-auth` image for LDAP authentication proxy.

## Features

- Provide LDAP authentication proxy
- Persist configuration and application data
- Configure service ports from the install form when the image exposes ports
- Configure the container time zone

## Access

After installation, open the LDAP Auth login page from the HTTP port; the auth daemon port is used by reverse proxies and related integrations.

## Links

- LinuxServer image documentation: <https://docs.linuxserver.io/images/docker-ldap-auth/>
- Project website: <https://github.com/linuxserver/docker-ldap-auth>
