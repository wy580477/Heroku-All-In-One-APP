## 鸣谢
- [alexta69/metube](https://github.com/alexta69/metube) 简洁好用的yt-dlp前端。
- [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)  依靠来自P3TERX的Aria2脚本，实现了Aria2下载完成自动触发Rclone上传。
- [wahyd4/aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)  启发了本项目的总体思路。
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  使用yaml配置文件的静态导航页，便于自定义。
- [mayswind/AriaNg](https://github.com/mayswind/AriaNg) | [filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) | [aria2/aria2](https://github.com/aria2/aria2) | [rclone/rclone](https://github.com/rclone/rclone) | [iawia002/lux](https://github.com/iawia002/lux)
## 注意
 1. **请勿滥用，重度使用可能导致账号被封。**
 2. Heroku的文件系统是临时性的，每24小时强制重启一次后会恢复到部署时状态。不适合长期BT下载和共享文件用途。
 3. Aria2配置文件默认限速5MB/s。
 4. 免费Heroku dyno半小时无Web访问会休眠，可以使用[hetrixtools](https://hetrixtools.com/uptime-monitor/215727.html)这样的免费VPS/网站监测服务定时http ping，保持持续运行。

[概述](#概述) 

[部署方式](#部署方式) 

[变量设置](#变量设置)  

[初次使用](#初次使用)  

[更多用法和注意事项](#更多用法和注意事项)  

## 概述
基于本人 [Aria2-AIO-Container](https://github.com/wy580477/Aria2-AIO-Container) Aria2全能容器项目，集成了Aria2+Rclone+WebUI、Aria2+Rclone联动自动上传功能、Rclone远程存储文件列表、可自定义的导航页、Filebrowser轻量网盘、lux多视频站下载工具、ttyd Web终端、Xray Vmess协议。

![image](https://user-images.githubusercontent.com/98247050/164155172-83e69daa-01e2-481b-9fd0-232dbc884519.png)

 1. 联动上传功能只需要准备rclone.conf配置文件, 其他一切配置都预备齐全。
 2. Aria2和Rclone多种联动模式，复制、移动、边做种边上传。
 3. Rclone以daemon方式运行，可在WebUI上手动传输文件和实时监测传输情况。
 4. Aria2和Rclone可以接入其它host上运行的AriaNg/RcloneNg等前端面板，方便多host集中管理控制。
 5. 每天自动更新Rclone配置文件变量，解决了token过期问题。
 6. 可指定每天dyno重启时间。
 7. 每隔5分钟自动备份相关配置文件到Rclone远程存储，dyno重启时尝试从远程恢复，实现了配置文件和下载任务列表的持久化。
 8. ttyd网页终端，可命令行执行lux视频下载工具和其它命令。
 9. log目录下有每个进程独立日志。
## 部署方式

 **请勿使用本仓库直接部署**  
 
  **Heroku修复安全漏洞中，目前无法通过网页从私有库部署**  
 
 **网页部署方式**
 1. 点击右上角Fork，再点击Creat Fork。
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。
 4. 比如你的Github用户名是bobby，新库名称是green。浏览器登陆heroku后，访问https://dashboard.heroku.com/new?template=https://github.com/bobby/green 即可部署。
 
 **Github Action 自动部署方式**
 
 详细指南见：https://github.com/AkhileshNS/heroku-deploy
 
 为安全和隐私考虑，至少设置以下secrets，其它变量在仓库根目录下.env文件中指定。Heroku API key从Heroku账户面板处获得。

![image](https://user-images.githubusercontent.com/98247050/164158114-0d9e65ab-3832-46e2-9ea8-0be9a384acf5.png)  
 
 如果从公开库部署，建议把用户名/密码等其它变量也加入secrets，修改/.github/workflows/heroku-deploy-release.yml文件，参照RCLONE_CONFIG_BASE64的写法调用。
 
 Secrets和变量设置好以后，点击Releases，选Draft a new release，tag填 v*.\*.\* 的格式，即可触发自动部署。  
 
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
| `HEROKU_API_KEY` | `` | Heroku账号API密钥，可选项，用于从dyno内部更新rclone配置文件变量。可从Heroku账号面板处获得，也可以用heroku cli命令heroku authorizations:create创建。 |
| `HEROKU_APP_NAME` | `` | Heroku APP名称，可选项，用于从dyno内部更新rclone配置文件变量。 |
| `RESTART_TIME` | `` | 指定更新Rclone配置文件的时间，用于配合上面两个变量，dyno也同时重启。格式为6:00，24小时制，前面不要加0，时区为TZ变量所指定的时区。 |
| `POST_MODE` | `move_remote` | 控制Aria2和Rclone联动模式,详细说明见下方。 |

 1. dummy模式为无操作，move模式为下载及做种完成后移动到本地finished目录。
 2. move_remote模式为下载及做种完成后先移动到本地data数据卷下finished目录，然后移动到rclone远程存储。
 3. move_remote_only模式为下载及做种完成后移动到rclone远程存储。
 4. copy_remote_first模式为下载完成后立即复制到rclone远程存储，BT任务在做种前即触发。
 5. copy_remote模式为下载及做种完成后先移动到本地finished目录，然后复制到rclone远程存储。
 6. custom模式为自行设置aria2配置文件触发脚本选项。
### 初次使用
 1. 部署完成后，比如你的heroku域名是bobby.herokuapp.com，导航页路径是/portal，访问bobby.herokuapp.com/portal 即可到达导航页。
 2. 点击AriaNg，这时会弹出认证失败警告，按下图把之前部署时设置的密码填入RPC密钥即可。
   ![image](https://user-images.githubusercontent.com/98247050/163184113-d0f09e78-01f9-4d4a-87b9-f4a9c1218253.png)
 3. lux多视频站下载工具通过ttyd网页终端执行，使用方法详细见：https://github.com/iawia002/lux  
    内置快捷指令：  
    luxa：使用aria2下载视频，速度更快，但部分视频和音频分离下载的站点（youtube、B站等）需要手动合并，下载完成后受POST_MODE变量控制。  
    merge：合并当前目录下视频和音频文件到remuxed目录下。
### 更多用法和注意事项
 1. Heroku每24小时重启后恢复到部署时文件系统，尽管配置文件会自动备份和尝试恢复，除了变量外任何改动都建议在部署前在github仓库内修改。
 2. 修改Heroku app变量方法：在Heroku app页面上点击setting，再点击Reveal Config Vars即可修改。
 3. 自动更新rclone配置文件token，需要指定HEROKU_API_KEY、HEROKU_APP_NAME、RESTART_TIME三个变量，而且dyno在指定的RESTART_TIME时间必须正在运行。
 4. RESTART_TIME变量指定dyno重启时间，需要HEROKU_API_KEY和HEROKU_APP_NAME变量配合才能工作。
 5. Rclone配置文件末尾加上如下内容，可以在Rclone Web前端中挂载本地存储，方便手动上传。
```
[local]
type = alias
remote = /mnt/data
```
 6. 无法通过Rclone Web前端建立需要网页认证的存储配置。
 7. content/aria2目录下，aria2_chs(en).conf为Aria2配置文件，按需要指定的语言环境变量选择版本修改。script.conf为Aria2自动化配置文件，可以设置aria2清理文件方式和Rclone上传目录。
 8. 每次dyno启动自动更新BT tracker list，如果需要禁用，重命名或删除/content/aria2/tracker.sh文件。
 9. content/homer_conf目录下是导航页设置文件homer_chs(en).yml和图标资源，新加入的图标，在设置文件中要以./assets/tools/example.png这样的路径调用。
 10. Vmess协议AlterID为0，可用Vmess WS 80端口或者Vmess WS tls 443端口连接。Xray设置可以通过content/service/xray/run文件修改。Heroku国内直连很难，需要使用Cloudflare或其它方式中转。
