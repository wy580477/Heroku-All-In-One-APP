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
