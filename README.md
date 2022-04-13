## 鸣谢

- [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)  依靠来自P3TERX大佬的Aria2脚本，实现了Aria2下载完成自动触发Rclone上传。
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  使用yaml配置文件的静态导航页，非常便于自定义。

## 概述

本容器集成了Aria2+Rclone+WebUI、Aria2+Rclone联动自动上传功能、可自定义的导航页、Filebrowser轻量网盘。

![网页捕获_12-4-2022_14495](https://user-images.githubusercontent.com/98247050/162898222-d10f2269-70af-4a8f-97ec-c48818741e44.jpeg)
 
 1. 开箱即用，只需要准备rclone.conf配置文件, 容器一切配置都预备齐全。
 2. AMD64/i386/Arm64/Armv7多架构支持。
 3. 由caddy反代所有web服务和远程控制路径，均有密码保护，可自定义基础URL防爆破，并可使用caddy的自动https功能。
 4. 可自定义内容导航页，显示当前容器运行信息。
 5. Aria2和Rclone多种联动模式，有BT下载完成做种前立即开始上传功能，适合有长时间做种需求的用户。
 6. Rclone以daemon方式运行，可实时在WebUI上监测传输情况。
 7. 基于 [runit](http://smarden.org/runit/index.html) 的进程管理，每个进程可以独立启停，互不影响。
 8. 所有配置集中于config数据卷，方便迁移。
 9. 支持PUID/GUID方式以非root用户运行容器内所有进程，rclone用户密码以htpasswd文件方式储存，Filebrowser初始用户为普通用户，不能自行添加可执行的命令。
 10. 功能多体积小，容器image不到130MB。

## 快速部署
 
 1. 建议使用docker-compose方式部署，方便修改变量配置。
 2. 下载[docker-compose文件](https://raw.githubusercontent.com/wy580477/Aria2-AIO-Container/master/docker-compose.yml)
 3. 按说明设置好变量，用如下命令运行容器。
```
docker-compose up -d
```
 4. 按ip地址或域名+基础URL就可打开导航页，随后打开AriaNg，将变量中的密码填入AriaNg设置中的RPC密钥即可连接Aria2。
 5. 打开Filebrowser页面，将事先准备好的rclone.conf配置文件上传到config目录下，运行如下命令重启容器即可让Aria2—Rclone联动功能生效。
```
docker restart allinone
```

### 更多截图展示

通过Filebrowser Web Shell控制服务启停。

![网页捕获_12-4-2022_16951](https://user-images.githubusercontent.com/98247050/162912851-bd6f83b9-610e-440e-abb8-ff61e7fbd87c.jpeg)

Rclone WebUI实时监测文件传输情况。

![image](https://user-images.githubusercontent.com/98247050/162913669-e09fbae9-a0dc-4f39-b5ac-ec2f8badb984.png)
