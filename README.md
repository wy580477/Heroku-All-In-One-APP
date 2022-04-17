## 鸣谢
- [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)  依靠来自P3TERX大佬的Aria2脚本，实现了Aria2下载完成自动触发Rclone上传。
- [wahyd4/aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)  启发了本项目的总体思路，解决了Heroku使用变量导入Rclone配置文件的难题。
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  使用yaml配置文件的静态导航页，非常便于自定义。
## 注意
 1. **本项目仅为学习用途，请勿滥用，重度使用可能导致账号被封。类似 Heroku 的免费服务少之又少，且用且珍惜。**
 2. Heroku的文件系统是临时性的，每24小时强制重启一次后会恢复到部署时状态。不适合长期BT下载和共享文件用途。
 3. Aria2配置文件默认限速5MB/s。
 4. 免费Heroku dyno半小时无Web访问会休眠，可以使用[Helixtools](https://hetrixtools.com/uptime-monitor/215727.html)这样的免费VPS/网站监测服务定时http ping，保持持续运行。

[概述](#概述) 

[部署方式](#部署方式) 

[变量设置](#变量设置)  

[初次使用](#初次使用)  

[更多用法和注意事项](#更多用法和注意事项)  

## 概述
基于本人 [Aria2-AIO-Container](https://github.com/wy580477/Aria2-AIO-Container) Aria2全能容器项目，集成了Aria2+Rclone+WebUI、Aria2+Rclone联动自动上传功能、Rclone远程存储文件列表、可自定义的导航页、Filebrowser轻量网盘、Xray Vmess协议。

![image](https://user-images.githubusercontent.com/98247050/163175500-3c346c62-c2f3-4c7e-acea-36e541a26e6c.png) 
 1. 联动上传功能只需要准备rclone.conf配置文件, 其他一切配置都预备齐全。
 2. Aria2和Rclone多种联动模式。
 3. Rclone以daemon方式运行，可在WebUI上手动传输文件和实时监测传输情况。
 4. log目录下有每个进程独立日志。
## 部署方式
 **请勿使用本仓库直接部署**
 1. 点击右上角Fork，再点击Creat Fork。
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字，选Private创建私有库。
 4. 比如你的Github用户名是bobby，私有库名称是green。浏览器登陆heroku后，访问https://dashboard.heroku.com/new?template=https://github.com/bobby/green 即可部署。
 5. 这样即使本仓库被删，也不会影响你的私有库。
### 变量设置
对部署时需设定的变量名称做如下说明。
| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `USER` | `admin` | 用户名，适用于所有需要输入用户名的页面 |
| `PASSWORD` | `password` | 务必修改为强密码，同样适用于所有需要输入密码的页面 |
| `LANGUAGE` | `en` | 设置导航页和Filebrowser界面语言，chs为中文 |
| `PORTAL_PATH` | `/portal` | 导航页路径和所有Web服务的基础URL，相当于密码之外多一层保护。不能为“/"和空值，结尾不能加“/" |
| `DRIVE_NAME` | `auto` | Rclone远程存储配置名称，默认值auto将从配置文件第一行中提取 |
| `RCLONE_CONFIG_BASE64` | `` | Rclone配置文件Base64编码，可使用linux系统base64命令或者在线base64工具生成 |
| `VMESS_UUID` | `a3ac20a7-45fe-4656-97ee-937ffec46144` | Vmess协议UUID，务必修改，建议使用UUID工具生成 |
| `VMESS_PATH` | `/f495ba1f` | Vmess协议路径，不要包含敏感信息 |
| `TZ` | `UTC` | 时区，Asia/Shanghai为中国时区 |

对控制Aria2和Rclone联动模式的POST_MODE变量说明：
 1. dummy模式为无操作，move模式为下载及做种完成后移动到本地finished目录。
 2. move_remote模式为下载及做种完成后先移动到本地data数据卷下finished目录，然后移动到rclone远程存储。
 3. move_remote_only模式为下载及做种完成后移动到rclone远程存储。
 4. copy_remote_first模式为下载完成后立即复制到rclone远程存储，BT任务在做种前即触发。
 5. copy_remote模式为下载及做种完成后先移动到本地finished目录，然后复制到rclone远程存储。
 6. custom模式为自行设置aria2配置文件触发脚本选项。
### 初次使用
 1. 部署完成后，比如你的heroku域名是bobby.herokuapp.com，导航页路径是/portal，访问bobby.herokuapp.com/portal 即可到达导航页。
 2. 点击AriaNg，这时会弹出认证失败警告，不要慌，按下图把之前部署时设置的密码填入RPC密钥即可。
   ![image](https://user-images.githubusercontent.com/98247050/163184113-d0f09e78-01f9-4d4a-87b9-f4a9c1218253.png)
### 更多用法和注意事项
 1. Heroku每24小时重启后恢复到部署时文件系统，所以除了变量外任何改动都建议在部署前在github仓库内修改。
 2. 修改Heroku app变量方法：在Heroku app页面上点击setting，再点击Reveal Config Vars即可修改。
 3. Rclone配置文件末尾加上如下内容，可以在Rclone Web前端中挂载本地存储，方便手动上传。
```
[local]
type = alias
remote = /mnt/data
```
 3. Rclone Web前端手动传输文件方法是点击页面左侧Explorer，然后选双版面布局，打开两个Rclone存储配置，直接拖动文件即可。
 4. 因为Heroku文件系统的临时性，Rclone无法更新token，所以每隔一段时间需要更新Rclone配置文件变量，不然token会过期。
 5. 无法通过Rclone Web前端建立需要网页认证的存储配置。
 6. content/aria2目录下，aria2_chs(en).conf为Aria2配置文件，按需要指定的语言环境变量选择版本修改。script.conf为Aria2自动化配置文件。修改script.conf可以设置aria2清理文件方式和Rclone上传目录。
 7. 每次dyno启动自动更新BT tracker list，如果需要禁用，重命名或删除/content/aria2/tracker.sh文件。
 8. content/homer_conf目录下是导航页设置文件homer_chs(en).yml和图标资源，新加入的图标，在设置文件中要以./assets/tools/example.png这样的路径调用。
 9. Vmess协议AlterID为0，可用Vmess WS 80端口或者Vmess WS tls 443端口连接。Xray设置可以通过content/service/xray/run文件修改。
 10. 为了安全考虑，默认建立的Filebrowser用户无管理员权限，可在content/service/filebrowser/run文件中下面命令后加上--perm.admin赋予管理员权限。
```
filebrowser -d /.aria2allinoneworkdir/filebrowser.db users add ${USER} ${PASSWORD} --perm.admin
```
 11. 可以通过Filebrowser Web Shell查看APP运行信息、运行aria2c和rclone命令、以及控制服务启停，预置可用命令：sv,aria2c,rclone,du,df,free,nslookup,netstat,top,ps  

     top -n 1 查看进程资源占用情况
     
     ![image](https://user-images.githubusercontent.com/98247050/163199096-37536a86-0e11-40cf-b957-774e639a4952.png)
     
     du命令查看目录空间占用，df命令查看硬盘空间占用
     
     ![image](https://user-images.githubusercontent.com/98247050/163319167-e255c1a2-671c-4a4f-8ba0-36953e7e1176.png)
     
     sv命令控制服务启停和执行aria2c命令下载文件
     
     ![image](https://user-images.githubusercontent.com/98247050/163200055-dafdc514-8e22-4c69-803e-e02491ef6280.png)
