## 产品介绍

**Wavelog** 是一个开源的业余无线电通联日志管理系统，业余无线电爱好者们(HAM)可以借助Wavelog轻松管理通联记录，并与QRZ.com、LoTW等平台一键同步。

## 主要功能

* 自定义电台呼号、站点和位置，在云端轻松记录日常通联
* 上传/下载LoTW、qrz.com等平台的通联记录。
* 支持通过API或网关与其他业余无线电软件或硬件联动，如GridTracker2等。

## 安装说明

* Wavelog官方推荐使用MariaDB数据库，MariaDB >= 10.2，MySQL >= 8
* 安装完成后，网站Base URL在`./data/wavelog-config/config.php`中持久储存。
* 
```php
$config['base_url']	= 'http://localhost:3792/';  // Line 123
```
 
*请务必手动修改`base_url`为外网访问时的真实URL，否则在浏览时会发生错误。*