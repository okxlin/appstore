# 什么是唐僧叨叨

**唐僧叨叨**是一款`轻量级`，`高性能`，`重安全`专注于`私有化部署`的`开源`即时通讯系统。

## 特性

**唐僧叨叨**具备以下特性：

- 🆓 开源免费：服务端源码，APP源码，Web/PC端源码全部开源，Apache2.0开源协议（可商用），没人能拿捏你
- 🔏 私有化部署：所有程序和数据都在自己的服务器上，不用担心数据泄露，不用担心数据被用于其他用途
- 🆚 消息必达：采用 tcp + ack机制，保证消息必达，支持离线消息，支持消息漫游。
- 🔐 内容安全：消息传输采用私有二进制加密协议、DH+流式加密，防止消息内容泄露
- 💽 消息永久存储：消息支持永久存储，得益于WuKongIM的自研消息db，永久存储不影响性能，只浪费点磁盘空间
- 📱 多设备消息同步：支持 1 个移动端、多个 Web/PC 端同时在线时，并且支持多端之间的消息实时同步。
- 📟 全平台支持：iOS，Android，Windows，MAC，Ubuntu，Web

## 为什么选择唐僧叨叨

厂商 | Demo二开成本 | Web端同步 | 群人数 | 存储 | 开源 | 私有化部署
---|--- |--- |--- |---  |--- |---
<label style="color:red">唐僧叨叨</label> | <label style="color:red">运营级Demo，换个皮就能直接上线运营</label> | <label style="color:red">所有操作实时同步 </label> | <label style="color:red">无限制</label>  | <label style="color:red">永久</label>(自研消息数据库加持) | <label style="color:red">是 </label> | <label style="color:red">支持 </label>
网易云信  | Demo简单，很多功能都只是做演示 | 无法同步 | 小于5000  | 30天/免费版 1年/专业版 | 否 | 未知
融云  | Demo简单，离运营级还有距离 | 消息同步，设置不能同步 | 3000 | 7天 | 否 | 未知
环信  | Demo超简单，开发成运营级产品成本高 | app与web互踢  | 3000 | 7天（需联系商务） | 否 | 未知
腾讯云IM | Demo简单，离运营级还有距离  | 大部分能实时同步 | 付费后最多扩展到6000人 | 30天/旗舰版 | 否 | 未知

## 唐僧叨叨的组成


**客户端**

主要是用户端使用 包括：[iOS](https://github.com/TangSengDaoDao/TangSengDaoDaoiOS)，[Android](https://github.com/TangSengDaoDao/TangSengDaoDaoAndroid)，[Web](https://github.com/TangSengDaoDao/TangSengDaoDaoWeb)，[PC](https://github.com/TangSengDaoDao/TangSengDaoDaoWeb)

**服务端**

给客户端调用的后端系统 包括：通讯端（[WuKongIM](https://github.com/WuKongIM/WuKongIM)），业务端([TangSengDaoDaoServer](https://github.com/TangSengDaoDao/TangSengDaoDaoServer))

**管理端**

[TangSengDaoDaoManager](https://github.com/TangSengDaoDao/TangSengDaoDaoManager)
