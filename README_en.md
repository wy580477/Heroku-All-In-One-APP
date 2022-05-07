## Acknowledgments
- [alexta69/metube](https://github.com/alexta69/metube)  Simple and easy-to-use yt-dlp frontend.
- [P3TERX/aria2.conf](https://github.com/P3TERX/aria2.conf)  Rely on the Aria2 script from P3TERX to automatically trigger the Rclone upload after the Aria2 downloads completed.
- [wahyd4/aria2-ariang-docker](https://github.com/wahyd4/aria2-ariang-docker)  Inspiration for this project.
- [bastienwirtz/homer](https://github.com/bastienwirtz/homer)  A very simple static homepage for your server.
- [mayswind/AriaNg](https://github.com/mayswind/AriaNg) | [filebrowser/filebrowser](https://github.com/filebrowser/filebrowser) | [aria2/aria2](https://github.com/aria2/aria2) | [rclone/rclone](https://github.com/rclone/rclone) | [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp)
## Attention
 1. **Do not abuse heroku's service, or your account could get banned.**
 2. Aria2 download speed is limited to 5MB/s on default.
 3. Anyone who can login into this app has full access to data in this app and Rclone remotes. Do not share with other ppl, and do not store sensitive information with this app.

[Overview](#Overview) 

[Deployment](#Deployment) 

[First run](#first)  

[More usages and precautions](#more)  

## <a id="Overview"></a>Overview
This project integrates metube yt-dlp web frontend, Aria2 + WebUI, Rclone + WebUI with auto-upload function, customizable portal page, Filebrowser, ttyd web terminal, Xray Vmess proxy protocol.

![image](https://user-images.githubusercontent.com/98247050/165098261-7290ff50-ec0f-47ac-b8ec-7fe09f468a0e.png)

 1. Rclone auto-upload function only needs to prepare rclone.conf file, and all other configurations are set to go.
 2. Rclone have multiple auto-upload modes, copy, move, and uploading while seeding.
 3. YT-dlp Web front-end metube also supports Rclone auto-upload after downloading.
 4. Rclone runs on daemon mode, easy to manually transfer files and monitor transfers in real time on WebUI.
 5. You can connect Aria2 and Rclone from frontends such as AriaNg/RcloneNg running on other hosts.
 6. Auto-backup configuration files and task list to Rclone remote, and try to restore from Rclone remote when dyno restarts.
 7. ttyd web terminal, which can execute yt-dlp and other commands on the command line.
 8. There are independent logs for each service in the log directory.

## <a id="Deployment"></a>Deployment

 **Do not deploy directly from this repository**  
 
 1. Fork this this repository.
 2. Click Setting on fork repository page and check Template repository.
 3. Click new button: Use this template，create a new repository。
 4. For example, your Github username is bobby, and the new repository name is green. After logging in to heroku, visit https://dashboard.heroku.com/new?template=https://github.com/bobby/green to deploy.
 5. Detailed explanation of RCLONE_AUTO_MODE env:   
    dummy: Do nothing，move: Move files to local finished folder after Aria2 download & seeding completed.  
    move_remote: Move files to local finished folder after Aria2 download & seeding completed，then move to Rclone remote storage.  
    move_remote_only: Move files to Rclone remote storage after Aria2 download & seeding completed.  
    copy_remote_first: Copy files to Rclone remote storage after Aria2 download completed, triggered before seeding for bittorrent tasks.  
    copy_remote: Copy files to Rclone remote storage after Aria2 download & seeding completed.  
    custom: set Aria2 Event Hook options in aria2 configure file by yourself.     
    Under move_remote & move_remote_only modes, videos downloaded by mutube and dlpr command will be moved to Rclone remote storage.  
    Under copy_remote & copy_remote_first modes, videos downloaded by mutube and dlpr command will be copied to Rclone remote storage.  
 
## <a id="first"></a>First run
 1. After deployment, for example, your heroku domain name is bobby.herokuapp.com, the portal page path is /portal, then visit bobby.herokuapp.com/portal to reach the portal page.
 2. Click AriaNg, then authentication failure warning will pop up, fill in Aria2 secret RPC token with password set during deployment.  

![image](https://user-images.githubusercontent.com/98247050/165651080-b1b79ba6-7cc0-4c7c-b65b-fbc4256f59f9.png)  

 3. yt-dlp command can be executed through ttyd web terminal，for more information：https://github.com/yt-dlp/yt-dlp#usage-and-options  
    Built-in alias：  
    dlpr：Use yt-dlp to download videos to videos folder, then send task to Rclone after downloads completed. 
## <a id="more"></a>More usages and precautions
 1. Hit shift+F5 to force refresh if web services don't work properly. If app still doesn't work, clear cache and cookie of your heroku domain from browser.
 2. Heroku has ephemeral filesystem，although configuration files are automatically back up to Rclone remote and attempted to be restored after dyno restarted, any changes other than Config Vars are recommended to be modified in the github repository before deployment.
 3. How to modify Heroku Config Vars: Click setting on Heroku app page, then click Reveal Config Vars to modify.
 4. Add the following content to the end of the Rclone config file, you can add local heroku storage in Rclone Web UI for manual upload.
```
[local]
type = alias
remote = /mnt/data
```
 4. It is not possible to configure a Rclone remote which requires web authentication through Rclone web UI in this app.
 5. Rclone may fail to upload some videos with special characters in title, add following in the YTDL_OPTIONS env: "restrictfilenames":true
 6. Under content/aria2 directory in repository, aria2_en.conf is Aria2 config file, script.conf is Aria2 Event Hook config file which controls Aria2 auto-cleanup settings and Rclone auto-upload directory.
 7. BT tracker list is auto-updated each time dyno restarted, rename or delete /content/aria2/tracker.sh file to disable this function.
 8. Portal page config file homer_en.yml and icon resources are under content/homer_conf directory in repository, use path as ./assets/tools/example.png to add the new icon to homer config file.
 9. Vmess proxy protocol: AlterID is 0, you can connect to either Vmess WS port 80 or Vmess WS tls port 443. Xray settings can be modified via content/service/xray/run file in repository. Heroku is difficult to connect in Mainland China.     
   Example client setting:   
   ![image](https://user-images.githubusercontent.com/98247050/165655041-9fe1bada-be23-48f1-bcb3-57288e998035.png)    
   With tls:   
   ![image](https://user-images.githubusercontent.com/98247050/165655141-76846405-595d-4197-b020-e29d71e1f12c.png)


