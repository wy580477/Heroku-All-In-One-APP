## Acknowledgments
- [alexta69/metube](https://github.com/alexta69/metube)  Simple and easy-to-use yt-dlp frontend.
- [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)  Rely on the Aria2 script from P3TERX to automatically trigger the Rclone upload after the Aria2 downloads completed.
- [wahyd4/aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)  Inspiration for this project.
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  A very simple static homepage for your server.
- [mayswind/AriaNg](https://github.com/mayswind/AriaNg) | [filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) | [aria2/aria2](https://github.com/aria2/aria2) | [rclone/rclone](https://github.com/rclone/rclone) | [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)
## Attention
 1. **Do not abuse heroku's service, or your account could get banned.**
 2. Aria2 download speed is limited to 5MB/s on default.

[Overview](#Overview) 

[Deployment](#Deployment) 

[变量设置](#变量设置)  

[初次使用](#初次使用)  

[更多用法和注意事项](#更多用法和注意事项)  

## <a id="Overview"></a>Overview
This project integrates metube yt-dlp web frontend, Aria2 + WebUI, Rclone + WebUI with auto-upload function, customizable portal page, Filebrowser, ttyd web terminal, Xray Vmess proxy protocol.

![image](https://user-images.githubusercontent.com/98247050/165098261-7290ff50-ec0f-47ac-b8ec-7fe09f468a0e.png)

 1. Rclone auto-upload function only needs to prepare rclone.conf file, and all other configurations are set to go.
 2. Rclone have multiple auto-upload modes, copy, move, and uploading while seeding.
 3. YT-dlp Web front-end metube also supports Rclone auto-upload after downloading.
 4. Rclone runs on daemon mode, easy to manually transfer files on the WebUI and monitor transfers in real time.
 5. You can connect Aria2 and Rclone from frontends such as AriaNg/RcloneNg running on other hosts.
 6. Auto-backup configuration files and task list to Rclone remote, and try to restore from Rclone remote when dyno restarts.
 7. ttyd web terminal, which can execute yt-dlp and other commands on the command line.
 8. There are independent logs for each service in the log directory.

## <a id="Deployment"></a>Deployment

 **Do not deploy directly this repository**  
 
 1. Fork this this repository.
 2. Click Setting on fork repository page and check Template repository.
 4. Click new button: Use this template，create a new repository。
 5. For example, your Github username is bobby, and the new repository name is green. After logging in to heroku, visit https://dashboard.heroku.com/new?template=https://github.com/bobby/green to deploy.
 
### 变量设置
对部署时可设定的变量做如下说明。
| 变量| 说明 |
| :--- | :--- |
| `GLOBAL_USER` | 用户名，适用于所有需要输入用户名的页面 |
| `GLOBAL_PASSWORD` | 务必修改为强密码，同样适用于所有需要输入密码的页面，同时也是Aria2 RPC密钥。 |
| `GLOBAL_LANGUAGE` | 设置导航页和Filebrowser界面语言，chs为中文 |
| `GLOBAL_PORTAL_PATH` | 导航页路径和所有Web服务的基础URL，相当于密码之外多一层保护。不能为“/"和空值，结尾不能加“/" |
| `RCLONE_CONFIG_BASE64` | Rclone配置文件Base64编码，可使用linux系统base64命令或者在线base64工具生成 |
| `RCLONE_DRIVE_NAME` | Rclone远程存储配置名称，后面不要加冒号。默认值auto将从配置文件第一行中提取 |
| `RCLONE_AUTO_MODE` | 控制Aria2、metube和dlpr指令与Rclone联动模式，详细说明见下文 |
| `TZ` | 时区，Asia/Shanghai为中国时区 |
| `HEROKU_API_KEY` | Heroku账号API密钥，可选项，用于从dyno内部更新rclone配置文件变量，解决onedrive三个月后token过期问题。需要HEROKU_APP_NAME和HEROKU_RESTART_TIME变量配合，而且dyno在指定的HEROKU_RESTART_TIME必须正在运行。可从Heroku账号面板处获得，也可以用heroku cli命令heroku authorizations:create创建。 |
| `HEROKU_APP_NAME` | Heroku APP名称。 |
| `HEROKU_KEEP_AWAKE` | 设置为"true"可以阻止dyno空闲时休眠，需要HEROKU_APP_NAME变量配合。 |
| `HEROKU_RESTART_TIME` | 指定更新Rclone配置文件的时间，可选项，在指定的时间正在运行的dyno会重启。格式为6:00，24小时制，前面不要加0，时区为TZ变量所指定的时区。 |
| `YTDL_OPTIONS` | metube下载所使用的yt-dlp参数，默认值与rclone联动。更多参数详见[metube#configuration](https://github.com/alexta69/metube#configuration-via-environment-variables) |
| `YTDL_OUTPUT_TEMPLATE` | Metube下载输出文件名格式，详见[yt-dlp#output-template](https://github.com/yt-dlp/yt-dlp#output-template) |
| `VMESS_UUID` | Vmess协议UUID，务必修改，建议使用UUID工具生成 |
| `VMESS_PATH` | Vmess协议路径，不要包含敏感信息 |

 RCLONE_AUTO_MODE:  
 1. dummy模式为无操作，move模式为Aria2下载及做种完成后移动到本地finished目录。
 2. move_remote模式为Aria2下载及做种完成后先移动到本地data数据卷下finished目录，然后移动到rclone远程存储。
 3. move_remote_only模式为Aria2下载及做种完成后移动到rclone远程存储。
 4. copy_remote_first模式为Aria2下载完成后立即复制到rclone远程存储，BT任务在做种前即触发。
 5. copy_remote模式为Aria2下载及做种完成后先移动到本地finished目录，然后复制到rclone远程存储。
 6. custom模式为自行设置Aria2配置文件触发脚本选项。   
 
 两种move模式下mutube以及dlpr指令下载完成后会移动文件至rclone远程存储，两种copy模式下则为复制。  
 
### 初次使用
 1. 部署完成后，比如你的heroku域名是bobby.herokuapp.com，导航页路径是/portal，访问bobby.herokuapp.com/portal 即可到达导航页。
 2. 点击AriaNg，这时会弹出认证失败警告，按下图把之前部署时设置的密码填入RPC密钥即可。
   ![image](https://user-images.githubusercontent.com/98247050/163184113-d0f09e78-01f9-4d4a-87b9-f4a9c1218253.png)
 3. yt-dlp下载工具可以通过ttyd在网页终端执行，使用方法详细见：https://github.com/yt-dlp/yt-dlp#usage-and-options  
    内置快捷指令：  
    dlpr：使用yt-dlp下载视频到videos文件夹下，下载完成后发送任务到rclone，受POST_MODE变量控制。  
### 更多用法和注意事项
 1. Heroku每24小时重启后恢复到部署时文件系统，尽管config文件夹下配置文件会自动备份和尝试恢复，除了变量外任何改动都建议在部署前在github仓库内修改。
 2. 修改Heroku app变量方法：在Heroku app页面上点击setting，再点击Reveal Config Vars即可修改。
 3. Rclone配置文件末尾加上如下内容，可以在Rclone Web前端中挂载本地存储，方便手动上传。
```
[local]
type = alias
remote = /mnt/data
```
 4. 无法通过Rclone Web前端建立需要网页认证的存储配置。
 5. 个别标题有特殊字符的视频metube下载后rclone可能无法上传，需要在YTDL_OPTIONS变量中添加："restrictfilenames":true
 6. content/aria2目录下，aria2_chs(en).conf为Aria2配置文件，按需要指定的语言环境变量选择版本修改。script.conf为Aria2自动化配置文件，可以设置aria2清理文件方式和Rclone上传目录。
 7. 每次dyno启动自动更新BT tracker list，如果需要禁用，重命名或删除/content/aria2/tracker.sh文件。
 8. content/homer_conf目录下是导航页设置文件homer_chs(en).yml和图标资源，新加入的图标，在设置文件中要以./assets/tools/example.png这样的路径调用。
 9. Vmess协议AlterID为0，可用Vmess WS 80端口或者Vmess WS tls 443端口连接。Xray设置可以通过content/service/xray/run文件修改。Heroku国内直连很难，需要使用Cloudflare或其它方式中转。
